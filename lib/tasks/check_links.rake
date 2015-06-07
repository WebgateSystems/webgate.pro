require 'net/http'
require 'nokogiri'

include Rails.application.routes.url_helpers

Rails.application.routes.default_url_options[:host] = 'webgate.pro' if Rails.env.production?

def url_exist?(url_string)
  url = URI.parse(url_string)
  req = Net::HTTP.new(url.host, url.port)
  req.use_ssl = (url.scheme == 'https')
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
    doc = Nokogiri::XML(File.read('public/sitemaps/sitemap.xml'))
    sitemaps = []
    links = []
    ns = { 'ns' => 'http://www.sitemaps.org/schemas/sitemap/0.9' }
    doc.xpath('/ns:sitemapindex/ns:sitemap/ns:loc', ns).each do |s| # get all sitemaps
      sitemaps << s.text
    end
    sitemaps.each do |sitemap|
      doc = Nokogiri::XML(File.read('public' + URI.parse(sitemap).path))
      doc.xpath('/ns:urlset/ns:url/ns:loc', ns).each do |l| # get all links in sitemap
        links << l.text
      end
    end
    links.each do |link|
      unless url_exist?(URI.escape(link))
        log.error 'Link not found: ' + link
        puts 'Link not found: ' + link
      end
    end
  end
end
