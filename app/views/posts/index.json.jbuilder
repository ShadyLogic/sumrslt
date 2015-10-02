json.array!(@posts) do |post|
  json.extract! post, :id, :post_id, :post_url, :blog_id
  json.url post_url(post, format: :json)
end
