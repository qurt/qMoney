class HomeController < ApplicationController
  def index
    account = 0
    if params.has_key?(:a)
      account = params[:a].to_i
    end
    now = Time.now
    start_date = Time.mktime(now.year, now.month)
    @accounts = Account.order(:name)
    if account == 0
      @operations = Operation.where('operations.created_at >= ?', start_date).order(created_at: :desc)
    else
      @operations = Account.find(account).operations
    end
  end
end
