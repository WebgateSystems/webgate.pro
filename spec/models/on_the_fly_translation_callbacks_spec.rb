# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OnTheFlyTranslationCallbacks do
  before do
    allow(GptSettings).to receive(:enabled?).and_return(true)
    allow(GptSettings).to receive(:key).and_return('test')
    allow_any_instance_of(GptTranslationRepairService).to receive(:call).and_return('X')
    OnTheFlyTranslation.enable!
  end

  after do
    OnTheFlyTranslation.disable!
  end

  it 'on create of first translation row translates from source locale to all other locales (Member)' do
    member = create(:member)
    member.translations.delete_all

    # Create first translation in UA (treat as new record)
    member.translations.create!(
      locale: 'ua',
      name: 'Імʼя',
      job_title: 'Dev',
      description: '<p>Opis</p>',
      motto: 'M',
      education: 'E'
    )

    expect(member.translations.find_by(locale: 'pl')).to be_present
    expect(member.translations.find_by(locale: 'en')).to be_present
  end

  it 'on update of PL translation propagates only changed fields (Member)' do
    member = create(:member)
    t_pl = member.translations.find_or_initialize_by(locale: 'pl')
    t_pl.name = 'A'
    t_pl.job_title = 'JT'
    t_pl.description = '<p>D</p>'
    t_pl.motto = 'M'
    t_pl.education = 'E'
    t_pl.save!

    member.translations.find_or_initialize_by(locale: 'de').tap do |t|
      t.name = 'DE old'
      t.job_title = 'DE old'
      t.description = 'DE old'
      t.motto = 'DE old'
      t.education = 'DE old'
      t.save!
    end

    # Update only motto in PL
    allow_any_instance_of(GptTranslationRepairService).to receive(:call).and_return('NEW')
    t_pl.update!(motto: 'M2')

    t_de = member.translations.find_by(locale: 'de')
    expect(t_de.motto).to eq('NEW')
    expect(t_de.name).to eq('DE old')
  end

  it 'on update of non-PL translation does not propagate (Member)' do
    member = create(:member)
    member.translations.find_or_initialize_by(locale: 'pl').tap do |t|
      t.name = 'PL'
      t.job_title = 'PL'
      t.description = 'PL'
      t.motto = 'PL'
      t.education = 'PL'
      t.save!
    end
    member.translations.find_or_initialize_by(locale: 'de').tap do |t|
      t.name = 'DE'
      t.job_title = 'DE'
      t.description = 'DE'
      t.motto = 'DE'
      t.education = 'DE'
      t.save!
    end

    allow_any_instance_of(GptTranslationRepairService).to receive(:call).and_return('SHOULD_NOT_HAPPEN')
    member.translations.find_by(locale: 'de').update!(motto: 'DE2')

    expect(member.translations.find_by(locale: 'pl').motto).to eq('PL')
  end

  it 'on create translates from source locale for Project (content only)' do
    project = create(:project)
    project.translations.delete_all

    translator = instance_double(OnTheFlyTranslator, translate_fields!: true)
    allow(OnTheFlyTranslator).to receive(:new).and_return(translator)

    project.translations.create!(
      locale: 'ua',
      title: 'T',
      content: '<p>UA</p>'
    )

    expect(translator).to have_received(:translate_fields!).at_least(:once)
  end

  it 'on update of PL translation propagates only content for Project' do
    project = create(:project)
    translator = instance_double(OnTheFlyTranslator, translate_fields!: true)
    allow(OnTheFlyTranslator).to receive(:new).and_return(translator)

    t_pl = project.translations.find_or_initialize_by(locale: 'pl')
    t_pl.title = 'T'
    t_pl.content = '<p>Old</p>'
    t_pl.save!

    t_pl.update!(content: '<p>New</p>')

    expect(translator).to have_received(:translate_fields!).at_least(:once)
  end

  it 'can infer the parent model from a translation row without calling project/member methods' do
    project = create(:project)
    t = project.translations.find_by(locale: 'pl')
    expect(t.respond_to?(:project)).to eq(false)

    # Should not raise when callback tries to fetch parent
    allow_any_instance_of(GptTranslationRepairService).to receive(:call).and_return('NEW')
    expect { t.update!(content: '<p>Changed</p>') }.not_to raise_error
  end
end
