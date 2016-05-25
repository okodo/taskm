require 'rails_helper'

describe Postman do
  describe '#password_forgotten' do
    let(:user) { create(:user) }

    it 'renders the receiver email' do
      user.password_forgotten
      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eql([user.email])
    end
  end
end
