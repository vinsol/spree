FactoryGirl.define do
  factory :taxon, class: Spree::Taxon do
    sequence(:name) { |n| "Ruby on Rails #{ n }" }
    taxonomy
    parent_id nil
  end
end
