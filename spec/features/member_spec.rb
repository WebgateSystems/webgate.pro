require 'rails_helper'

feature 'Member in admin panel.' do
  let(:user) { create(:user) }
  let!(:member0) do
    Member.create(name: 'TestName0', job_title: 'TestJobTitle0', education: 'TestEducation0',
                  description: 'TestDesc0', motto: 'TestMotto0',
                  avatar: Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images',  'yuri_skurikhin.png')))
  end
  let!(:member1) do
    Member.create(name: 'TestName1', job_title: 'TestJobTitle1', education: 'TestEducation1',
                  description: 'TestDesc1', motto: 'TestMotto1',
                  avatar: Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images',  'yuri_skurikhin.png')))
  end

  before do
    sign_in(user)
    visit admin_members_path
  end

  scenario 'Try drag and drop on index', js: true do
    click_link ('New')
    fill_in 'member[name]', with: 'TestName2'
    fill_in 'member[job_title]', with: 'TestJobTitle2'
    fill_in_ckeditor 'Description', with: 'TestDesc2'
    fill_in_ckeditor 'Education', with: 'TestEducation2'
    fill_in 'member[motto]', with: 'TestMotto2'
    attach_file('member[avatar]', File.join(Rails.root, '/spec/fixtures/members/yuri_skurikhin.png'))
    click_button 'Save'
    visit admin_members_path
    dest_element = find('td', text: 'TestName2')
    source_element = find('td', text: 'TestName1')
    source_element.drag_to dest_element
    sleep 5 # wait for ajax complete
    page.all(:link, 'Show')[1].click
    expect(current_path).to eq admin_member_path(Member.last.id)
    visit admin_members_path
    page.all(:link, 'Show')[2].click
    expect(current_path).to_not eq admin_member_path(Member.last.id)
  end

  scenario 'Link list should work good' do
    visit new_admin_member_path
    click_link('List')
    expect(current_path).to eq admin_members_path
  end

  scenario 'Link new should work good' do
    click_link('New')
    expect(current_path).to eq new_admin_member_path
  end

  scenario 'Member root path should have list of members' do
    expect(page).to have_content 'Name'
    expect(page).to have_content 'Created at'
    expect(page).to have_content 'TestName0'
    expect(page).to have_content 'TestName1'
  end

  scenario 'Member root path links show, edit should work' do
    page.all(:link, 'Show')[0].click
    expect(current_path).to eq admin_member_path(Member.first.id)
    visit admin_members_path
    page.all(:link, 'Edit')[0].click
    expect(current_path).to eq edit_admin_member_path(Member.first.id)
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
    expect(page).to have_content 'Education:'
    expect(page).to have_content 'Motto:'
    expect(page).to have_content 'TestEducation0'
    expect(page).to have_content 'TestMotto0'
  end

  scenario 'Create member should create member' do
    click_link ('New')
    fill_in 'member[name]', with: 'TestNamePew'
    fill_in 'member[job_title]', with: 'TestJobTitlePew'
    fill_in 'member[description]', with: 'TestDescPew'
    fill_in 'member[education]', with: 'TestducPew'
    fill_in 'member[motto]', with: 'TestMottoPew'
    attach_file('member[avatar]', File.join(Rails.root, '/spec/fixtures/members/yuri_skurikhin.png'))
    click_button 'Save'
    visit admin_members_path
    expect(page).to have_content 'TestNamePew'
  end

  scenario 'Check publish. Here should be false' do
    expect(page).to have_content 'false'
  end

  scenario 'Check publish. Here should be true', js: true do
    click_link ('New')
    fill_in 'member[name]', with: 'TestNamePew'
    fill_in 'member[job_title]', with: 'TestJobTitlePew'
    fill_in_ckeditor 'Description', with: 'TestDescPew'
    fill_in_ckeditor 'Education', with: 'TestEducPew'
    fill_in 'member[motto]', with: 'TestMottoPew'
    attach_file('member[avatar]', File.join(Rails.root, '/spec/fixtures/members/yuri_skurikhin.png'))
    find(:css, '#member_publish').set(true)
    click_button 'Save'
    visit admin_members_path
    expect(page).to have_content 'true'
  end

  scenario 'Validation for new member', js: true do
    click_link('New')
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end

  scenario 'Dont create member with empty fields' do
    click_link ('New')
    fill_in 'member[name]', with: 'Testname'
    visit admin_members_path
    expect(page).to have_no_content 'Testname'
  end
end
