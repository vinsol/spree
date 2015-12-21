FactoryGirl.define do
  factory :prototype, class: Spree::Prototype do
    sequence(:name) { |n| "Baseball Cap #{ n }" }
    properties { [create(:property)] }
  end
  factory :prototype_with_option_types, class: Spree::Prototype do
    sequence(:name) { |n| "Baseball Cap #{ n }" }
    properties { [create(:property)] }
    option_types { [create(:option_type)] }
  end
end
