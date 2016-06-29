require 'spec_helper'

Spree::Product.class_eval do
  # Slug currently has no validation for maximum length
  validates :slug, db_maximum_length: true
end

describe DbMaximumLengthValidator, type: :model do
  let(:limit_for_slug) { Spree::Product.columns_hash['slug'].limit.to_i }
  let(:product) { create(:product) }

  subject { product }

  context 'when limit present' do
    before do
      sql_type_metadata = ActiveRecord::ConnectionAdapters::SqlTypeMetadata.new(sql_type: 'varchar', type: :string, limit: 100)
      adapter_column = ActiveRecord::ConnectionAdapters::Column.new('slug', nil, sql_type_metadata, true, 'spree_products')
      Spree::Product.columns_hash['slug'] = adapter_column
    end

    it { should validate_length_of(:slug).is_at_most(limit_for_slug) }
  end

  context 'when limit not present' do
    before do
      sql_type_metadata = ActiveRecord::ConnectionAdapters::SqlTypeMetadata.new(sql_type: 'varchar', type: :string, limit: nil)
      adapter_column = ActiveRecord::ConnectionAdapters::Column.new('slug', nil, sql_type_metadata, true, 'spree_products')
      Spree::Product.columns_hash['slug'] = adapter_column
    end

    it { should_not validate_length_of(:slug).is_at_most(limit_for_slug) }
  end
end