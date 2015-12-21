FactoryGirl.define do
  factory :property, class: Spree::Property do
    sequence(:name) { |n| "baseball_cap_color #{ n }" }
    presentation 'cap color'
  end
end
