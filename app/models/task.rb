class Task < ActiveRecord::Base

  include AASM

  belongs_to :user
  has_many :attachments, dependent: :destroy

  validates :user_id, :name, presence: true

  scope :by_query, ->(query) do
    return all if query.blank?
    # rubocop:disable Style/ColonMethodCall
    where([%w(name description).map {|a| "#{a} ilike :query" }.join(' OR '), query: "%#{CGI::unescape(query)}%"])
  end
  scope :by_assignee, ->(user_id) { where(user_id: user_id) if user_id.present? }
  scope :human_ordered, ->() do
    order(
      <<-SQL
        CASE WHEN tasks.state = 'started' then 1
             WHEN tasks.state = 'new' then 2
             WHEN tasks.state = 'finished' then 3
             ELSE 0
        end, tasks.created_at DESC
      SQL
    )
  end

  accepts_nested_attributes_for :attachments, reject_if: :reject_attachments?, allow_destroy: true
  delegate :email, to: :user

  aasm column: 'state' do
    state :new, initial: true
    state :started, :finished

    event :start do
      transitions from: :new, to: :started
    end

    event :finish do
      transitions from: :started, to: :finished
    end

    event :reopen do
      transitions from: %i(started finished), to: :new
    end
  end

  def self.filter(params = {})
    by_query(params[:query]).by_assignee(params[:assignee_id]).human_ordered
  end

  def reject_attachments?(attrs)
    attrs.slice(:id, :data_file, :data_file_cache).values.all?(&:blank?)
  end

  def build_attachments
    attachments.build if attachments.reject(&:marked_for_destruction?).blank?
  end

end
