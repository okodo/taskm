require 'active_support/concern'
require 'bcrypt'

module Authenticatable
  extend ActiveSupport::Concern

  included do
    validates :password, presence: { if: 'skip_validate_password.to_i.zero?' },
                         confirmation: { if: 'password.present?' },
                         length: { within: 8..72, allow_blank: true }
    validates :password_confirmation, presence: { if: 'password.present?' }

    attr_accessor :password, :password_confirmation, :skip_validate_password

    before_save :encrypte_password
  end

  module ClassMethods
    def sha_token
      o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
      salt = (0..50).map { o[rand(o.length)]  }.join
      OpenSSL::HMAC.hexdigest('SHA256', salt, SecureRandom.urlsafe_base64(15).tr('lIO0', 'sxyz'))
    end
  end

  def remember_expired?
    remember_created_at.present? && (remember_created_at + 2.weeks + 1.day).past?
  end

  def remember_me
    update_column(:remember_created_at, Time.now)
    loop do
      token = self.class.sha_token
      update_column(:remember_token, token) and break unless self.class.exists?(remember_token: token)
    end
  end

  def clear_remember_token
    update_columns(remember_token: nil, remember_created_at: nil)
  end

  def password_forgotten
    clear_remember_token
    update_column(:reset_password_sent_at, Time.now)
    loop do
      token = self.class.sha_token
      update_column(:reset_password_token, token) and break unless self.class.exists?(reset_password_token: token)
    end
    Postman.password_forgotten(self).deliver_now
  end

  def valid_password?(password)
    return false if encrypted_password.blank?
    bcrypt = ::BCrypt::Password.new(encrypted_password)
    password = ::BCrypt::Engine.hash_secret([password, Rails.configuration.pepper].join, bcrypt.salt)
    password.secure_eql?(encrypted_password)
  end

  private

  def encrypte_password
    self.encrypted_password = ::BCrypt::Password.create([password, Rails.configuration.pepper].join, cost: 10).to_s if password.present?
  end

end
