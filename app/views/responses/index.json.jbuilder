json.array!(@responses) do |response|
  json.extract! response, :id, :category, :node, :time, :text, :rule_value, :value, :label, :phone
  json.url response_url(response, format: :json)
end
