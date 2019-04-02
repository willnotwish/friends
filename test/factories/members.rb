FactoryBot.define do
  factory :member do
    name { "test member" }
    sequence :url do |n|
      "https://example.com/#{n}"
    end
  end
end
