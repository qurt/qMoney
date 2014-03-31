class Account < ActiveRecord::Base
  validates :value, presence: true
  has_many :operations
end
