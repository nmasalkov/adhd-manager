class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable


  validates :login, presence: true, on: :create
  validates :password, presence: true, confirmation: true, length: { minimum: 6 }, on: :create
  validates :password_confirmation, presence: true, on: :create

  has_many :quests, dependent: :destroy
  has_many :rewards, dependent: :destroy
end
