# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TranslationWorker do
  describe '#perform' do
    before do
      allow(Rails.logger).to receive(:debug)
      allow(Rails.logger).to receive(:error)
    end

    it 'uses ProjectTranslation for Project' do
      project = create(:project)
      result = Class.new do
        def success? = true
        def failure? = false
        def error = nil
      end.new
      allow(ProjectTranslation).to receive(:call).and_return(result)

      described_class.new.perform('Project', project.id, 'pl')

      expect(ProjectTranslation).to have_received(:call).with(model: project, current_locale: 'pl')
    end

    it 'uses AddTranslation for non-Project models' do
      member = create(:member)
      allow(AddTranslation).to receive(:call)

      described_class.new.perform('Member', member.id, 'pl')

      expect(AddTranslation).to have_received(:call).with(model: member, current_locale: 'pl')
    end

    it 'logs error details when ProjectTranslation raises' do
      project = create(:project)
      allow(ProjectTranslation).to receive(:call).and_raise(StandardError, 'boom')

      described_class.new.perform('Project', project.id, 'pl')

      expect(Rails.logger).to have_received(:error).at_least(:once)
    end

    it 'logs ProjectTranslation error when result is failure' do
      project = create(:project)
      result = Class.new do
        def success? = false
        def failure? = true
        def error = 'err'
      end.new
      allow(ProjectTranslation).to receive(:call).and_return(result)

      described_class.new.perform('Project', project.id, 'pl')

      expect(ProjectTranslation).to have_received(:call).with(model: project, current_locale: 'pl')
    end
  end
end
