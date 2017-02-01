module Spree
  module Stock
    class ProposalCoordinator < Coordinator
      def initialize(order)
        @order = order
        @inventory_units = ProposalInventoryUnitBuilder.new(order).units
        @allocated_inventory_units = []
      end

      def packages
        estimate_packages(build_packages).collect(&:as_proposed)
      end

      def proposed_shipments
        packages.collect(&:to_proposed_shipment)
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
