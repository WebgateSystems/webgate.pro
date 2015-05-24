require 'rails_helper'

feature 'Select2 in technologies.', js: true do

  let(:user){create(:user)}
  let!(:technology_group) { create(:technology_group) }

  before do
    sign_in(user)
    visit admin_technologies_path
  end

  scenario 'Select2 script should work correct' do
    click_link ('New')
    fill_in 'technology[title]', with: 'TestTitleFull'
    fill_in 'technology[link]', with: 'https://example.com/tech'
    select2(TechnologyGroup.first.title,'#s2id_technology_technology_group_id')
    sleep 5
    click_button 'Save'
    expect(page).to have_content technology_group.title
  end

end
