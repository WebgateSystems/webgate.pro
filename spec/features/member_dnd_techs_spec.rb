require 'rails_helper'

feature 'Member in admin panel.' do
  let(:user) { create(:user) }
  let!(:member) { create(:member) }

  before do
    sign_in(user)
    3.times do
      member.technologies << [create(:technology)]
    end
    visit admin_member_path(member)
  end

  scenario 'Try drag and drop technologies on member show', js: true do
    dest_element = find('td', text: member.technologies[1].title)
    source_element = find('td', text: member.technologies[0].title)
    source_element.drag_to dest_element
    sleep 2
    page.all(:link, 'Show')[0].click
    expect(current_path).to eq admin_technology_path(member.technologies[1])
    visit admin_member_path(member)
    page.all(:link, 'Show')[0].click
    expect(current_path).to_not eq admin_technology_path(member.technologies[0])
  end
end
