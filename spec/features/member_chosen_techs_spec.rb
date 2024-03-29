# require 'rails_helper'

# feature 'Member in admin panel.' do
#   let(:user) { create(:user) }
#   let!(:technology) { create(:technology) }

#   before do
#     sign_in(user)
#     visit admin_members_path
#   end

#   scenario 'Member should with assigned technology', js: true do
#     click_link('New')
#     fill_in 'member[name]', with: 'TestNamePew'
#     fill_in 'member[job_title]', with: 'TestJobTitlePew'
#     fill_in_ckeditor 'Description', with: 'TestDescPew'
#     fill_in_ckeditor 'Education', with: 'TestEducationPew'
#     fill_in 'member[motto]', with: 'TestMottoPew'
#     attach_file('member[avatar]', File.join(Rails.root, '/spec/fixtures/members/yuri_skurikhin.png'))
#     select technology.title, from: 'member_technology_ids', visible: false
#     click_button 'Save'
#     visit admin_members_path
#     click_link('TestNamePew')

#     expect(page).to have_content technology.title
#   end
# end
