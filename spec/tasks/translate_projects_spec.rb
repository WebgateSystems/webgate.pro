# frozen_string_literal: true

require 'rails_helper'
require 'rake'

RSpec.describe 'projects:translate_missing', type: :task do
  let(:project) { create(:project) }
  let(:mock_translation_response) do
    { 'content' => '<p>Project content in English</p>' }
  end

  before do
    Rake.application.rake_require 'tasks/translate_projects'
    Rake.application.rake_require 'tasks/cache'
    Rake::Task.define_task(:environment)

    # Mock ChatGPT API
    # Use allow_any_instance_of for more reliable mocking in tests
    allow_any_instance_of(EasyAccessGpt::Translation::SingleLocale)
      .to receive(:call).and_return(mock_translation_response)

    I18n.with_locale(:pl) do
      project.update!(
        content: '<p>Treść projektu po polsku</p>'
      )
    end
  end

  after do
    Rake::Task['projects:translate_missing'].reenable
  end

  describe 'translate_missing' do
    it 'translates all projects to missing locales' do
      initial_count = project.translations.count
      Rake::Task['projects:translate_missing'].invoke
      project.reload
      expect(project.translations.count).to be > initial_count
    end
  end
end
