require 'spec_helper'

describe Spree::ShippingCategory, type: :model do

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive.allow_blank }
  end

  describe '#validations' do
    it 'should have a valid factory' do
      expect(FactoryGirl.build(:shipping_category)).to be_valid
    end

    it 'should require name' do
      expect(FactoryGirl.build(:shipping_category, name: '')).not_to be_valid
    end

    it 'should validate uniqueness' do
      FactoryGirl.create(:shipping_category, name: 'Test')
      expect(FactoryGirl.build(:shipping_category, name: 'Test')).not_to be_valid
    end
  end
end
