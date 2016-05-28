unless User.exists?(email: 'init@admin.ru')
  FactoryGirl.create(:user, email: 'init@admin.ru', password: 'initialize', password_confirmation: 'initialize')
end
unless User.exists?(email: 'init@user.ru')
  FactoryGirl.create(:user, role: 'user', email: 'init@user.ru', password: 'initialize', password_confirmation: 'initialize')
end
