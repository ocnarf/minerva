json.array!(@posts) do |post|
  json.extract! post, :url, :published
  json.url post_url(post, format: :json)
end