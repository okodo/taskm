class User < ActiveRecord::Base

  has_many :tasks, dependent: :destroy

  validates :email, uniqueness: { case_sensitive: false }, presence: true, email: { allow_blank: true }

  enum role: %i(admin user)

  include Authenticatable

end
