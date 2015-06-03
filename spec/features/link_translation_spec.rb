require 'rails_helper'

feature 'LinkTranslation in admin panel.' do
  let(:user) { create(:user) }
  let!(:link_translation) { create(:link_translation)}

  before do
    sign_in(user)
    visit admin_link_translations_path
  end

  scenario 'Link list should work good' do
    visit new_admin_link_translation_path
    click_link('List')
    expect(current_path).to eq admin_link_translations_path
  end

  scenario 'LinkTranslation root path should have list of links' do
    expect(page).to have_content link_translation.link
  end

  scenario 'LinkTranslation index path should have our link type' do
    expect(page).to have_content link_translation.link_type
  end

  scenario 'LinkTranslation index path links show, edit should work' do
    page.all(:link, 'Show')[0].click
    expect(current_path).to eq admin_link_translation_path(LinkTranslation.last.id)
    visit admin_link_translations_path
    page.all(:link, 'Edit')[0].click
    expect(current_path).to eq edit_admin_link_translation_path(LinkTranslation.last.id)
  end

  scenario 'Link delete should delete page' do
    page.all(:link, 'Delete')[0].click
    expect(current_path).to eq current_path
  end

  scenario 'Show should display our link information' do
    click_link (link_translation.link)
    expect(page).to have_content link_translation.link_type
  end

  scenario 'Create LinkTranslation should create' do
    click_link ('New')
    fill_in 'link_translation[link]', with: 'TestLink'
    click_button 'Save'
    visit admin_link_translations_path
    expect(page).to have_content 'TestLink'
  end

  scenario 'Validation for new link' do
    click_link('New')
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end
end
