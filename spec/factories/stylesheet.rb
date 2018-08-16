FactoryBot.define do
  factory :stylesheet do
    site
    css { '.page { border: 1px solid black }' }
  end
end
