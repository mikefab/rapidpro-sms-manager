class Response
  include Mongoid::Document
  field :category,     type: String
  field :node,        type: String
  field :label,       type: String
  field :text,        type: String
  field :value,       type: String
  field :phone,       type: String 
  field :rule_value,  type: String
  field :time,        type: DateTime
end
