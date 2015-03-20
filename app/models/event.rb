class Event
  include Mongoid::Document
  field :entry, type: Hash
  field :ip,    type: String  
end
