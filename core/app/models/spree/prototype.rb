module Spree
  class Prototype < Spree::Base
    has_many :property_prototypes, class_name: 'Spree::PropertyPrototype', dependent: :destroy
    has_many :properties, through: :property_prototypes, class_name: 'Spree::Property'

    has_many :option_type_prototypes, class_name: 'Spree::OptionTypePrototype', dependent: :destroy
    has_many :option_types, through: :option_type_prototypes, class_name: 'Spree::OptionType'

    has_many :prototype_taxons, class_name: 'Spree::PrototypeTaxon', dependent: :destroy
    has_many :taxons, through: :prototype_taxons, class_name: 'Spree::Taxon'

    validates :name, presence: true
  end
end
