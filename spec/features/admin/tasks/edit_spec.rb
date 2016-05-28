require 'rails_helper'

feature 'Tasks edit', js: true do
  describe 'form' do
    let!(:user) { create(:user) }
    let!(:task) { create(:task, :with_attachment) }
    before { sign_in(user.email, user.password) }

    it 'validations errors' do
      visit edit_admin_task_path(task)
      within("form#edit_task_#{task.id}") do
        fill_in 'task_name', with: ''
      end
      click_button 'Сохранить Задание'
      expect(page).to have_css('div.has-error')
    end

    it 'should save changes' do
      create(:user)
      visit edit_admin_task_path(task)
      within("form#edit_task_#{task.id}") do
        fill_in 'task_name', with: 'Changed task'
        fill_in 'task_description', with: 'Changed description of task'
        find('#task_user_id').find(:xpath, 'option[2]').select_option
        first('#task_attachments_attributes_0_data_file').set("#{Rails.root}/spec/test_files/test.pdf")
      end
      click_button 'Сохранить Задание'
      expect(page).to have_css('div.attr-title', count: 5)
    end
  end
end
