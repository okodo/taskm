require 'rails_helper'

feature 'Edit password', js: true do
  context 'errors' do
    let!(:user) { create(:user) }
    before { user.password_forgotten }

    it 'without token' do
      visit edit_passwords_path
      expect_growl_alert(I18n.t('auth.reset_password.wrong_token'))
    end

    it 'submit empty form' do
      visit edit_passwords_path(reset_password_token: user.reset_password_token)
      click_button I18n.t('save')
      expect(page).not_to have_css('ul.form-errors.alert-danger', visible: true, count: 1)
    end

    it 'validations errors' do
      visit edit_passwords_path(reset_password_token: user.reset_password_token)
      within('form#auth-form') do
        fill_in 'user_password', with: 'Pa55w0rd'
        fill_in 'user_password_confirmation', with: 'wrong password'
      end
      click_button I18n.t('save')
      expect(page).to have_css('ul.form-errors.alert-danger', visible: true, count: 1)
    end
  end

  context 'should change password' do
    let!(:user) { create(:user) }
    before { user.password_forgotten }

    it 'success' do
      visit edit_passwords_path(reset_password_token: user.reset_password_token)
      within('form#auth-form') do
        fill_in 'user_password', with: 'Munich123'
        fill_in 'user_password_confirmation', with: 'Munich123'
      end
      click_button I18n.t('save')
      expect(current_path).to be_eql(new_session_path)
    end
  end
end
