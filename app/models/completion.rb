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
  # field :steps,   type: Array
  
  embeds_many :steps

  def self.primary_node_text(id)
    Record.where(primary: id).first.steps.first.text
  end


  def self.total_instances(id)
    Completion.where(primary: id).all.count
  end


  def self.flare(diagram)

  end

  def self.diagram(node)
    node2question = {}
    node2response = {}
    node2label   = {}
    hits         = {}

    Completion.all.group_by(&:ids).each do |arry|
      arry[1].each do |completion| 
        completion.steps.each do |s|

          if !!s.text
            s.text.rstrip!
            if s.type == "A"
              node2question[s.node] = s.text
            else # Type is R. Maintain record of responses with frequency 
              if !node2response[s.node]
                node2response[s.node] = {}
              end
              resp = s.text.strip.downcase.capitalize
              if resp.split.size == 1
                resp.sub!(/[!.?]$/,'')
                resp.sub!(/^['"]/,'')
                resp.sub!(/['"]$/,'')
              end
              resp = resp.strip.capitalize

              if !node2response[s.node][resp]
                node2response[s.node][resp] = 1
              else
                node2response[s.node][resp] = node2response[s.node][resp] + 1
              end
            end
          end
        end

        completion.values.each do |v|
          node2label[v['node']] = v['label']
        end
      end
    end

    Completion.all.each do |c|
      c.steps.each do |s|
        hits[s.node] = !!hits[s.node] ? hits[s.node] + 1 : 1
      end
    end


    arrays = Completion.where(primary: node).map(&:ids).uniq
    seen   = {}    
    nodes  = []
    links  = []

    arrays.each do |ar|
      ar.each_with_index do |e, i|
        unless seen[e]
          seen[e] = 1
          node2response[e] = node2response[e].sort_by {|key, value| value}.reverse if node2response[e]
          nodes << {name: e, id: e, text: node2question[e], label: node2label[e], hits: hits[e], responses: node2response[e]}
        end
        links << {source: e, target: ar[i+1]} unless (i+1) == ar.length
        #links << [{v: e, f:"#{e} _ #{node2question[e]}<div style=\"color:red; font-style:italic\">#{node2label[e]} #{node2response[e]}</div>"}, ar[i-1] || "", 'The President'] unless (i+1) == ar.length
      end
    end
    puts links
    return {nodes: nodes, links: links}
  end


  # def self.flare(node)
  #   arrays = Completion.where(primary: '49e02161-7fe5-4481-aaac-531ecd1c3e4f').map(&:ids).uniq
  #   first  = []
  #   arrays.each do |ar|
  #     ar.each_with_index do |e, i|
  #       path = []
  #       ar[0..(i-1)].each do |ee|
  #         path << ee
  #       end
  #       first << {name: e, path: path}
  #     end
  #   end
  # end
end
