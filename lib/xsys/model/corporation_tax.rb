module Xsys
  module Model
    class CorporationTax
      def self.attr_list
        [:tax_kind_code, :tax_kind_name, :quotient, :amount, :use_default_value]
      end

      attr_reader *attr_list

      def initialize(attributes={})
        self.tax_kind_code = attributes['tax_kind_code']
        self.tax_kind_name = attributes['tax_kind_name']
        self.quotient = BigDecimal.new(attributes['quotient'])
        self.amount = BigDecimal.new(attributes['amount'])
        self.use_default_value = attributes['use_default_value']
      end

      private

      attr_writer *attr_list
    end
  end
end
