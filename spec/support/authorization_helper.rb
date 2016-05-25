def sign_in(email, password)
  visit new_session_path
  within('form#auth-form') do
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
  end
  click_button I18n.t('auth.sessions.new.form.submit')
  expect(page).to have_selector('#sign-out-link', visible: true, count: 1)
end

def sign_out
  click_link 'sign-out-link'
end

def hide_navbar
  page.execute_script("$('.navbar').hide();")
end

def expect_growl_alert(message)
  expect(page).to have_css('div.bootstrap-growl.alert.alert-danger', visible: true, count: 1, text: message)
end
