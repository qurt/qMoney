class Account < ActiveRecord::Base
  has_many :operations
end
