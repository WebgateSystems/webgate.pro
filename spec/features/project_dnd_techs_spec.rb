require 'rails_helper'

feature 'Project in admin panel.' do

  let(:user) { create(:user) }
  let!(:project) { create(:project) }
  let!(:technology_group) { create(:technology_group) }
  let!(:technology_1) { Technology.create(title: 'TestTech_1', link: 'http://example_tech.com/link', technology_group: technology_group, description: 'tech') }
  let!(:technology_2) { Technology.create(title: 'TestTech_2', link: 'http://example_tech.com/link', technology_group: technology_group, description: 'tech') }
  let!(:technology_3) { Technology.create(title: 'TestTech_3', link: 'http://example_tech.com/link', technology_group: technology_group, description: 'tech') }

  before do
    sign_in(user)
    project.technologies << [technology_1, technology_2, technology_3]
    visit admin_project_path(project)
  end

  scenario 'Try drag and drop technologies on project show', js: true do
    dest_element = find('td', text: technology_2.title)
    source_element = find('td', text: technology_1.title)
    source_element.drag_to dest_element
    sleep 5 #wait for ajax complete
    page.all(:link, 'Show')[0].click
    sleep 10
    expect(current_path).to eq admin_technology_path(technology_2)
    visit admin_project_path(project)
    page.all(:link, 'Show')[0].click
    expect(current_path).to_not eq admin_technology_path(technology_1)
  end
end
