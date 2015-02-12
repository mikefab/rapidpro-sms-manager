json.array!(@records) do |record|
  json.extract! record, :id, :run, :phone, :text, :flow, :relayer, :channel, :values, :steps, :step, :primary, :ids
  json.url record_url(record, format: :json)
end
