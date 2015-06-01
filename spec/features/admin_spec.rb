require 'rails_helper'

feature 'Admin panel' do
  let(:user) { create(:user) }

  scenario 'forbid access to dashboard without fill the correct login/password' do
    visit admin_root_path
    fill_in 'email', with: user.email
    fill_in 'password', with: 'wrong_password'
    click_button 'Log in'
    visit admin_root_path

    expect(current_path).to eq login_path
  end

  scenario 'displays dashboard after correct login' do
    visit admin_root_path
    login_user_post(user.email, 'secret')

    visit admin_root_path
    expect(current_path).to eq '/admin'
    within 'h1' do
      expect(page).to have_content 'Webgate Systems'
    end
    expect(page).to have_content 'Users'
    expect(page).to have_content 'Pages'
    expect(page).to have_content 'Menu'
    expect(page).to have_content 'Technology groups'
    expect(page).to have_content 'Technologies'
    expect(page).to have_content 'Projects'
    expect(page).to have_content 'Team members'
    expect(page).to have_content 'Logout'
  end

  scenario 'all link should work' do
    visit admin_root_path
    login_user_post(user.email, 'secret')
    ['Users','Pages','Technology groups','Technologies','Projects','Team members'].each do |name|
      visit admin_root_path
      page.all(:link,name)[0].click
      within ('h2') do
        expect(page).to have_content name.pluralize
      end
    end
  end

  scenario 'webgate systems should link to root' do
    visit admin_root_path
    login_user_post(user.email, 'secret')
    visit admin_root_path
    click_link('Webgate Systems')
    expect(current_path).to eq '/'
  end

  scenario 'lang link should work' do
    visit admin_root_path
    login_user_post(user.email, 'secret')
    ['PL', 'RU'].each do |lang|
      visit admin_root_path
      click_link(lang) unless I18n.locale.to_s == lang
      if lang == 'PL'
        expect(page).to have_content 'Użytkownicy'
        expect(page).to have_content 'Strony'
        expect(page).to have_content 'Menu'
        expect(page).to have_content 'Grupy technologii'
        expect(page).to have_content 'Technologie'
        expect(page).to have_content 'Projekty'
        expect(page).to have_content 'Członkowie zespołu'
        expect(page).to have_content 'Wyloguj'
      else
        expect(page).to have_content 'Пользователи'
        expect(page).to have_content 'Страницы'
        expect(page).to have_content 'Меню'
        expect(page).to have_content 'Группы технологий'
        expect(page).to have_content 'Технологии'
        expect(page).to have_content 'Проекты'
        expect(page).to have_content 'Члены команды'
        expect(page).to have_content 'Выйти'
      end
    end
  end
end
