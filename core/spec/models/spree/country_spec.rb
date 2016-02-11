require 'spec_helper'

describe Spree::Country, type: :model do
  describe '.default' do
    let(:america) { create :country }
    let(:canada)  { create :country, name: 'Canada' }

    it 'will return the country from the config' do
      Spree::Config[:default_country_id] = canada.id
      expect(described_class.default.id).to eql canada.id
    end

    it 'will return america if config is not set' do
      america.touch
      expect(described_class.default.id).to eql america.id
    end

    it 'will return the first record if config is not set and america is not created' do
      canada.touch
      expect(described_class.default.id).to eql canada.id
    end
  end
end
