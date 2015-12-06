class Session < ActiveRecord::Base
    belongs_to :user

    def self.delete_old_tokens
        now = Time.now.to_i
        self.where('expired_in < ?', now).destroy_all
    end
end
