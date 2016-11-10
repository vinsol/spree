class AddProcessingShipmentsToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :spree_orders, :processing_shipments, :bool, default: false
  end
end
