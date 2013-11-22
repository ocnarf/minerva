json.array!(@posts) do |post|
  json.extract! post, :url, :published, :feed_id, :site_id
  json.url post_url(post, format: :json)
end