require 'rails_helper'

describe WelcomeController do
  context '#index' do
    let!(:tasks) { create_list(:task, 5) }

    it 'render view' do
      get :index
      expect(subject).to render_template(:index)
    end

    it 'order' do
      task = create(:task)
      get :index
      expect(assigns(:tasks).first).to eq(task)
    end

    it 'pagination' do
      allow(Task).to receive(:per_page).and_return(1)
      get :index
      expect(assigns(:tasks).length).to eq(1)
    end
  end
end
