class Account < ActiveRecord::Base
  validates :value, presence: true, numericality: true
  validates :name, presence: true
  has_many :operations, :dependent => :destroy
end
