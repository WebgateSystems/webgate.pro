# frozen_string_literal: true

require 'rails_helper'
require 'rake'

RSpec.describe 'members:translate_missing', type: :task do
  let(:member) { create(:member) }
  let(:mock_translation_response) do
    {
      'name' => 'John Doe',
      'job_title' => 'Developer',
      'description' => 'Description in English',
      'motto' => 'Motto in English',
      'education' => 'Education in English'
    }
  end

  before do
    Rake.application.rake_require 'tasks/translate_members'
    Rake.application.rake_require 'tasks/cache'
    Rake::Task.define_task(:environment)

    # Mock ChatGPT API
    # Use allow_any_instance_of for more reliable mocking in tests
    allow_any_instance_of(EasyAccessGpt::Translation::SingleLocale)
      .to receive(:call).and_return(mock_translation_response)

    I18n.with_locale(:pl) do
      member.update!(
        name: 'Jan Kowalski',
        job_title: 'Programista',
        description: 'Opis po polsku',
        motto: 'Motto po polsku',
        education: 'Edukacja po polsku'
      )
    end
  end

  after do
    Rake::Task['members:translate_missing'].reenable
  end

  describe 'without arguments' do
    it 'translates all members to missing locales' do
      initial_count = member.translations.count
      Rake::Task['members:translate_missing'].invoke
      member.reload
      expect(member.translations.count).to be > initial_count
    end
  end

  describe 'with member_id and locale arguments' do
    it 'translates specific member to specific locale' do
      expect(member.translations.where(locale: 'de').count).to eq(0)
      Rake::Task['members:translate_missing'].invoke(member.id.to_s, 'de')
      member.reload
      expect(member.translations.where(locale: 'de').count).to eq(1)
      translation = member.translations.find_by(locale: 'de')
      expect(translation.name).to eq('John Doe') # From mock
    end

    it 'exits with error if member not found' do
      expect do
        Rake::Task['members:translate_missing'].invoke('99999', 'de')
      end.to raise_error(SystemExit)
    end

    it 'exits with error if locale is invalid' do
      expect do
        Rake::Task['members:translate_missing'].invoke(member.id.to_s, 'invalid')
      end.to raise_error(SystemExit)
    end
  end
end
