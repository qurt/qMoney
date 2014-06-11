json.array!(@credits) do |credit|
  json.extract! credit, :id, :name, :value
  json.url credit_url(credit, format: :json)
end
