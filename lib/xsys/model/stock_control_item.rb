module Xsys
  module Model
    class StockControlItem
      attr_accessor :shop_code, :transaction_id, :product_category_id,
        :product_id, :quantity, :miles, :packages

      def initialize(attributes={})
        attributes.each do |k,v|
          self.send("#{k}=", v) if self.respond_to?(k)
        end
      end
    end
  end
end
