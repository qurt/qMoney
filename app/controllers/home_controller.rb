class HomeController < ApplicationController
  def index
    account = 0
    if params.has_key?(:a)
      account = params[:a].to_i
    end
    @accounts = Account.order(:name)
    if account == 0
      @operations = Operation.order(created_at: :desc)
    else
      @operations = Account.find(account).operations
    end
  end
end
