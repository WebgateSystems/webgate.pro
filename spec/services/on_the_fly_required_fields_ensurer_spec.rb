# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OnTheFlyRequiredFieldsEnsurer do
  subject(:ensurer) { described_class.new }

  describe '#ensure!' do
    it 'fills missing Project title from any available translation' do
      project = create(:project)
      project.translations.delete_all
      project.translations.find_or_initialize_by(locale: 'pl').tap do |t|
        t.title = 'PL title'
        t.content = '<p>PL</p>'
        t.save!
      end

      row = project.translations.find_or_initialize_by(locale: 'de')
      row.title = nil

      ensurer.ensure!(project, row)
      expect(row.title).to eq('PL title')
    end

    it 'fills missing Member required fields from any available translation' do
      member = create(:member)
      member.translations.delete_all
      member.translations.find_or_initialize_by(locale: 'pl').tap do |t|
        t.name = 'PL name'
        t.job_title = 'PL job'
        t.description = 'PL desc'
        t.motto = 'PL motto'
        t.education = 'PL edu'
        t.save!
      end

      row = member.translations.find_or_initialize_by(locale: 'de')
      row.name = nil
      row.job_title = nil
      row.description = nil
      row.motto = nil

      ensurer.ensure!(member, row)
      expect(row.name).to eq('PL name')
      expect(row.job_title).to eq('PL job')
      expect(row.description).to eq('PL desc')
      expect(row.motto).to eq('PL motto')
    end

    it 'fills missing Technology link from any available translation' do
      tech = create(:technology)
      tech.translations.delete_all
      tech.translations.find_or_initialize_by(locale: 'pl').tap do |t|
        t.link = 'https://example.com'
        t.save!
      end

      row = tech.translations.find_or_initialize_by(locale: 'de')
      row.link = nil

      ensurer.ensure!(tech, row)
      expect(row.link).to eq('https://example.com')
    end
  end
end
