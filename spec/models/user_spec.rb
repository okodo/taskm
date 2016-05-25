require 'rails_helper'

describe User do
  subject { build(:user) }

  it { should respond_to(:email) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_length_of(:password).is_at_least(8).is_at_most(72) }
  it { should validate_presence_of(:password) }
  it { should validate_confirmation_of(:password) }
  it { should have_many(:tasks).dependent(:destroy) }

  context 'validate email format' do
    it { should allow_value('user@foo.COM', 'A_US-ER@f.b.org', 'frst.lst@foo.jp', 'a+b@baz.cn').for(:email) }
    it { should_not allow_value('user@foo,com', 'user_at_foo.org', 'example.user@foo.', 'foo@bar_baz.com', 'foo@bar+baz.com').for(:email) }
  end

  context 'enum role' do
    let(:user) { create(:user) }

    it 'default value' do
      expect(user.role).to be_eql('admin')
    end

    it 'valid by number' do
      user.role = 1
      expect(user).to be_valid
    end

    it 'valid by string' do
      user.role = 'user'
      expect(user).to be_valid
    end

    it 'valid by symbol' do
      user.role = :user
      expect(user).to be_valid
    end
  end

  describe 'authenticatable' do
    it 'validate password again' do
      subject.skip_validate_password = 1
      should_not validate_presence_of(:password)
    end

    it 'encrypte password' do
      expect(subject.encrypted_password).to be_blank
      subject.save
      expect(subject.encrypted_password).to be_present
    end

    it 'remember expired should be true' do
      subject.remember_created_at = 15.days.ago
      expect(subject.remember_expired?).to be_truthy
    end

    it 'remember expired should be false' do
      subject.remember_created_at = 14.days.ago
      expect(subject.remember_expired?).to be_falsey
    end

    context 'remember' do
      let!(:user) { create(:user) }
      it 'remember user' do
        expect(user.remember_created_at).to be_blank
        expect(user.remember_token).to be_blank
        user.remember_me
        expect(user.remember_created_at).to be_present
        expect(user.remember_token).to be_present
      end

      it 'should clear remember token' do
        user.remember_me
        user.clear_remember_token
        expect(user.remember_created_at).to be_blank
        expect(user.remember_token).to be_blank
      end

      it 'should clear remember token' do
        user.password_forgotten
        expect(user.reload.reset_password_sent_at).to be_present
        expect(user.reload.reset_password_token).to be_present
        user.clear_password_forgotten
        expect(user.reload.reset_password_sent_at).to be_blank
        expect(user.reload.reset_password_token).to be_blank
      end
    end

    it 'send email with edit password link' do
      user = create(:user)
      expect { user.password_forgotten }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    context 'valid password' do
      it 'should be invalid cause encrypted password blank' do
        expect(subject.valid_password?('Pa55w0rd!')).to be_falsey
      end

      it 'should be invalid cause wrong password' do
        subject.save
        expect(subject.valid_password?('wrong password')).to be_falsey
      end

      it 'should be valid' do
        subject.save
        expect(subject.valid_password?('Pa55w0rd!')).to be_truthy
      end
    end
  end

  describe 'scopes' do
    let!(:users) { create_list(:user, 5) }
    let!(:user) { create(:user, :not_admin) }

    it 'should find only one by query' do
      expect(User.filter(query: User.first.email).length).to be_eql(1)
    end

    it 'should find all by empty query' do
      expect(User.filter(query: nil).length).to be_eql(users.length + 1)
    end

    it 'should find all by given query' do
      expect(User.filter(query: 'factory.com').length).to be_eql(users.length + 1)
    end

    it 'should find all by empty role' do
      expect(User.filter(role: nil).length).to be_eql(users.length + 1)
    end

    it 'should find only users' do
      expect(User.filter(role: 'user').length).to be_eql(1)
    end

    it 'should find only admins' do
      expect(User.filter(role: 'admin').length).to be_eql(users.length)
    end
  end
end
