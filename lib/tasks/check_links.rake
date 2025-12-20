require 'net/http'
require 'oga'

include Rails.application.routes.url_helpers

Rails.application.routes.default_url_options[:host] = 'webgate.pro' if Rails.env.production?

def url_exist?(url_string)
  url = URI.parse(url_string)
  req = Net::HTTP.new(url.host, url.port)
  req.use_ssl = (url.scheme == 'https')
  req.verify_mode = OpenSSL::SSL::VERIFY_NONE
  path = url.path if url.path.present?
  res = req.request_head(path || '/')
  res.code == '200' # true if returns 200 - ok
rescue Errno::ENOENT, Errno::ECONNREFUSED
  false # false if can't find the server
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
      doc = Oga.parse_xml(File.read("public#{URI.parse(sitemap).path}"))
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
