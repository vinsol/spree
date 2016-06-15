require 'spec_helper'

Spree::Product.class_eval do
  # Slug currently has no validation for maximum length
  validates :slug, db_maximum_length: true
end

describe DbMaximumLengthValidator, type: :model do
  let(:limit_for_slug) { Spree::Product.columns_hash['slug'].limit.to_i }
  let(:product) { Spree::Product.new }
  let(:slug) { 'x' * (limit_for_slug + 1) }

  context 'when limit present' do
    before do
      sql_type_metadata = ActiveRecord::ConnectionAdapters::SqlTypeMetadata.new(sql_type: 'varchar', type: :string, limit: 100)
      adapter_column = ActiveRecord::ConnectionAdapters::Column.new('slug', nil, sql_type_metadata, true, 'spree_products')
      Spree::Product.columns_hash['slug'] = adapter_column
      product.slug = slug
    end

    it 'validates DB maximum length' do
      product.valid?
      expect(product.errors[:slug]).to include(I18n.t("errors.messages.too_long", count: limit_for_slug))
    end
  end

  context 'when limit not present' do
    before do
      sql_type_metadata = ActiveRecord::ConnectionAdapters::SqlTypeMetadata.new(sql_type: 'varchar', type: :string, limit: nil)
      adapter_column = ActiveRecord::ConnectionAdapters::Column.new('slug', nil, sql_type_metadata, true, 'spree_products')
      Spree::Product.columns_hash['slug'] = adapter_column
      product.slug = slug
    end

    it 'do not validate DB maximum length' do
      product.valid?
      expect(product.errors[:slug]).not_to include(I18n.t("errors.messages.too_long", count: limit_for_slug))
    end
  end
end
