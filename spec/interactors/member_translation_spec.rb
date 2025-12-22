# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MemberTranslation, type: :interactor do
  let(:member) { create(:member) }
  let(:current_locale) { :en }

  # Mock ChatGPT translation responses
  let(:mock_translation_response) do
    {
      'name' => 'John Doe',
      'job_title' => 'Developer',
      'description' => 'Description in English',
      'motto' => 'Motto in English',
      'education' => 'Education in English'
    }
  end

  let(:mock_translation_response_symbol_keys) do
    {
      name: 'John Doe',
      job_title: 'Developer',
      description: 'Description in English',
      motto: 'Motto in English',
      education: 'Education in English'
    }
  end

  before do
    # Mock EasyAccessGpt::Translation::SingleLocale
    # Use allow_any_instance_of for more reliable mocking in tests
    allow_any_instance_of(EasyAccessGpt::Translation::SingleLocale)
      .to receive(:call).and_return(mock_translation_response)

    # Set up Polish base translation
    I18n.with_locale(:pl) do
      member.update!(
        name: 'Jan Kowalski',
        job_title: 'Programista',
        description: 'Opis po polsku',
        motto: 'Motto po polsku',
        education: 'Edukacja po polsku'
      )
    end

    # Avoid slow retry sleeps in tests (MemberTranslation uses Kernel#sleep)
    allow_any_instance_of(described_class).to receive(:sleep)
  end

  describe '.call' do
    context 'when base translation exists' do
      it 'successfully translates missing locales' do
        result = described_class.call(model: member, current_locale:)

        expect(result).to be_success
      end

      it 'creates translations for missing locales' do
        described_class.call(model: member, current_locale:)

        member.reload
        I18n.available_locales.each do |locale|
          next if locale == :pl

          translation = member.translations.find_by(locale: locale.to_s)
          expect(translation).to be_present, "Translation for #{locale} should exist"
          expect(translation.name).to be_present
          expect(translation.description).to be_present
        end
      end
    end

    context 'when Polish base translation does not exist but another locale exists' do
      before do
        member.translations.where(locale: 'pl').destroy_all
        I18n.with_locale(:en) do
          member.update!(
            name: 'John Base',
            job_title: 'Base Job',
            description: 'Base description',
            motto: 'Base motto',
            education: 'Base education'
          )
        end
      end

      it 'uses an available locale as base and translates missing locales' do
        result = described_class.call(model: member, current_locale:)

        expect(result).to be_success
        member.reload
        expect(member.translations.find_by(locale: 'de')).to be_present
      end
    end

    context 'when translation API fails once and then succeeds' do
      before do
        calls = 0
        allow_any_instance_of(EasyAccessGpt::Translation::SingleLocale)
          .to receive(:call) do
            calls += 1
            raise JSON::ParserError, 'bad' if calls == 1

            mock_translation_response
          end
      end

      it 'retries and still creates a translation' do
        result = described_class.call(model: member, current_locale:)
        expect(result).to be_success
        member.reload
        expect(member.translations.find_by(locale: 'de')).to be_present
      end
    end

    context 'when translation API returns symbol keys' do
      before do
        allow_any_instance_of(EasyAccessGpt::Translation::SingleLocale)
          .to receive(:call).and_return(mock_translation_response_symbol_keys)
      end

      it 'persists translated fields (does not fallback to Polish)' do
        result = described_class.call(model: member, current_locale:, force_locale: :de)
        expect(result).to be_success

        member.reload
        de_translation = member.translations.find_by(locale: 'de')
        expect(de_translation).to be_present
        expect(de_translation.name).to eq('John Doe')
      end
    end

    context 'when force_locale is provided' do
      it 'translates only the specified locale' do
        result = described_class.call(
          model: member,
          current_locale:,
          force_locale: :de
        )

        expect(result).to be_success

        member.reload
        translation = member.translations.find_by(locale: 'de')
        expect(translation).to be_present
        expect(translation.name).to be_present
        expect(translation.name).to eq('John Doe') # From mock
      end

      it 'deletes existing translation before retranslating' do
        # Create existing translation with all required fields
        I18n.with_locale(:de) do
          member.update!(
            name: 'Old Name',
            job_title: 'Old Job',
            description: 'Old Description',
            motto: 'Old Motto',
            education: 'Old Education'
          )
        end

        old_translation = member.translations.find_by(locale: 'de')
        expect(old_translation).to be_present
        expect(old_translation.name).to eq('Old Name')

        described_class.call(
          model: member,
          current_locale:,
          force_locale: :de
        )

        member.reload
        translation = member.translations.find_by(locale: 'de')
        expect(translation).to be_present
        expect(translation.name).not_to eq('Old Name')
        expect(translation.name).to eq('John Doe') # From mock
      end

      it 'fails for invalid locale' do
        result = described_class.call(
          model: member,
          current_locale:,
          force_locale: :invalid
        )

        expect(result).to be_failure
        expect(result.error).to eq('Invalid locale: invalid')
      end

      it 'skips when target locale is the same as base locale' do
        result = described_class.call(
          model: member,
          current_locale:,
          force_locale: :pl
        )

        expect(result).to be_success
        member.reload
        expect(member.translations.find_by(locale: 'de')).to be_nil
      end
    end

    context 'when a locale translation exists and is unique' do
      before do
        I18n.with_locale(:de) do
          member.update!(
            name: 'Einzigartig',
            job_title: 'Entwickler',
            description: 'Beschreibung',
            motto: 'Motto',
            education: 'Ausbildung'
          )
        end
      end

      it 'keeps the existing translation' do
        described_class.call(model: member, current_locale:)
        member.reload
        de_translation = member.translations.find_by(locale: 'de')
        expect(de_translation).to be_present
        expect(de_translation.name).to eq('Einzigartig')
      end
    end

    context 'when all fields are very long' do
      let(:long_text) { 'A' * 2500 }

      before do
        I18n.with_locale(:pl) do
          member.update!(
            name: long_text,
            job_title: long_text,
            description: long_text,
            motto: long_text,
            education: long_text
          )
        end
      end

      it 'translates long fields separately and creates a translation' do
        result = described_class.call(model: member, current_locale:, force_locale: :de)
        expect(result).to be_success
        member.reload
        expect(member.translations.find_by(locale: 'de')).to be_present
      end
    end

    context 'when base translation does not exist' do
      before do
        member.translations.where(locale: 'pl').destroy_all
      end

      it 'fails with appropriate error' do
        result = described_class.call(model: member, current_locale:)

        expect(result).to be_failure
        expect(result.error).to eq('No base translation found')
      end
    end

    context 'when duplicate translations exist' do
      before do
        # Create duplicate translation (identical to Polish)
        I18n.with_locale(:de) do
          member.update!(
            name: 'Jan Kowalski',
            job_title: 'Programista',
            description: 'Opis po polsku',
            motto: 'Motto po polsku',
            education: 'Edukacja po polsku'
          )
        end
      end

      it 'deletes duplicate translations and retranslates' do
        described_class.call(model: member, current_locale:)

        member.reload
        translation = member.translations.find_by(locale: 'de')
        expect(translation).to be_present
        # Translation should be different from Polish after retranslation
        expect(translation.name).not_to eq('Jan Kowalski')
        expect(translation.name).to eq('John Doe') # From mock
      end
    end
  end
end
