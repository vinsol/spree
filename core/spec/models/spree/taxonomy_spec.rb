require 'spec_helper'

describe Spree::Taxonomy, type: :model do
  let(:taxonomy) { create(:taxonomy) }
  let(:root_taxon) { taxonomy.root }
  let(:child_taxon) { create(:taxon, taxonomy_id: taxonomy.id, parent: root_taxon) }

  describe '#destroy' do
    before { taxonomy.destroy }

    context 'should destroy all associated taxons' do
      it { expect{ Spree::Taxon.find(root_taxon.id) }.to raise_error(ActiveRecord::RecordNotFound) }
      it { expect{ Spree::Taxon.find(child_taxon.id) }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  describe 'callbacks' do
    it { is_expected.to callback(:set_root).after(:create) }
    it { is_expected.to callback(:set_root_taxon_name).after(:update).if(:name_changed?) }
  end

  describe '#set_root_taxon_name' do
    before do
      taxonomy.update_column(:name, 'test')
      taxonomy.send(:set_root_taxon_name)
    end

    it { expect(taxonomy.root.name).to eq(taxonomy.name) }
  end
end

