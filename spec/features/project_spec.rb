require 'rails_helper'

describe 'Project in admin panel.' do
  let(:user) { create(:user) }
  let!(:project0) do
    I18n.with_locale(:en) do
      Project.create(title: 'TestTitle0', content: 'TestContent0', livelink: 'http://test.webgate.pro',
                     collage: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/body.jpg').to_s))
    end
  end
  let!(:project1) do
    I18n.with_locale(:en) do
      Project.create(title: 'TestTitle1', content: 'TestContent1', livelink: 'http://test.webgate.pro',
                     collage: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/body.jpg').to_s))
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
    visit admin_projects_path
  end

  it 'Project root path should have list of projects' do
    visit admin_projects_path
    expect(page).to have_content 'Title'
    expect(page).to have_content 'Created at'
    expect(page).to have_content 'Publish'
    expect(page).to have_content 'TestTitle0'
    expect(page).to have_content 'TestTitle1'
  end

  # scenario 'Try drag and drop on index', js: true do
  #   click_link('New')
  #   fill_in 'project[title]', with: 'TestTitle2'
  #   fill_in_ckeditor 'Content', with: 'TestContent2'
  #   fill_in 'project[livelink]', with: 'http://test.webgate.pro'
  #   attach_file('project[collage]', File.join(Rails.root, '/spec/fixtures/projects/tested.jpg'))
  #   click_button 'Save'
  #   visit admin_projects_path
  #   dest_element = find('td', text: 'TestTitle2')
  #   source_element = find('td', text: 'TestTitle1')
  #   source_element.drag_to dest_element
  #   sleep 2
  #   page.all(:link, 'Show')[1].click
  #   expect(current_path).to eq admin_project_path(Project.last.id)
  #   visit admin_projects_path
  #   page.all(:link, 'Show')[2].click
  #   expect(current_path).to_not eq admin_project_path(Project.last.id)
  # end

  it 'Link list should work good' do
    visit new_admin_project_path
    click_link('List')
    expect(page).to have_current_path admin_projects_path, ignore_query: true
  end

  it 'Project root path links show, edit should work' do
    page.all(:link, 'Show')[0].click
    expect(page).to have_current_path admin_project_path(Project.first.id), ignore_query: true
    visit admin_projects_path
    page.all(:link, 'Edit')[0].click
    expect(page).to have_current_path edit_admin_project_path(Project.first.id), ignore_query: true
  end

  it 'Link delete should delete project' do
    page.all(:link, 'Delete')[0].click
    expect(page).to have_current_path current_path, ignore_query: true
  end

  it 'Show should display our project information' do
    # Use the link from the table row (project title is a link in the table)
    page.all(:link, 'TestTitle0').first.click
    expect(page).to have_content 'Title:'
    expect(page).to have_content 'TestTitle0'
    expect(page).to have_content 'Content:'
    expect(page).to have_content 'TestContent0'
    expect(page).to have_content 'http://test.webgate.pro'
  end

  it 'Create project should create project' do
    click_link('New')
    fill_in 'project[title]', with: 'TestTitleFull'
    fill_in 'project[content]', with: 'TestContentFull'
    fill_in 'project[livelink]', with: 'http://test.webgate.pro'
    attach_file('project[collage]', Rails.root.join('spec/fixtures/projects/tested.jpg').to_s)
    click_button 'Save'
    visit admin_projects_path
    click_link('TestTitleFull')
    expect(page).to have_content 'TestContentFull'
  end

  it 'Check publish. Here should be false' do
    expect(page).to have_content 'false'
  end

  # scenario 'Check publish. Here should be true', js: true do
  #   click_link('New')
  #   fill_in 'project[title]', with: 'TestTitleFull'
  #   fill_in_ckeditor 'Content', with: 'TestContentFull'
  #   fill_in 'project[livelink]', with: 'http://test.webgate.pro'
  #   attach_file('project[collage]', File.join(Rails.root, '/spec/fixtures/projects/tested.jpg'))
  #   find(:css, '#project_publish').set(true)
  #   click_button 'Save'
  #   visit admin_projects_path
  #   expect(page).to have_content 'true'
  # end

  it 'Validation for new project' do
    click_link('New')
    click_button 'Save'
    expect(page).to have_css('.alert-box.alert')
  end
end
