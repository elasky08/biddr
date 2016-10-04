class Auction < ApplicationRecord
  include AASM

  belongs_to :user
  has_many :bids

  validates :title, presence: true
  validates end_date, presence: true
  validates :reserve_price, presence: true

  aasm whiny_transition: false do
    state :draft, initial: true
    state :published
    state :cancelled
    state :won
    state :reserve_not_met
    state :reserve_met

    event :publish do
      transitions from: draft, to: :published
    end

    event :win do
      transitions from: [:draft, :published, to: :reserve_met]
    end
  end

  def published
    where(aasm_state: :published)
  end
end
