class User < ActiveRecord::Base

  has_many :tasks, dependent: :destroy

  validates :email, uniqueness: { case_sensitive: false }, presence: true, email: { allow_blank: true }

  enum role: %i(admin user)

  scope :by_query, ->(query) do
    return all if query.blank?
    # rubocop:disable Style/ColonMethodCall
    where([%w(email).map {|a| "#{a} ilike :query" }.join(' OR '), query: "%#{CGI::unescape(query)}%"])
  end

  scope :by_role, ->(role) do
    return all unless role.in?(%w(admin user))
    if role.eql?('admin')
      admin
    else
      user
    end
  end

  include Authenticatable

  def self.filter(params = {})
    by_query(params[:query]).by_role(params[:role])
  end

end
