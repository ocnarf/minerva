json.array!(@hubs) do |hub|
  json.extract! hub, :url
  json.url hub_url(hub, format: :json)
end