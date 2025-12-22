require 'simplecov'

SimpleCov.start 'rails' do
  add_filter '/app/helpers'
  add_filter '/app/jobs'
  add_filter '/app/models/ckeditor'
  add_filter 'app/uploaders/ckeditor_picture_uploader'
  add_filter 'app/uploaders/ckeditor_attachment_file_uploader'
  add_filter 'lib'

  minimum_coverage(95)

  # Update coverage badge in README after tests complete
  at_exit do
    result = SimpleCov.result

    # generate HTML report
    result.format!
    coverage = SimpleCov.result.covered_percent.round(1)
    color = case coverage
            when 90.. then 'brightgreen'
            when 80.. then 'green'
            when 70.. then 'yellow'
            when 60.. then 'orange'
            else 'red'
            end

    badge_url = "https://img.shields.io/badge/coverage-#{coverage}%25-#{color}"
    badge_markdown = "![Coverage](#{badge_url})"

    %w[README.md README.en.md README.ua.md].each do |readme|
      path = File.join(SimpleCov.root, readme)
      next unless File.exist?(path)

      content = File.read(path)
      updated = content.gsub(/!\[Coverage\]\([^)]*\)/, badge_markdown)
      File.write(path, updated) if content != updated
    end

    puts "\n📊 Coverage: #{coverage}% - Badge updated in README"
  end
end
