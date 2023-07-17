require 'simplecov'

SimpleCov.start 'rails' do
  add_filter '/app/helpers'
  add_filter '/app/jobs'
  add_filter '/app/mailers'
  add_filter '/app/models/ckeditor'
  add_filter 'app/uploaders/ckeditor_picture_uploader'
  add_filter 'app/uploaders/ckeditor_attachment_file_uploader'

  minimum_coverage(95)
end
