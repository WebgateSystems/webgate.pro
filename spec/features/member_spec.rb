require 'rails_helper'

feature 'Member in admin panel.' do

  let(:user) { create(:user) }
  let!(:member0) { Member.create(name: 'TestName0', shortdesc: 'TestShortDesc0',
      description: 'TestDesc0', motto: 'TestMotto0',
      avatar: Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images',  'alex_dobr.jpg'))) }
  let!(:member1) { Member.create(name: 'TestName1', shortdesc: 'TestShortDesc1',
      description: 'TestDesc1', motto: 'TestMotto1',
      avatar: Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images',  'alex_dobr.jpg'))) }

  before do
    sign_in(user)
    visit '/admin/members'
  end

  scenario 'Try drag and drop on index', js: true do
    click_link ('New')
    fill_in 'member[name]', with: "TestName2"
    fill_in 'member[shortdesc]', with: "TestShortDesc2"
    fill_in 'member[description]', with: "TestDesc2"
    fill_in 'member[motto]', with: "TestMotto2"
    attach_file('member[avatar]', File.join(Rails.root, '/spec/fixtures/members/alex_dobr.jpg'))
    click_button 'Save'
    visit '/admin/members'
    dest_element = find('td', text: "TestName2")
    source_element = find('td', text: "TestName1")
    source_element.drag_to dest_element
    sleep 5 #wait for ajax complete
    page.all(:link, 'Show')[1].click
    expect(current_path).to eq "/admin/members/#{Member.last.id}"
    visit '/admin/members'
    page.all(:link, 'Show')[2].click
    expect(current_path).to_not eq "/admin/members/#{Member.last.id}"
  end

  scenario 'Link list should work good' do
    click_link('List')
    expect(current_path).to eq '/admin/members'
  end

  scenario 'Link new should work good' do
    click_link('New')
    expect(current_path).to eq '/admin/members/new'
  end

  scenario 'Member root path should have list of members' do
    expect(page).to have_content 'Name'
    expect(page).to have_content 'Created at'
    expect(page).to have_content 'TestName0'
    expect(page).to have_content 'TestName1'
  end

  scenario 'Member root path links show, edit should work' do
    page.all(:link, 'Show')[0].click
    expect(current_path).to eq "/admin/members/#{Member.first.id}"
    visit '/admin/members'
    page.all(:link, 'Edit')[0].click
    expect(current_path).to eq "/admin/members/#{Member.first.id}/edit"
  end

  scenario 'Link delete should delete member' do
    page.all(:link, 'Delete')[0].click
    expect(current_path).to eq current_path
  end

  scenario 'Show should display our member information' do
    click_link ('TestName0')
    expect(page).to have_content 'Name:'
    expect(page).to have_content 'TestName0'
    expect(page).to have_content 'Description:'
    expect(page).to have_content 'TestDesc0'
    expect(page).to have_content 'Short description:'
    expect(page).to have_content 'Motto:'
    expect(page).to have_content 'TestShortDesc0'
    expect(page).to have_content 'TestMotto0'
  end

  scenario 'Create member should create member' do
    click_link ('New')
    fill_in 'member[name]', with: 'TestNamePew'
    fill_in 'member[shortdesc]', with: 'TestShortDescPew'
    fill_in 'member[description]', with: 'TestDescPew'
    fill_in 'member[motto]', with: 'TestMottoPew'
    attach_file('member[avatar]', File.join(Rails.root, '/spec/fixtures/members/alex_dobr.jpg'))
    click_button 'Save'
    visit '/admin/members'
    expect(page).to have_content 'TestNamePew'
  end

  scenario 'Validation for new member' do
    click_link('New')
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end

  scenario 'Dont create member with empty fields' do
    click_link ('New')
    fill_in 'member[name]', with: 'Testname'
    visit '/admin/members'
    expect(page).to have_no_content 'Testname'
  end
end
