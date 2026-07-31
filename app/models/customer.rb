class Customer < ApplicationRecord
  has_many :orders, dependent: :restrict_with_error

  validates :name, presence: true
  validates :area, presence: true
  validates :level, presence: true
end
