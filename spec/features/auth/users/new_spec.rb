require 'rails_helper'

feature 'Users new', js: true do
  describe 'form' do
    let!(:user) { create(:user) }
    before { sign_in(user.email, user.password) }

    it 'not create user cause validations errors' do
      visit new_user_path
      click_button 'Создать Пользователь'
      expect(page).to have_css('div.has-error')
    end

    it 'should create' do
      visit new_user_path
      within('form#new_user') do
        fill_in 'user_email', with: 'new@email.com'
        fill_in 'user_password', with: 'Pa55w0rd!'
        fill_in 'user_password_confirmation', with: 'Pa55w0rd!'
      end
      click_button 'Создать Пользователь'
      expect(page).to have_css('div.attr-title', count: 2)
    end
  end
end
