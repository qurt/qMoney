class Credit < ActiveRecord::Base
  validates :value, numericality: true, presence: true
  validates :name, presence: true
end
