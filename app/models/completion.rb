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
    arrays = Completion.where(primary: node).map(&:ids).uniq
    seen  = {}    
    nodes = []
    links = []    
    arrays.each do |ar|
      ar.each_with_index do |e, i|
        unless seen[e]
          seen[e] = 1
          nodes << {name: e, id: e}
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
