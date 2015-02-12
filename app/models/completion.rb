class Completion
  include Mongoid::Document
  field :run,     type: Integer
  field :step,    type: String
  field :phone,   type: String
  field :text,    type: String
  field :flow,    type: Integer
  field :values,  type: Array
  field :primary, type: String
  field :ids,     type: Array
  # field :steps,   type: Array
  
  embeds_many :steps

  def self.primary_node_text(id)
    Record.where(primary: id).first.steps.first.text
  end


  def self.diagram(node)
    node2qustion = {}
    node2label   = {}
    hits         = {}

    Completion.all.group_by(&:ids).each do |arry|
      arry[1].each do |completion| 
        completion.steps.each do |s|
          puts "#{s.type} #{!!s.text} #{s.node}!!!!!"
          node2qustion[s.node] = s.text if !!s.text and s.type == "A"
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
          nodes << {name: e, id: e, text: node2qustion[e], label: node2label[e], hits: hits[e]}
        end
        links << {source: e, target: ar[i+1]} unless (i+1) == ar.length
      end
    end

    return {nodes: nodes, links: links}
  end


  def self.flare(node)
    arrays = Completion.where(primary: '49e02161-7fe5-4481-aaac-531ecd1c3e4f').map(&:ids).uniq
    first  = []
    arrays.each do |ar|
      ar.each_with_index do |e, i|
        path = []
        ar[0..(i-1)].each do |ee|
          path << ee
        end
        first << {name: e, path: path}
      end
    end
  end
end
