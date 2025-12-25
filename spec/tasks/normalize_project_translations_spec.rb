# frozen_string_literal: true

require 'rails_helper'
require 'rake'

RSpec.describe 'projects:normalize_translations', type: :task do
  let(:project) { create(:project) }

  before do
    Rake.application.rake_require 'tasks/cache'
    Rake.application.rake_require 'tasks/normalize_project_translations'
    Rake::Task.define_task(:environment)

    I18n.with_locale(:pl) do
      project.update!(title: 'Tytuł', content: '<p style="color:red">Polski</p>')
    end
    I18n.with_locale(:de) do
      project.update!(title: 'Titel', content: '<p style="color:red">Polski</p>')
    end

    allow(GptSettings).to receive(:key).and_return('test')

    allow_any_instance_of(GptTranslationRepairService).to receive(:call)
      .and_return('<p style="color:red" class="x">Deutsch</p>')
  end

  after do
    Rake::Task['projects:normalize_translations'].reenable
    Rake::Task['cache:expire_projects'].reenable
  end

  it 'updates target locale content with cleaned HTML' do
    Rake::Task['projects:normalize_translations'].invoke(project.id.to_s, 'de', 'false')
    project.reload

    de = project.translations.find_by(locale: 'de')
    expect(de).to be_present
    expect(de.content).to include('Deutsch')
    expect(de.content).not_to include('style=')
    expect(de.content).not_to include('class=')
  end

  it 'falls back to EN when PL is missing and still normalizes base locale' do
    project.translations.find_by(locale: 'pl')&.destroy
    project.reload

    I18n.with_locale(:en) do
      project.update!(title: 'Title', content: "<p style=\"color:red\">Base EN</p>\n\"")
    end
    I18n.with_locale(:fr) do
      project.update!(title: 'Titre', content: '<p style="color:red">Base EN</p>')
    end

    Rake::Task['projects:normalize_translations'].reenable
    Rake::Task['projects:normalize_translations'].invoke(project.id.to_s, 'fr', 'false')
    project.reload

    en = project.translations.find_by(locale: 'en')
    expect(en.content).not_to include('style=')
    expect(en.content).not_to include('"')

    fr = project.translations.find_by(locale: 'fr')
    expect(fr).to be_present
  end
end
