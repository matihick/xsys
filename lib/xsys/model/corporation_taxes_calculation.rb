module Xsys
  module Model
    class CorporationTaxesCalculation
      def self.attr_list
        [:cuit, :corporate_name, :taxes]
      end

      attr_reader *attr_list

      def initialize(attributes={})
        self.cuit = attributes[:cuit]
        self.corporate_name = attributes[:corporate_name]
        self.taxes = attributes[:taxes].map { |tax_attrs| CorporationTax.new(tax_attrs) }
      end

      def get_tax(tax_kind_code)
        taxes.find { |x| x.tax_kind_code.to_s == tax_kind_code.to_s }
      end

      private

      attr_writer *attr_list
    end
  end
end
