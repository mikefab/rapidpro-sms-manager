json.array!(@completions) do |completion|
  json.extract! completion, :id, :run, :flow, :phone, :values, :steps, :step, :primary, :ids
  json.url completion_url(completion, format: :json)
end
