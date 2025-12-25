# frozen_string_literal: true

require 'rails_helper'
require 'rake'

RSpec.describe 'technology_groups:translate_missing', type: :task do
  let(:task_name) { 'technology_groups:translate_missing' }

  before do
    Rake.application.rake_require 'tasks/translate_technology_groups'
    Rake::Task.define_task(:environment)
    Rake::Task[task_name].reenable

    allow_any_instance_of(EasyAccessGpt::Translation::SingleLocale)
      .to receive(:call).and_return({ 'title' => 'T', 'description' => 'D' })
  end

  after do
    Rake::Task[task_name].reenable
  end

  it 'translates missing locales for all technology groups' do
    group = create(:technology_group)
    I18n.with_locale(:pl) { group.update!(title: 'PL', description: 'PL') }

    expect do
      Rake::Task[task_name].invoke
    end.not_to raise_error

    group.reload
    expect(group.translations.find_by(locale: 'de')).to be_present
  end

  it 'translates a single group and locale when args are provided' do
    group = create(:technology_group)
    I18n.with_locale(:pl) { group.update!(title: 'PL', description: 'PL') }

    expect do
      Rake::Task[task_name].invoke(group.id, 'de')
    end.not_to raise_error

    group.reload
    expect(group.translations.find_by(locale: 'de')&.title).to eq('T')
  end
end
