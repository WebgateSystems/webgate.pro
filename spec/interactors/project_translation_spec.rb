# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectTranslation, type: :interactor do
  let(:project) { create(:project) }
  let(:current_locale) { :en }

  # Mock ChatGPT translation responses
  let(:mock_translation_response) do
    { 'content' => '<p>Project content in English</p>' }
  end

  before do
    # Mock EasyAccessGpt::Translation::SingleLocale
    allow_any_instance_of(EasyAccessGpt::Translation::SingleLocale)
      .to receive(:call).and_return(mock_translation_response)

    # Set up Polish base translation
    I18n.with_locale(:pl) do
      project.update!(
        content: '<p>Treść projektu po polsku</p>'
      )
    end

    # Avoid slow retry sleeps in tests (ProjectTranslation uses Kernel#sleep)
    allow_any_instance_of(described_class).to receive(:sleep)
  end

  describe '.call' do
    context 'when base translation exists' do
      it 'successfully translates missing locales' do
        result = described_class.call(model: project, current_locale:)

        expect(result).to be_success
      end

      it 'creates translations for missing locales' do
        # Verify initial state - only PL translation should exist
        expect(project.translations.count).to eq(1)
        expect(project.translations.find_by(locale: 'pl')).to be_present

        result = described_class.call(model: project, current_locale:)
        expect(result).to be_success

        project.reload
        # Should have translations for all locales
        expected_count = I18n.available_locales.count
        expected_msg = "Expected #{expected_count} translations, got #{project.translations.count}"
        expect(project.translations.count).to eq(expected_count), expected_msg

        I18n.available_locales.each do |locale|
          next if locale == :pl

          translation = project.translations.find_by(locale: locale.to_s)
          expect(translation).to be_present, "Translation for #{locale} should exist"
          expect(translation.content).to be_present
        end
      end
    end

    context 'when base translation does not exist' do
      before do
        project.translations.where(locale: 'pl').destroy_all
      end

      it 'fails with appropriate error' do
        result = described_class.call(model: project, current_locale:)

        expect(result).to be_failure
        expect(result.error).to eq('No base translation found')
      end
    end

    context 'when Polish base translation does not exist but another locale exists' do
      before do
        project.translations.where(locale: 'pl').destroy_all
        I18n.with_locale(:en) do
          project.update!(
            title: 'Base title',
            content: '<p>Base EN content</p>',
            livelink: project.livelink
          )
        end
      end

      it 'uses an available locale as base' do
        result = described_class.call(model: project, current_locale:)
        expect(result).to be_success
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
        result = described_class.call(model: project, current_locale:)
        expect(result).to be_success
        project.reload
        expect(project.translations.find_by(locale: 'de')).to be_present
      end
    end

    context 'when duplicate translations exist' do
      before do
        # Create duplicate translation (identical to Polish)
        # Get base title and livelink first
        base_title = I18n.with_locale(:pl) { project.title }
        base_livelink = project.livelink

        I18n.with_locale(:de) do
          project.update!(
            title: base_title, # Keep original title
            content: '<p>Treść projektu po polsku</p>',
            livelink: base_livelink # Keep original livelink
          )
        end
      end

      it 'deletes duplicate translations and retranslates' do
        described_class.call(model: project, current_locale:)

        project.reload
        translation = project.translations.find_by(locale: 'de')
        expect(translation).to be_present
        # Translation should be different from Polish after retranslation
        expect(translation.content).not_to eq('<p>Treść projektu po polsku</p>')
        expect(translation.content).to eq('<p>Project content in English</p>') # From mock
      end
    end

    context 'when content is very long' do
      let(:long_mock_response) do
        { 'content' => "<p>#{'B' * 3000}</p>" }
      end

      before do
        # Mock multiple calls for chunked translation
        allow_any_instance_of(EasyAccessGpt::Translation::SingleLocale)
          .to receive(:call).and_return(long_mock_response)

        long_content = "<p>#{'A' * 3000}</p>"
        I18n.with_locale(:pl) do
          project.update!(content: long_content)
        end
      end

      it 'splits content into chunks and translates separately' do
        result = described_class.call(model: project, current_locale:)

        expect(result).to be_success

        project.reload
        translation = project.translations.find_by(locale: 'en')
        expect(translation).to be_present
        expect(translation.content).to be_present
        expect(translation.content).to include('B') # From long_mock_response
      end
    end

    context 'when chunk translation fails once and then succeeds' do
      let(:long_content) { "<p>#{'A' * 3000}</p>" }

      before do
        I18n.with_locale(:pl) do
          project.update!(content: long_content)
        end

        calls = 0
        allow_any_instance_of(EasyAccessGpt::Translation::SingleLocale)
          .to receive(:call) do
            calls += 1
            raise JSON::ParserError, 'bad' if calls == 1

            { 'content' => "<p>#{'B' * 1500}</p>" }
          end
      end

      it 'retries chunk translation and still creates a translation' do
        result = described_class.call(model: project, current_locale:)
        expect(result).to be_success
        project.reload
        expect(project.translations.find_by(locale: 'en')).to be_present
      end
    end
  end
end
