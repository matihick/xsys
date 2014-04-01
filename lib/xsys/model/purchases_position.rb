module Xsys
  module Model
    class PurchasesPosition
      attr_accessor :business_unit, :amount_taxes_21, :amount_taxes_27,
        :amount_taxes_10_5, :amount_total, :amount_iva_perception, :amount_iva_retention

      def initialize(attributes={})
        attributes.each do |k,v|
          self.send("#{k}=", v) if self.respond_to?(k)
        end
      end

      def taxes_grand_total
        amount_taxes_27 + amount_taxes_21 + amount_taxes_10_5 + amount_iva_perception + amount_iva_retention
      end
    end
  end
end
