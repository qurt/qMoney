class RepeatOperation < ActiveRecord::Base
    self.inheritance_column = 'i_type'
end
