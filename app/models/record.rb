class Record
  include Mongoid::Document
  field :run,        type: Integer
  field :step,       type: String
  field :phone,      type: String
  field :text,       type: String
  field :flow,       type: Integer
  field :relayer,    type: BigDecimal 
  field :channel,    type: BigDecimal
  field :values,     type: Array
  field :primary,    type: String
  field :ids,        type: Array
  field :arrived_on, type: DateTime
  field :left_on,    type: DateTime
  field :created_at, type: DateTime
  field :ip,         type: String  
  # field :steps,   type: Array
  
  embeds_many :steps

  def self.primary_node_text(id)
    Record.where(primary: id).first.steps.first.text
  end

  def self.last_event_date(id)
    record = Record.where(primary: id).last
    return record.created_at ? record.created_at.strftime('%c') : record.arrived_on.strftime('%c')
  end

  def self.first_event_date(id)
    record = Record.where(primary: id).first
    return record.created_at ? record.created_at.strftime('%c') : record.arrived_on.strftime('%c')
  end


end
