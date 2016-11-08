module Spree
  module Stock
    module Splitter
      class ShippingCategory < Spree::Stock::Splitter::Base
        def split(packages)
          split_packages = []
          packages.each do |package|
            split_packages += split_by_category(package)
          end
          return_next split_packages
        end

        private
        def split_by_category(package)
          categories = Hash.new { |hash, key| hash[key] = [] }
          preload_shipping_category_data(package.contents)
          package.contents.each do |item|
            categories[shipping_category_for(item)] << item
          end
          hash_to_packages(categories)
        end

        def hash_to_packages(categories)
          packages = []
          categories.each do |id, contents|
            packages << build_package(contents)
          end
          packages
        end

        def shipping_category_for(item)
          @item_shipping_category[item.inventory_unit.variant_id]
        end

        def preload_shipping_category_data(contents)
          variant_ids = contents.collect do |item|
            item.inventory_unit.variant_id
          end.uniq
          variants = Variant.where(id: variant_ids).includes(:product)
          @item_shipping_category = variants.inject({}) { |acc, variant| acc[variant.id] = variant.shipping_category_id; acc }
        end
      end
    end
  end
end
