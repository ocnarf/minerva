json.array!(@social_metrics) do |social_metric|
  json.extract! social_metric, :context, :value, :minutes_since_publish, :post_id
  json.url social_metric_url(social_metric, format: :json)
end