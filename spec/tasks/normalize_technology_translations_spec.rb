# frozen_string_literal: true

require 'rails_helper'
require 'rake'

RSpec.describe 'technologies:normalize_descriptions', type: :task do
  let(:tech) { create(:technology) }

  before do
    Rake.application.rake_require 'tasks/normalize_technology_translations'
    Rake::Task.define_task(:environment)

    tech.translations.find_or_initialize_by(locale: 'pl').tap do |t|
      t.link = 'https://example.com'
      t.description = '<p style="color:red">Polski opis</p>'
      t.save!
    end
    tech.translations.find_or_initialize_by(locale: 'de').tap do |t|
      t.link = 'https://example.com'
      t.description = '<p style="color:red">Polski opis</p>'
      t.save!
    end

    allow(Settings).to receive(:gpt_key).and_return('test')
    allow_any_instance_of(GptTranslationRepairService).to receive(:call)
      .and_return('<p style="color:red" class="x">Deutscher Text</p>')
  end

  after do
    Rake::Task['technologies:normalize_descriptions'].reenable
  end

  it 'updates target locale description with cleaned HTML/text' do
    Rake::Task['technologies:normalize_descriptions'].invoke(tech.id.to_s, 'de', 'false')
    tech.reload

    de = tech.translations.find_by(locale: 'de')
    expect(de).to be_present
    expect(de.description).to include('Deutscher Text')
    expect(de.description).not_to include('style=')
    expect(de.description).not_to include('class=')
  end

  it 'falls back to EN when PL is missing and normalizes base locale too' do
    tech.translations.find_by(locale: 'pl')&.destroy
    tech.reload

    tech.translations.find_or_initialize_by(locale: 'en').tap do |t|
      t.link = 'https://example.com'
      t.description = "<p style=\"color:red\">Base EN desc</p>\n\""
      t.save!
    end
    tech.translations.find_or_initialize_by(locale: 'ru').tap do |t|
      t.link = 'https://example.com'
      t.description = '<p style="color:red">Base EN desc</p>'
      t.save!
    end

    Rake::Task['technologies:normalize_descriptions'].reenable
    Rake::Task['technologies:normalize_descriptions'].invoke(tech.id.to_s, 'ru', 'false')
    tech.reload

    en = tech.translations.find_by(locale: 'en')
    expect(en.description).not_to include('style=')
    expect(en.description).not_to include('"')

    pl = tech.translations.find_by(locale: 'pl')
    expect(pl).to be_present
  end
end
