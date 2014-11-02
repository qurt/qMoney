class Operation < ActiveRecord::Base
  validates :value, presence: true, numericality: true
  
  belongs_to :account
  belongs_to :category

  self.inheritance_column = nil
end
