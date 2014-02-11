module Xsys
  module Model
    class SalesPosition
      attr_accessor :shop_code, :business_unit, :amount_taxes_21,
        :amount_taxes_10_5, :amount_total, :extra_payments_total

      def initialize(attributes={})
        attributes.each do |k,v|
          self.send("#{k}=", v)
        end
      end
    end
  end
end
