require 'rails_helper'

feature 'Project in admin panel.' do
  let(:user) { create(:user) }
  let!(:project) { create(:project) }

  before do
    sign_in(user)
    3.times do
      project.technologies << [create(:technology)]
    end
    visit admin_project_path(project)
  end

  scenario 'Try drag and drop technologies on project show', js: true do
    dest_element = find('td', text: project.technologies[1].title)
    source_element = find('td', text: project.technologies[0].title)
    source_element.drag_to dest_element
    sleep 5 # wait for ajax complete
    page.all(:link, 'Show')[0].click
    expect(current_path).to eq admin_technology_path(project.technologies[1])
    visit admin_project_path(project)
    page.all(:link, 'Show')[0].click
    expect(current_path).to_not eq admin_technology_path(project.technologies[0])
  end
end
