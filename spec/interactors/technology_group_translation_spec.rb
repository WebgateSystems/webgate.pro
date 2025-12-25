# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TechnologyGroupTranslation, type: :interactor do
  let(:group) { create(:technology_group) }
  let(:current_locale) { :en }

  let(:mock_translation_response) do
    { 'title' => 'Group title EN', 'description' => 'Group description EN' }
  end

  before do
    allow_any_instance_of(EasyAccessGpt::Translation::SingleLocale)
      .to receive(:call).and_return(mock_translation_response)

    I18n.with_locale(:pl) do
      group.update!(title: 'PL tytuł', description: 'PL opis')
    end

    allow_any_instance_of(described_class).to receive(:sleep)
  end

  describe '.call' do
    it 'creates translations for missing locales' do
      described_class.call(model: group, current_locale:)
      group.reload

      I18n.available_locales.each do |locale|
        next if locale == :pl

        tr = group.translations.find_by(locale: locale.to_s)
        expect(tr).to be_present
        expect(tr.title).to be_present
        expect(tr.description).to be_present
      end
    end

    it 'force translates a single locale by overwriting existing translation' do
      I18n.with_locale(:de) { group.update!(title: 'OLD', description: 'OLD') }
      old = group.translations.find_by(locale: 'de')
      expect(old).to be_present
      expect(old.title).to eq('OLD')

      described_class.call(model: group, current_locale:, force_locale: :de)
      group.reload
      tr = group.translations.find_by(locale: 'de')
      expect(tr.title).to eq('Group title EN')
    end

    it 'fails for invalid locale' do
      result = described_class.call(model: group, current_locale:, force_locale: :invalid)
      expect(result).to be_failure
      expect(result.error).to eq('Invalid locale: invalid')
    end

    it 'fails when base has description but GPT response misses it' do
      allow_any_instance_of(EasyAccessGpt::Translation::SingleLocale)
        .to receive(:call).and_return({ 'title' => 'Only title' })

      result = described_class.call(model: group, current_locale:, force_locale: :ua)
      expect(result).to be_failure
      expect(result.error).to include('Missing fields in translated content for locale ua: description')
    end

    it 'uses another locale as base when PL is missing' do
      group.translations.where(locale: 'pl').destroy_all
      I18n.with_locale(:en) { group.update!(title: 'EN base', description: 'EN base desc') }

      result = described_class.call(model: group, current_locale:)
      expect(result).to be_success
    end

    it 'retries once on JSON::ParserError then succeeds' do
      calls = 0
      allow_any_instance_of(EasyAccessGpt::Translation::SingleLocale)
        .to receive(:call) do
          calls += 1
          raise JSON::ParserError, 'bad' if calls == 1

          mock_translation_response
        end

      result = described_class.call(model: group, current_locale:, force_locale: :de)
      expect(result).to be_success
    end

    it 'retranslates when translation is identical to base' do
      I18n.with_locale(:de) { group.update!(title: 'PL tytuł', description: 'PL opis') }

      described_class.call(model: group, current_locale:)
      group.reload
      tr = group.translations.find_by(locale: 'de')
      expect(tr.title).to eq('Group title EN')
    end

    it 'fails when there is no base translation in any locale' do
      group.translations.delete_all

      result = described_class.call(model: group, current_locale:)
      expect(result).to be_failure
      expect(result.error).to eq('No base translation found')
    end

    it 'does nothing when force_locale is the same as base locale' do
      result = described_class.call(model: group, current_locale:, force_locale: :pl)
      expect(result).to be_success
    end

    it 'does not require description when base description is blank' do
      I18n.with_locale(:pl) { group.update!(description: '') }
      allow_any_instance_of(EasyAccessGpt::Translation::SingleLocale)
        .to receive(:call).and_return({ 'title' => 'Only title' })

      result = described_class.call(model: group, current_locale:, force_locale: :ua)
      expect(result).to be_success
      group.reload
      expect(group.translations.find_by(locale: 'ua')&.title).to eq('Only title')
    end

    it 'retries once on StandardError then succeeds' do
      calls = 0
      allow_any_instance_of(EasyAccessGpt::Translation::SingleLocale)
        .to receive(:call) do
          calls += 1
          raise StandardError, 'boom' if calls == 1

          mock_translation_response
        end

      result = described_class.call(model: group, current_locale:, force_locale: :fr)
      expect(result).to be_success
    end
  end
end
