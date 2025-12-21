require 'net/http'
require 'oga'
require 'addressable/uri'

include Rails.application.routes.url_helpers

Rails.application.routes.default_url_options[:host] = 'webgate.pro' if Rails.env.production?

def url_exist?(url_string)
  url = Addressable::URI.parse(url_string)
  http = create_http_connection(url)
  path = url.path.presence || '/'
  response = http.request_head(path)
  response.code == '200'
rescue StandardError
  false
end

def create_http_connection(url)
  port = url.port || (url.scheme == 'https' ? 443 : 80)
  http = Net::HTTP.new(url.host, port)
  http.use_ssl = (url.scheme == 'https')
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE if http.use_ssl
  http
end

namespace :spec do
  desc 'Check links'
  task check_links: :environment do
    log = ActiveSupport::Logger.new('log/check_links.log')
    doc = Oga.parse_xml(File.read('public/sitemaps/sitemap.xml'))
    sitemaps = []
    links = []
    doc.xpath('xmlns:sitemapindex/xmlns:sitemap/xmlns:loc').each { |s| sitemaps << s.text } # get all sitemaps
    sitemaps.each do |sitemap|
      # Use Addressable::URI to parse the full URL and extract the path
      sitemap_uri = Addressable::URI.parse(sitemap)
      # Extract relative path from the URL (e.g., /sitemaps/unspecified.xml)
      sitemap_path = sitemap_uri.path
      doc = Oga.parse_xml(File.read("public#{sitemap_path}"))
      doc.xpath('xmlns:urlset/xmlns:url/xmlns:loc').each do |l| # get all links in sitemap
        links << l.text
      end
    end
    links.each do |link|
      # Links from sitemap are already valid URLs, no encoding needed
      unless url_exist?(link)
        log.error "Link not found: #{link}"
        puts "Link not found: #{link}"
      end
    end
  end
end
