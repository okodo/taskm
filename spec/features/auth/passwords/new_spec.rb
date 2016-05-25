require 'rails_helper'

feature 'New password', js: true do
  context 'errors' do
    it 'submit empty form' do
      visit new_password_path
      click_button I18n.t('auth.passwords.new.form.submit')
      expect(page).not_to have_css('ul.form-errors.alert-danger', visible: true, count: 1)
    end

    it 'wrong email' do
      visit new_password_path
      within('form#auth-form') do
        fill_in 'user_email', with: 'email@wrong.de'
      end
      click_button I18n.t('auth.passwords.new.form.submit')
      expect(page).to have_css('ul.form-errors.alert-danger', visible: true, count: 1)
    end
  end

  context 'should send email' do
    let!(:user) { create(:user) }

    it 'success' do
      visit new_password_path
      within('form#auth-form') do
        fill_in 'user_email', with: user.email
      end
      click_button I18n.t('auth.passwords.new.form.submit')
      expect(page).to have_css('div.bootstrap-growl.alert.alert-success', visible: true, count: 1, text: I18n.t('auth.reset_password.instruction_sent'))
    end
  end
end
