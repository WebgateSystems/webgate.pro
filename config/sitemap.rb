require 'cgi'

# Change this to your host. See the readme at https://github.com/lassebunk/dynamic_sitemaps
# for examples of multiple hosts and folders.
# Set default URL options to use HTTPS
unless Rails.application.routes.default_url_options[:protocol]
  Rails.application.routes.default_url_options[:protocol] =
    'https'
end
host 'webgate.pro'

sitemap :unspecified do
  url root_url, last_mod: Time.zone.now, change_freq: 'daily', priority: 1.0
end

ApplicationController::PUBLIC_LANGS.map(&:first).each do |l|
  sitemap "sitemap_#{l}".to_sym do
    I18n.with_locale(l) do
      url CGI.unescape(main_url), last_mod: Time.zone.now, change_freq: 'daily', priority: 1.0
      url CGI.unescape(portfolio_url), last_mod: Time.zone.now, change_freq: 'daily', priority: 1.0
      url CGI.unescape(team_url), last_mod: Time.zone.now, change_freq: 'daily', priority: 1.0
      # url CGI.unescape(feeds_url), last_mod: Time.zone.now, change_freq: 'daily', priority: 1.0

      Page.published.with_translations(l).each do |page|
        url root_url + page.shortlink, last_mod: page.updated_at, change_freq: 'daily', priority: 1.0
      end
    end
  end
end
