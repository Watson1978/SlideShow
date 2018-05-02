require './lib/slideshow.rb'
require 'net/http'
require 'uri'
require 'json'

# https://urashita.com/archives/8158 を参考にAPIキーと検索エンジンIDを設定してください。
custom_search_api_key = "APIキー"
search_engine_id = "検索エンジンID"

uri = URI(URI.escape("https://www.googleapis.com/customsearch/v1?key=#{custom_search_api_key}&cx=#{search_engine_id}&q=cat&hl=ja&searchType=image&start=1"))
res = Net::HTTP.get_response(uri)
json = JSON.parse(res.body)

Application.setup do |app|
  app.title = 'Slide Show'
  app.interval = 5.0
  app.photos = json['items'].map { |item| item["link"] }
end

Application.run
