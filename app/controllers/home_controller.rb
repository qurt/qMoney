class HomeController < ApplicationController
  def index
    account = 0
    if params.has_key?(:a)
      account = params[:a].to_i
    end
    @accounts = Account.all
    @sum = 0
    @accounts.each do |item|
      @sum += item.value
    end
    if account == 0
      @operations = Operation.all
    else
      @operations = Account.find(account).operations
    end
  end
end
