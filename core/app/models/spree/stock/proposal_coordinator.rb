module Spree
  module Stock
    class ProposalCoordinator < Coordinator
      def initialize(order)
        @order = order
        @inventory_units = ProposalInventoryUnitBuilder.new(order).units
        @allocated_inventory_units = []
      end

      def packages
        super.collect(&:as_proposed)
      end

      private

      def unallocated_inventory_units
        inventory_units.unallocated_units
      end

      def requested_variant_ids
        @inventory_units.variant_ids
      end

      def build_packer(stock_location, inventory_units)
        ProposalPacker.new(stock_location, inventory_units, splitters(stock_location))
      end
    end
  end
end
