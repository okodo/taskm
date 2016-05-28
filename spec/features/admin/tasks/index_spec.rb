require 'rails_helper'

feature 'Tasks index', js: true do
  describe 'admin' do
    let!(:user) { create(:user) }
    let!(:tasks) { create_list(:task, 5) }
    before { sign_in(user.email, user.password) }

    it 'should see all tasks' do
      visit admin_tasks_path
      expect(page).to have_css('table.table.table-striped tbody tr', visible: true, count: 5)
    end

    it 'should see all columns' do
      visit admin_tasks_path
      within('table.table.table-striped thead tr') do
        %i(id name description created_at email).each_with_index do |a, idx|
          expect(all('th')[idx].text).to be_eql(Task.human_attribute_name(a))
        end
      end
    end

    it_should_behave_like 'tasks_events'
  end

  describe 'user' do
    let!(:user) { create(:user, :not_admin) }
    let!(:tasks) { create_list(:task, 5, user: user) }
    let!(:not_allowed_tasks) { create_list(:task, 5) }
    before { sign_in(user.email, user.password) }

    it 'should see only own tasks' do
      visit admin_tasks_path
      expect(page).to have_css('table.table.table-striped tbody tr', visible: true, count: 5)
    end

    it 'should not see assignee columns' do
      visit admin_tasks_path
      within('table.table.table-striped thead tr') do
        expect(all('th').detect {|t| t.text.eql?(Task.human_attribute_name(:email)) }).to be_blank
      end
    end

    it_should_behave_like 'tasks_events'
  end
end
