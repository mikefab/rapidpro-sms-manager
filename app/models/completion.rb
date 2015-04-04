class Completion
  include Mongoid::Document
  field :run,        type: Integer
  field :step,       type: String
  field :phone,      type: String
  field :text,       type: String
  field :flow,       type: Integer
  field :values,     type: Array
  field :primary,    type: String
  field :ids,        type: Array
  field :arrived_on, type: DateTime
  field :left_on,    type: DateTime
  field :created_at, type: DateTime
  field :ip,         type: String  
  field :status,     type: String
  field :urgency,        type: String
  field :soft_delete,    type: Boolean
  field :notes,          type: String
  field :explanation,    type: String
  field :is_public,      type: Boolean
  field :is_rumor,       type: Boolean
  # field :steps,   type: Array
  
  embeds_many :steps

  def self.rumors(current_or_deleted)
    Completion.where(
      is_rumor: true,
      soft_delete: current_or_deleted
      ).order_by(
        :arrived_on => 'desc'
      ) 
  end

  def self.primary_node_text(id)
    Completion.where(primary: id).first.steps.first.text
  end


  def self.total_instances(id)
    Completion.where(primary: id).all.count
  end

  def self.last_event_date(id)
    record = Completion.where(primary: id).last
    return record.created_at ? record.created_at.strftime('%c') : record.arrived_on.strftime('%c')
  end

  def self.first_event_date(id)
    record = Completion.where(primary: id).first
    return record.created_at ? record.created_at.strftime('%c') : record.arrived_on.strftime('%c')
  end

  def self.diagram(node)
    hits        = {}
    completions = Completion.where(primary: node)

    # Each step has an id. 
    # Create look up tables so we can reference a question, response or label with a node id
    node2question, node2response, node2label = node_indexes(node)

    # Keep track of how people reached each node
    completions.each do |c|
      c.steps.each do |s|
        hits[s.node] = !!hits[s.node] ? hits[s.node] + 1 : 1
      end
    end


    # Create diagram
    # The ids value per Completion is an array of nodes which map to a decision path of the flow
    arrays = completions.map(&:ids).uniq
    seen   = {}    
    nodes  = []
    links  = [] # AKA edges

    arrays.each do |ar|
      ar.each_with_index do |e, i|
        unless seen[e]
          seen[e] = 1

          # Format the responses with the number of hits per.
          node2response[e] = node2response[e].sort_by {
            |key, value| value
          }.reverse if node2response[e]

          # A node will either have a question (text) or response
          # A label is only present with a response
          nodes << {name: e, id: e, text: node2question[e], label: node2label[e], hits: hits[e], responses: node2response[e]}
        end
        links << {source: e, target: ar[i+1]} unless (i+1) == ar.length
       end
    end

    return {nodes: nodes, links: links}
  end



  def self.node_indexes(node)
    # Create look up tables
    node2question = {}
    node2response = {}
    node2label    = {}
    # Each Completion has a primary value, the id of the node of the first question answered in a survey.
    # Each completion an 'ids' attribute, an array of node ids like f48434b0-8871-4f7a-9339-41f96e2e7306
    # These ids map to a decision path
    Completion.where(primary: node).group_by(&:ids).each do |arry|
      # The first element is the array of ids
      # The second element is an array of Completions that contain the same array of ids.
      arry[1].each do |completion| 
        # steps are the questions and responses dialog.
        completion.steps.each do |s|
          if !!s.text
            s.text.rstrip!
            # 'A' I believe stands for 'Ask'
            if s.type == 'A'
              node2question[s.node] = s.text
            else # Type is R (response). Maintain record of responses with frequency 
              if !node2response[s.node]
                node2response[s.node] = {}
              end
              # Clean up responses
              response = clean_response s.text

              # Keep track of how many times a response was seen
              if !node2response[s.node][response]
                node2response[s.node][response] = 1
              else
                node2response[s.node][response] = node2response[s.node][response] + 1
              end
            end
          end
        end
        completion.values.each do |v|
          node2label[v['node']] = v['label']
        end
      end
    end
    return [node2question, node2response, node2label]
  end

  def self.clean_response(text)
    response = text.downcase.capitalize
    if response.split.size == 1
      response.sub!(/[!.?]$/,'')
      response.sub!(/^['"]/,'')
      response.sub!(/['"]$/,'')
    end
    response = response.strip.capitalize
  end
end
