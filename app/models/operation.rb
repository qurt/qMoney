class Operation < ActiveRecord::Base
  validates :value, presence: true
  
  belongs_to :account
  belongs_to :category

  self.inheritance_column = nil
end
