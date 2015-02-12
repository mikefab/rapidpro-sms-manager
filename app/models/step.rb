class Step
  include Mongoid::Document
  field :node,        type: String
  field :arrived_on,  type: DateTime
  field :left_on,     type: DateTime
  field :text,        type: String
  field :type,        type: String
  field :value,       type: String 

  embedded_in :record
  


end
