DynamicSitemaps.configure do |config|
  config.path = Rails.root.join('public')
  config.folder = 'sitemaps' # This folder is emptied on each sitemap generation
  config.index_file_name = 'sitemap.xml'
  config.always_generate_index = false # Makes sitemap.xml contain the sitemap
  # (e.g. site.xml) when only one sitemap
  #  file has been generated
  config.config_path = Rails.root.join('config', 'sitemap.rb')
  config.per_page = 50_000

  # Default is Google and Bing
  # config.search_engine_ping_urls << "http://customsearchengine.com/ping?url=%s"

  # Default is pinging only in production
  # config.ping_environments << "staging"
end
