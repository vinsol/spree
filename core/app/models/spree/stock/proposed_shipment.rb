module Spree
  module Stock
    class ProposedShipment
      attr_accessor :contents, :stock_location
      def initialize(stock_location, contents)
        self.contents = contents
        self.stock_location = stock_location
      end
    end
  end
end
