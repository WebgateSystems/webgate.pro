require 'rails_helper'

feature 'technology_group in admin panel.' do
  let(:user) { create(:user) }
  before do
    visit '/admin'
    sign_in(user)
    visit '/admin/technology_groups'
    3.times do |t|
      click_link ('New')
      fill_in 'technology_group[title]', with: "TestTitle#{t}"
      fill_in 'technology_group[description]', with: "Test Description#{t}"
      click_button 'Save'
      visit '/admin/technology_groups'
    end
  end

  scenario 'Try drag and drop on index', js: true do
    visit '/admin/technology_groups'
    dest_element = find('td', text: "TestTitle2")
    source_element = find('td', text: "TestTitle1")
    source_element.drag_to dest_element
    sleep 5 #wait for ajax complete
    page.all(:link, 'Show')[1].click
    expect(current_path).to eq "/admin/technology_groups/#{TechnologyGroup.last.id}"
    visit '/admin/technology_groups'
    page.all(:link, 'Show')[2].click
    expect(current_path).to_not eq "/admin/technology_groups/#{TechnologyGroup.last.id}"
  end

  scenario 'Link list should work good' do
    click_link('List')
    expect(current_path).to eq '/admin/technology_groups'
  end

  scenario 'Link new should work good' do
    click_link('New')
    expect(current_path).to eq '/admin/technology_groups/new'
  end

  scenario 'Technology_group root path should have list of technology_groups' do
    expect(page).to have_content 'Title'
    expect(page).to have_content 'Created at'
    expect(page).to have_content 'TestTitle0'
    expect(page).to have_content 'TestTitle1'
    expect(page).to have_content 'TestTitle2'
  end

  scenario 'Users root path links show, edit should work' do
    page.all(:link, 'Show')[0].click
    expect(current_path).to eq "/admin/technology_groups/#{TechnologyGroup.first.id}"
    visit '/admin/technology_groups'
    page.all(:link, 'Edit')[0].click
    expect(current_path).to eq "/admin/technology_groups/#{TechnologyGroup.first.id}/edit"
  end

  scenario 'Link delete should delete technology_group' do
    page.all(:link, 'Delete')[0].click
    expect(current_path).to eq current_path
  end

  scenario 'Show should display our technology_group info' do
    click_link ('TestTitle0')
    expect(page).to have_content 'Title:'
    expect(page).to have_content 'TestTitle0'
    expect(page).to have_content 'Description:'
    expect(page).to have_content 'Test Description0'
  end

  scenario 'Create technology_group should create technology_groups' do
    click_link ('New')
    fill_in 'technology_group[title]', with: 'TestTitleBrandNew'
    fill_in 'technology_group[description]', with: 'PewPewPew'
    click_button 'Save'
    visit '/admin/technology_groups'
    expect(page).to have_content 'TestTitleBrandNew'
  end

  scenario 'Validation for new technology_group' do
    click_link('New')
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end
end
