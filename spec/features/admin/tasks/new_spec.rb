require 'rails_helper'

feature 'Tasks new', js: true do
  describe 'admin' do
    let!(:user) { create(:user) }
    before { sign_in(user.email, user.password) }

    it 'not create task cause validations errors' do
      visit new_admin_task_path
      click_button 'Создать Задание'
      expect(page).to have_css('div.has-error')
    end

    it 'should create to other assignee' do
      create(:user)
      visit new_admin_task_path
      within('form#new_task') do
        fill_in 'task_name', with: 'New task'
        fill_in 'task_description', with: 'Description of new task'
        find('#task_user_id').find(:xpath, 'option[2]').select_option
        first('#task_attachments_attributes_0_data_file').set("#{Rails.root}/spec/test_files/test.pdf")
      end
      click_button 'Создать Задание'
      expect(page).to have_css('div.attr-title', count: 5)
    end
  end

  describe 'user' do
    let!(:user) { create(:user, :not_admin) }
    before { sign_in(user.email, user.password) }

    it 'not create task cause validations errors' do
      visit new_admin_task_path
      click_button 'Создать Задание'
      expect(page).to have_css('div.has-error')
    end

    it 'should create to other assignee' do
      visit new_admin_task_path
      within('form#new_task') do
        fill_in 'task_name', with: 'New task'
        fill_in 'task_description', with: 'Description of new task'
        first('#task_attachments_attributes_0_data_file').set("#{Rails.root}/spec/test_files/test.pdf")
      end
      click_button 'Создать Задание'
      expect(page).to have_css('div.attr-title', count: 4)
    end
  end
end
