require 'simplecov'

SimpleCov.start 'rails' do
  add_filter '/app/helpers'
  add_filter '/app/jobs'
  add_filter '/app/mailers'
  add_filter '/app/models/redactor_rails'
  add_filter 'app/uploaders/redactor_rails_document_uploader.rb'
  add_filter 'app/uploaders/redactor_rails_picture_uploader.rb'

  minimum_coverage(95)
end
