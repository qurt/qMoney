class Account < ActiveRecord::Base
  validates :value, presence: true, numericality: true
  validates :name, presence: true

  has_many :operations

  has_one :moneybox, :autosave => true, dependent: :destroy
  accepts_nested_attributes_for :moneybox, :allow_destroy => true
end
