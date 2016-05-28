require 'rails_helper'

feature 'Users edit', js: true do
  describe 'form' do
    let!(:admin) { create(:user) }
    let!(:user) { create(:user) }
    before { sign_in(admin.email, admin.password) }

    it 'validations errors' do
      visit users_path
      find(:xpath, "//a[@href='#{edit_user_path(user)}']").click
      within("form#edit_user_#{user.id}") do
        fill_in 'user_email', with: ''
      end
      click_button 'Сохранить Пользователь'
      expect(page).to have_css('div.has-error')
    end

    it 'should change all attributes' do
      visit edit_user_path(user)
      within("form#edit_user_#{user.id}") do
        fill_in 'user_email', with: 'new@email.com'
        fill_in 'user_password', with: 'Pa55w0rd!'
        fill_in 'user_password_confirmation', with: 'Pa55w0rd!'
      end
      click_button 'Сохранить Пользователь'
      expect(page).to have_css('div.attr-title', count: 2)
    end

    it 'should change only email' do
      visit edit_user_path(user)
      within("form#edit_user_#{user.id}") do
        fill_in 'user_email', with: 'new@email.com'
      end
      click_button 'Сохранить Пользователь'
      expect(page).to have_css('div.attr-title', count: 2)
    end
  end
end
