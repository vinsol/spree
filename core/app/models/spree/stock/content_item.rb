module Spree
  module Stock
    class ContentItem
      attr_accessor :inventory_unit, :state, :quantity

      def initialize(inventory_unit, state = :on_hand)
        @inventory_unit = inventory_unit
        @state = state
        # Since inventory units don't have a quantity,
        # make this always 1 for now, leaving ourselves
        # open to a different possibility in the future,
        # but this massively simplifies things for now
        @quantity = 1
      end

      with_options allow_nil: true do
        delegate :line_item,
                 :variant, to: :inventory_unit
        delegate :price,
                 :shipping_category_id, to: :variant
        delegate :dimension,
                 :volume,
                 :id,
                 :weight, to: :variant, prefix: true
      end

      def weight
        variant_weight * quantity
      end

      def on_hand?
        state.to_s == "on_hand"
      end

      def backordered?
        state.to_s == "backordered"
      end

      def amount
        price * quantity
      end

      def volume
        variant_volume * quantity
      end

      def dimension
        variant_dimension * quantity
      end
    end
  end
end
