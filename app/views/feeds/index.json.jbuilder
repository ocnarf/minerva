json.array!(@feeds) do |feed|
  json.extract! feed, :url, :hub_id
  json.url feed_url(feed, format: :json)
end