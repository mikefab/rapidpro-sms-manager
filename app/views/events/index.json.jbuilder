json.array!(@events) do |event|
  json.extract! event, :id, :entry
  json.url event_url(event, format: :json)
end
