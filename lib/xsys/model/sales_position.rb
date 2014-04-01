module Xsys
  module Model
    class SalesPosition
      attr_accessor :shop_code, :business_unit, :amount_taxes_21,
        :amount_taxes_10_5, :amount_total, :extra_payments_total

      def initialize(attributes={})
        attributes.each do |k,v|
          self.send("#{k}=", v) if self.respond_to?(k)
        end
      end

      def sales_grand_total
        amount_total + extra_payments_total
      end

      def extra_payments_avg
        (extra_payments_total / sales_grand_total).round(2)
      end

      def taxes_grand_total
        amount_taxes_21 + amount_taxes_10_5
      end
    end
  end
end
