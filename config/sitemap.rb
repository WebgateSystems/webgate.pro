# Change this to your host. See the readme at https://github.com/lassebunk/dynamic_sitemaps
# for examples of multiple hosts and folders.
ApplicationController::PUBLIC_LANGS.map(&:first).each do |l|
  folder "sitemaps/#{l}"
  host 'webgate.pro'
  sitemap :site do
    I18n.with_locale(l) do
      url URI.unescape(main_url), last_mod: Time.now, change_freq: 'daily', priority: 1.0, hreflang: l
      url URI.unescape(portfolio_url), last_mod: Time.now, change_freq: 'daily', priority: 1.0
      url URI.unescape(team_url), last_mod: Time.now, change_freq: 'daily', priority: 1.0

      Page.with_translations(l).each do |page|
        url root_url + page.shortlink
      end

      #url feeds_url
      #Feed.published.each do |feed|
      #  url feed
      #end
    end
  end
  ping_with "https://#{host}/#{l}/sitemap.xml"
end
