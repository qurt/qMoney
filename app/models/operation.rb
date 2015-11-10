class TransferValidator < ActiveModel::Validator
    def validate(record)
        if record.account_id == record.transfer
            record.errors[:base] << "Нельзя переместить в самого себя"
        end
    end
end

class Operation < ActiveRecord::Base
    validates :value, presence: true, numericality: true
    validates_with TransferValidator

    belongs_to :account
    belongs_to :category

    self.inheritance_column = nil
end
