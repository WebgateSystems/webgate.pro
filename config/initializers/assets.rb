Rails.application.config.assets.version = '1.1'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( ga.js )
Rails.application.config.assets.precompile += %w( admin.js )
Rails.application.config.assets.precompile += %w( contacts.js)

Rails.application.config.assets.precompile += %w( admin.css contacts.css)
%w( categories members pages projects technologies technology_groups users).each do |controller|
  Rails.application.config.assets.precompile += ["admin/#{controller}.js", "admin/#{controller}.css"]
end
Rails.application.config.assets.precompile += %w( style_mob.css )
Rails.application.config.assets.precompile += %w( ckeditor/* )
