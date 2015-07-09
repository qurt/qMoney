json.array!(@moneyboxes) do |moneybox|
  json.extract! moneybox, :id, :summary, :current, :percentage, :name
  json.url moneybox_url(moneybox, format: :json)
end
