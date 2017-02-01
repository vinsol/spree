module Spree
  module Stock
    class ProposalInventoryUnits
      attr_accessor :units, :variants

      def initialize(units, variants)
        self.units    = units
        self.variants = variants
        @allocated    = [].to_set
      end

      def by_variant_id
        unallocated_units.units
      end

      def mark_variant_as_allocated(variant_id)
        @allocated << variant_id
      end

      def unallocated_units
        unallocated_variants = self.variants - @allocated
        unallocated_units    = @units.slice(*unallocated_variants.to_a)
        self.class.new(unallocated_units, unallocated_variants)
      end

      def variant_ids
        self.variants.to_a
      end

      class << self
        def from_line_items(line_items)
          units    = build_units_from_line_items(line_items)
          variants = units.keys.to_set
          new(units, variants)
        end

        private
        def build_units_from_line_items(line_items)
          line_items.inject({}) do |acc, ln_item|
            acc[ln_item.variant_id] = ProposalInventoryUnit.new(ln_item.variant, ln_item, ln_item.quantity)
            acc
          end
        end
      end
    end

    class ProposalInventoryUnit
      attr_accessor :count, :variant, :state, :line_item
      alias_method  :size, :count

      def initialize(variant, line_item, count)
        self.variant = variant
        self.line_item = line_item
        self.count = count
      end
    end

    class ProposalInventoryUnitBuilder
      attr_accessor :order

      def initialize(order)
        self.order = order
      end

      def units
        ProposalInventoryUnits.from_line_items(order.line_items)
      end
    end
  end
end
