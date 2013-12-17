module Xsys
  module Model
    class GroupedSaleItem
      attr_accessor :shop_code, :product_id, :seller_id, :quantity, :amount_total

      def initialize(attributes={})
        attributes.each do |k,v|
          self.send("#{k}=", v)
        end
      end
    end
  end
end
