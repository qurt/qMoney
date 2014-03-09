json.array!(@operations) do |operation|
  json.extract! operation, :id, :value, :type, :description, :account_id
  json.url operation_url(operation, format: :json)
end
