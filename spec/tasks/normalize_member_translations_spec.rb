# frozen_string_literal: true

require 'rails_helper'
require 'rake'

RSpec.describe 'members:normalize_translations', type: :task do
  let(:member) { create(:member) }

  before do
    Rake.application.rake_require 'tasks/cache'
    Rake.application.rake_require 'tasks/normalize_member_translations'
    Rake::Task.define_task(:environment)

    # Seed EN translation only (no PL)
    member.translations.where(locale: 'pl').delete_all
    member.translations.find_or_initialize_by(locale: 'en').tap do |t|
      t.name = 'John'
      t.job_title = 'Developer'
      t.description = '<p style="color:red">Hello</p>'
      t.motto = '"Motto"'
      t.education = '<p class="x">Edu</p>'
      t.save!
    end

    allow(Settings).to receive(:gpt_key).and_return('test')
    allow_any_instance_of(GptTranslationRepairService).to receive(:call)
      .and_return('<p style="color:red">Polski</p>')
  end

  after do
    Rake::Task['members:normalize_translations'].reenable
    Rake::Task['cache:expire_members'].reenable
  end

  it 'creates PL from EN and cleans HTML artifacts' do
    Rake::Task['members:normalize_translations'].invoke(member.id.to_s, 'pl', 'false')
    member.reload

    pl = member.translations.find_by(locale: 'pl')
    expect(pl).to be_present
    expect(pl.description).to include('Polski')
    expect(pl.description).not_to include('style=')
  end
end
