class Account < ActiveRecord::Base
  validates :value, presence: true, numericality: true
  validates :title, presence: true
  has_many :operations
end
