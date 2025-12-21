require 'rails_helper'

describe 'technology_group in admin panel.' do
  let(:user) { create(:user) }
  let!(:technology_group0) do
    I18n.with_locale(:en) do
      TechnologyGroup.create(title: 'TestTitle0', description: 'Test Description0')
    end
  end
  let!(:technology_group1) do
    I18n.with_locale(:en) do
      TechnologyGroup.create(title: 'TestTitle1', description: 'Test Description1')
    end
  end

  let(:return_params) do
    { 'pl' => { 'name' => 'Main', 'altlink' => '/', 'description' => nil },
      'en' => { 'name' => 'Main', 'altlink' => '/', 'description' => nil },
      'ru' => { 'name' => 'Main', 'altlink' => '/', 'description' => nil },
      'fr' => { 'name' => 'Main', 'altlink' => '/', 'description' => nil },
      'ua' => { 'name' => 'Main', 'altlink' => '/', 'description' => nil } }
  end

  before do
    I18n.locale = :en
    allow_any_instance_of(EasyAccessGpt::Translation::SingleLocale).to receive(:call).and_return(return_params)
    sign_in(user)
    visit admin_technology_groups_path
  end

  # it 'Try drag and drop on index' do
  #   click_link('New')
  #   fill_in 'technology_group[title]', with: 'TestTitle2'
  #   fill_in 'technology_group[description]', with: 'Test Description2'
  #   click_button 'Save'
  #   visit admin_technology_groups_path
  #   dest_element = find('td', text: 'TestTitle2')
  #   source_element = find('td', text: 'TestTitle1')
  #   source_element.drag_to dest_element
  #   sleep 2 # wait for ajax complete
  #   page.all(:link, 'Show')[1].click
  #   expect(page).to have_current_path admin_technology_group_path(TechnologyGroup.all[1].id), ignore_query: true
  #   visit admin_technology_groups_path
  #   page.all(:link, 'Show')[2].click
  #   expect(page).to have_no_current_path admin_technology_group_path(TechnologyGroup.all[1].id), ignore_query: true
  # end

  it 'Link list should work good' do
    visit new_admin_technology_group_path
    click_link('List')
    expect(page).to have_current_path admin_technology_groups_path, ignore_query: true
  end

  it 'Technology_group root path should have list of technology_groups' do
    expect(page).to have_content 'Title'
    expect(page).to have_content 'Created at'
    expect(page).to have_content 'TestTitle0'
    expect(page).to have_content 'TestTitle1'
  end

  it 'Users root path links show, edit should work' do
    page.all(:link, 'Show')[0].click
    expect(page).to have_current_path admin_technology_group_path(TechnologyGroup.first.id), ignore_query: true
    visit '/admin/technology_groups'
    page.all(:link, 'Edit')[0].click
    expect(page).to have_current_path edit_admin_technology_group_path(TechnologyGroup.first.id), ignore_query: true
  end

  it 'Link delete should delete technology_group' do
    page.all(:link, 'Delete')[0].click
    expect(page).to have_current_path current_path, ignore_query: true
  end

  it 'Show should display our technology_group info' do
    click_link('TestTitle0')
    expect(page).to have_content 'Title:'
    expect(page).to have_content 'TestTitle0'
    expect(page).to have_content 'Description:'
    expect(page).to have_content 'Test Description0'
  end

  it 'Create technology_group should create technology_groups' do
    click_link('New')
    fill_in 'technology_group[title]', with: 'TestTitleBrandNew'
    fill_in 'technology_group[description]', with: 'PewPewPew'
    click_button 'Save'
    visit admin_technology_groups_path
    expect(page).to have_content 'TestTitleBrandNew'
  end

  it 'Validation for new technology_group' do
    click_link('New')
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end
end
