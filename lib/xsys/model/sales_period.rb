module Xsys
  module Model
    class SalesPeriod
      attr_accessor :shop_code, :seller_id, :transaction_period, :amount_total, :amount_taxes

      def initialize(attributes={})
        attributes.each do |k,v|
          self.send("#{k}=", v) if self.respond_to?(k)
        end
      end
    end
  end
end
