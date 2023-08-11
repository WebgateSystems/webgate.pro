require 'rails_helper'

describe 'Page in admin panel.' do
  let(:user) { create(:user) }
  let!(:en_page) { create(:en_page) }

  let(:return_params) do
    { 'pl' => { 'name' => 'Main', 'altlink' => '/', 'description' => nil },
      'en' => { 'name' => 'Main', 'altlink' => '/', 'description' => nil },
      'ru' => { 'name' => 'Main', 'altlink' => '/', 'description' => nil },
      'fr' => { 'name' => 'Main', 'altlink' => '/', 'description' => nil },
      'ua' => { 'name' => 'Main', 'altlink' => '/', 'description' => nil } }
  end

  before do
    allow_any_instance_of(EasyAccessGpt::Translation::SingleLocale).to receive(:call).and_return(return_params)
    sign_in(user)
    visit admin_pages_path
  end

  it 'Link list should work good' do
    visit new_admin_page_path
    click_link('List')
    expect(page).to have_current_path admin_pages_path, ignore_query: true
  end

  it 'Page root path should have list of pages' do
    expect(page).to have_content 'Title'
    expect(page).to have_content 'Created at'
    expect(page).to have_content en_page.title
  end

  it 'Page root path links show, edit should work' do
    page.all(:link, 'Show')[0].click
    expect(page).to have_current_path admin_page_path(Page.first.id), ignore_query: true
    visit admin_pages_path
    page.all(:link, 'Edit')[0].click
    expect(page).to have_current_path edit_admin_page_path(Page.first.id), ignore_query: true
  end

  it 'Link delete should delete page' do
    page.all(:link, 'Delete')[0].click
    expect(page).to have_current_path current_path, ignore_query: true
  end

  it 'Show should display our page information' do
    click_link(en_page.title)
    expect(page).to have_content 'Title:'
    expect(page).to have_content en_page.title
    expect(page).to have_content 'Description:'
    expect(page).to have_content en_page.description
    expect(page).to have_content 'Shortlink:'
    expect(page).to have_content 'Keywords:'
    expect(page).to have_content 'Content:'
    expect(page).to have_content en_page.shortlink
    expect(page).to have_content en_page.keywords
    expect(page).to have_content en_page.content
  end

  it 'Create page should create page' do
    click_link('New')
    fill_in 'page[title]', with: 'TestTitleFull'
    fill_in 'page[shortlink]', with: 'TestlinkFull'
    fill_in 'page[description]', with: 'TestDescFull'
    fill_in 'page[keywords]', with: 'TestKeyWordFull'
    fill_in 'page[content]', with: 'TestContentFull'
    click_button 'Save'
    visit admin_pages_path
    expect(page).to have_content 'TestTitleFull'
  end

  it 'Validation for new page' do
    click_link('New')
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end
end
