# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.1'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( admin.js )
Rails.application.config.assets.precompile += %w( admin.css )
%w( categories members pages projects technologies technology_groups users).each do |controller|
  Rails.application.config.assets.precompile += ["/admin/#{controller}.js.coffee", "/admin/#{controller}.css"]
end
Rails.application.config.assets.precompile += %w( style_mob.css )
