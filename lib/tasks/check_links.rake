require 'net/http'
include Rails.application.routes.url_helpers
Rails.application.routes.default_url_options[:host] = 'localhost:3000' if Rails.env.development?

def url_exist?(url_string)
  url = URI.parse(url_string)
  req = Net::HTTP.new(url.host, url.port)
  req.use_ssl = (url.scheme == 'https')
  path = url.path if url.path.present?
  res = req.request_head(path || '/')
  res.code != '404' # false if returns 404 - not found
rescue Errno::ENOENT, Errno::ECONNREFUSED
  false # false if can't find the server
end

namespace :spec do
  desc 'Check links'
  task check_links: :environment do
    ApplicationController::PUBLIC_LANGS.map(&:first).each do |l|
      I18n.with_locale(l) do
        unless url_exist?(main_url)
          LinkErrorMailer.delay.link_error_mail(URI.unescape(main_url))
        end
        unless url_exist?(portfolio_url)
          LinkErrorMailer.delay.link_error_mail(URI.unescape(portfolio_url))
        end
        unless url_exist?(team_url)
          LinkErrorMailer.delay.link_error_mail(URI.unescape(team_url))
        end
        #unless url_exist?(feeds_url)
        #  LinkErrorMailer.delay.link_error_mail(URI.unescape(feeds_url))
        #end
        Page.published.with_translations(l).find_each do |page|
          unless url_exist?(URI.escape(root_url + page.shortlink))
            LinkErrorMailer.delay.link_error_mail(URI.unescape(root_url + page.shortlink))
          end
        end
      end
    end
  end
end
