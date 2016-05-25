class Task < ActiveRecord::Base

  include AASM

  belongs_to :user
  has_many :attachments, dependent: :destroy

  validates :user_id, :name, presence: true

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

end
