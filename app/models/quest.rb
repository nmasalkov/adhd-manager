class Quest < ApplicationRecord
  belongs_to :user

  enum status: { pending: 0, completed: 1 }

  validates :title, presence: true
  validates :status, presence: true
end
