json.array!(@nodes) do |node|
  json.extract! node, :id, :node, :arrived_on, :left_on, :text, :type, :value
  json.url node_url(node, format: :json)
end
