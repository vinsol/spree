module Spree
  class FinalizeOrderJob < ApplicationJob
    queue_as :default

    def perform(order_id)
      order = Order.find(order_id)
      order.finalize_shipments!
    end
  end
end
