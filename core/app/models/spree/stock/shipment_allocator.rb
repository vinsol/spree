module Spree
  module Stock
    class ShipmentAllocator

      attr_accessor :order, :shipments

      def initialize(order)
        self.order = order
        self.shipments = order.shipments
      end

      def allocate_proposal_content
        shipments.each do |_shipment|
          match = next_proposed_match(_shipment)
          _shipment.package_contents = match.contents
        end
      end

      def allocate_inventory_units
        shipments.each do |_shipment|
          match = next_match(_shipment)
          _shipment.inventory_units = match.inventory_units
        end
      end

      private
      def next_proposed_match(shipment)
        m = proposed_shipments.detect { |x| x.stock_location == shipment.stock_location }
        @proposed = proposed_shipments - [m]
        m
      end

      def next_match(shipment)
        m = shipments_with_inventory_units.detect { |x| x.stock_location == shipment.stock_location }
        @coordinated = shipments_with_inventory_units - [m]
        m
      end

      def proposed_shipments
        @proposed ||= ProposalCoordinator.new(order).proposed_shipments
      end

      def shipments_with_inventory_units
        @coordinated ||= Coordinator.new(order).shipments
      end
    end
  end
end
