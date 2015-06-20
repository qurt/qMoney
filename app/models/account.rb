class Account < ActiveRecord::Base
  validates :value, presence: true, numericality: true
  validates :name, presence: true
  has_many :operations
  has_one :deposit
end
