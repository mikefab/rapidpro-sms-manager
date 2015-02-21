class Event
  include Mongoid::Document
  field :entry, type: Hash
  
end
