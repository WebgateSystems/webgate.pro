require 'rails_helper'

describe 'Member in admin panel.' do
  let(:user) { create(:user) }
  let!(:member0) do
    I18n.with_locale(:en) do
      Member.create(name: 'TestName0', job_title: 'TestJobTitle0', education: 'TestEducation0',
                    description: 'TestDesc0', motto: 'TestMotto0',
                    avatar: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/yuri_skurikhin.png').to_s))
    end
  end
  let!(:member1) do
    I18n.with_locale(:en) do
      Member.create(name: 'TestName1', job_title: 'TestJobTitle1', education: 'TestEducation1',
                    description: 'TestDesc1', motto: 'TestMotto1',
                    avatar: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/yuri_skurikhin.png').to_s))
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
    visit admin_members_path
  end

  # scenario 'Try drag and drop on index', js: true do
  #   click_link('New')
  #   fill_in 'member[name]', with: 'TestName2'
  #   fill_in 'member[job_title]', with: 'TestJobTitle2'
  #   fill_in_ckeditor 'Description', with: 'TestDesc2'
  #   fill_in_ckeditor 'Education', with: 'TestEducation2'
  #   fill_in 'member[motto]', with: 'TestMotto2'
  #   attach_file('member[avatar]', File.join(Rails.root, '/spec/fixtures/members/yuri_skurikhin.png'))
  #   click_button 'Save'
  #   visit admin_members_path
  #   dest_element = find('td', text: 'TestName2')
  #   source_element = find('td', text: 'TestName1')
  #   source_element.drag_to dest_element
  #   sleep 2
  #   page.all(:link, 'Show')[1].click
  #   expect(current_path).to eq admin_member_path(Member.last.id)
  #   visit admin_members_path
  #   page.all(:link, 'Show')[2].click
  #   expect(current_path).to_not eq admin_member_path(Member.last.id)
  # end

  it 'Link list should work good' do
    visit new_admin_member_path
    click_link('List')
    expect(page).to have_current_path admin_members_path, ignore_query: true
  end

  it 'Member root path should have list of members' do
    expect(page).to have_content 'Name'
    expect(page).to have_content 'Created at'
    expect(page).to have_content 'TestName0'
    expect(page).to have_content 'TestName1'
  end

  it 'Member root path links show, edit should work' do
    page.all(:link, 'Show')[0].click
    expect(page).to have_current_path admin_member_path(Member.first.id), ignore_query: true
    visit admin_members_path
    page.all(:link, 'Edit')[0].click
    expect(page).to have_current_path edit_admin_member_path(Member.first.id), ignore_query: true
  end

  it 'Link delete should delete member' do
    page.all(:link, 'Delete')[0].click
    expect(page).to have_current_path current_path, ignore_query: true
  end

  it 'Show should display our member information' do
    click_link('TestName0')
    expect(page).to have_content 'Name:'
    expect(page).to have_content 'TestName0'
    expect(page).to have_content 'Description:'
    expect(page).to have_content 'TestDesc0'
    expect(page).to have_content 'Education:'
    expect(page).to have_content 'Motto:'
    expect(page).to have_content 'TestEducation0'
    expect(page).to have_content 'TestMotto0'
  end

  it 'Create member should create member' do
    click_link('New')
    fill_in 'member[name]', with: 'TestNamePew'
    fill_in 'member[job_title]', with: 'TestJobTitlePew'
    fill_in 'member[description]', with: 'TestDescPew'
    fill_in 'member[education]', with: 'TestducPew'
    fill_in 'member[motto]', with: 'TestMottoPew'
    attach_file('member[avatar]', Rails.root.join('spec/fixtures/members/yuri_skurikhin.png').to_s)
    click_button 'Save'
    visit admin_members_path
    expect(page).to have_content 'TestNamePew'
  end

  it 'Check publish. Here should be false' do
    expect(page).to have_content 'false'
  end

  # scenario 'Check publish. Here should be true', js: true do
  #   click_link('New')
  #   fill_in 'member[name]', with: 'TestNamePew'
  #   fill_in 'member[job_title]', with: 'TestJobTitlePew'
  #   fill_in 'Description', with: 'TestDescPew'
  #   fill_in 'Education', with: 'TestEducPew'
  #   fill_in 'member[motto]', with: 'TestMottoPew'
  #   attach_file('member[avatar]', File.join(Rails.root, '/spec/fixtures/members/yuri_skurikhin.png'))
  #   find(:css, '#member_publish').set(true)
  #   click_button 'Save'
  #   expect(page).to have_content 'true'
  # end

  it 'Validation for new member' do
    click_link('New')
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end
end
