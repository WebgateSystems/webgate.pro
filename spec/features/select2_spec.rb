require 'rails_helper'

feature 'Select2 in technologies.',:js => true do
  let(:user){ create(:user) }
  let!(:technology_group0) { TechnologyGroup.create!(title: 'TestTitle0', description: 'Test Description0') }
  let!(:technology_group1) { TechnologyGroup.create!(title: 'TestTitle1', description: 'Test Description1') }
  let!(:technology_group2) { TechnologyGroup.create!(title: 'TestTitle2', description: 'Test Description2') }
  let!(:technology_group3) { TechnologyGroup.create!(title: 'TestTitle3', description: 'Test Description3') }
  before do
    sign_in(user)
    visit admin_technologies_path
  end
  scenario 'Select2 script should work correct. Should choose first' do
    click_link ('New')
    fill_in 'technology[title]', with: 'TestTitleFull'
    fill_in 'technology[link]', with: 'https://example.com/tech'
    select2(TechnologyGroup.first.title,'#s2id_technology_technology_group_id')
    sleep 5
    click_button 'Save'
    page.should have_content technology_group0.title
  end
  scenario 'Select2 script should work correct. Should choose last' do
    click_link ('New')
    fill_in 'technology[title]', with: 'TestTitleFull'
    fill_in 'technology[link]', with: 'https://example.com/tech'
    select2(TechnologyGroup.last.title,'#s2id_technology_technology_group_id')
    sleep 5
    click_button 'Save'
    page.should have_content technology_group3.title
  end
end
