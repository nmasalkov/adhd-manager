class Reward < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :probability, presence: true, numericality: { greater_than_or_equal_to: 0.1, less_than_or_equal_to: 99.9 }
end
