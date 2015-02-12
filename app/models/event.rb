class Event
  include Mongoid::Document
  field :entry, type: Hash
  
  #after_save :get_nodes


  def get_nodes
    ar = JSON.parse(self.entry['steps'])
    ar.each do |e| 
      puts "#{e} \n\n #{e['node']}  #{e['text']} *****\n\n"
    end
  	# ar = self.entry['steps'].gsub(/"/, '').gsub(/(\[|\])/, '').split(/}, {/)
  	# puts ar.count
  	# puts "*****"
  end

end
