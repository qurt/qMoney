class Category < ActiveRecord::Base
  has_many :operations

  validates :title, :presence => true
end
