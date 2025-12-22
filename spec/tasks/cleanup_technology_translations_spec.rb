# frozen_string_literal: true

require 'rails_helper'
require 'rake'

RSpec.describe 'technologies:cleanup_translations', type: :task do
  let(:tech) { create(:technology) }

  before do
    Rake.application.rake_require 'tasks/cleanup_technology_translations'
    Rake::Task.define_task(:environment)

    I18n.with_locale(:pl) do
      tech.update!(description: "Opis\n\"", link: '"https://example.com"')
    end
  end

  after do
    Rake::Task['technologies:cleanup_translations'].reenable
  end

  it 'cleans description and link in place' do
    Rake::Task['technologies:cleanup_translations'].invoke(tech.id.to_s, 'pl', 'false')
    tech.reload

    I18n.with_locale(:pl) do
      expect(tech.description).to eq('Opis')
      expect(tech.link).to eq('https://example.com')
    end
  end
end
