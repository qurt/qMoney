class Category < ActiveRecord::Base
  has_many :operations

  validates :title, :presence => true
  validates :color, :uniqueness => true
end
