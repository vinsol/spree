module Spree
  class StoreCreditType < Spree::Base
    DEFAULT_TYPE_NAME = 'Expiring'.freeze
    has_many :store_credits, foreign_key: :type_id, dependent: :restrict_with_error
  end
end
