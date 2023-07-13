require 'simplecov'

SimpleCov.start 'rails' do
  add_filter '/app/helpers'
  add_filter '/app/jobs'
  add_filter '/app/mailers'

  minimum_coverage(95)
end
