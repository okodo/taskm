shared_examples_for 'unauthorized_resources' do |resource_name|
  let!(:resource) { create(resource_name.to_sym) }

  it '#index' do
    get :index
    expect(response).to redirect_to(new_session_path)
  end

  it '#show' do
    get :show, { id: resource.id }
    expect(response).to redirect_to(new_session_path)
  end

  it '#new' do
    get :new
    expect(response).to redirect_to(new_session_path)
  end

  it '#create' do
    put :create
    expect(response).to redirect_to(new_session_path)
  end

  it '#edit' do
    get :edit, { id: resource.id }
    expect(response).to redirect_to(new_session_path)
  end

  it '#update' do
    put :update, { id: resource.id }
    expect(response).to redirect_to(new_session_path)
  end

  it '#destroy' do
    delete :destroy, { id: resource.id }
    expect(response).to redirect_to(new_session_path)
  end
end

shared_examples_for 'authorized_no_perms_resources' do |_|
  let!(:user) { create(:user, :not_admin) }
  let!(:admin) { create(:user) }
  before { sign_in(user) }

  it '#index' do
    get :index
    expect(flash[:alert]).to be_eql(I18n.t('auth.errors.no_permissions'))
  end

  it '#show' do
    get :show, { id: user.id }
    expect(flash[:alert]).to be_eql(I18n.t('auth.errors.no_permissions'))
  end

  it '#new' do
    get :new
    expect(flash[:alert]).to be_eql(I18n.t('auth.errors.no_permissions'))
  end

  it '#create' do
    put :create, { user: { email: 'new@mail.de' } }
    expect(flash[:alert]).to be_eql(I18n.t('auth.errors.no_permissions'))
  end

  it '#edit not self' do
    get :edit, { id: admin.id }
    expect(flash[:alert]).to be_eql(I18n.t('auth.errors.no_permissions'))
  end

  it '#edit self' do
    get :edit, { id: user.id }
    expect(subject).to render_template(:edit)
  end

  it '#update not self' do
    put :update, { id: admin.id, user: { email: 'new@mail.de' } }
    expect(flash[:alert]).to be_eql(I18n.t('auth.errors.no_permissions'))
  end

  it '#update self' do
    put :update, { id: user.id, user: { email: 'new@mail.de' } }
    expect(flash[:notice]).to be_eql(I18n.t('users.successfully_updated_self'))
  end
end
