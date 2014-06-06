module OperationsHelper
  def is_selected(operation)
    if operation.account_id.nil?
      session[:last_account]
    else
      operation.account_id
    end
  end
end
