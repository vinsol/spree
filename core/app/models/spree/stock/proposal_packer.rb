module Spree
  module Stock
    class ProposalPacker < Packer
      # Works with proposed inventory units, which only behaves like a collection and is never persisted

      def default_package
        package = Package.new(stock_location)
        inventory_units.by_variant_id.each do |variant_id, variant_inventory_units|
          variant = Spree::Variant.find(variant_id)
          if variant.should_track_inventory?
            next unless stock_location.stock_item(variant)
            on_hand_count, backordered_count = stock_location.fill_status(variant, variant_inventory_units.size)
            package.add_multiple_for_proposal(variant_inventory_units, on_hand_count, :on_hand)       if on_hand_count > 0
            package.add_multiple_for_proposal(variant_inventory_units, backordered_count, :backordered) if backordered_count > 0
            inventory_units.mark_variant_as_allocated(variant)
          else
            package.add_multiple_for_proposal(variant_inventory_units, variant_inventory_units.count, :on_hand)
            inventory_units.mark_variant_as_allocated(variant_id)
          end
        end
        package
      end
    end
  end
end
