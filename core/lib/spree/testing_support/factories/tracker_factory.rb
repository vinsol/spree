FactoryGirl.define do
  factory :tracker, class: Spree::Tracker do
    sequence(:analytics_id)  { |n| "A #{ n }" }
    active true
  end
end
