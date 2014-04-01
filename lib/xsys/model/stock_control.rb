module Xsys
  module Model
    class StockControl
      attr_accessor :shop_code, :transaction_id, :receipt_number,
        :transaction_date, :product_category_id, :product_category_name,
        :user_id, :user_name, :errors_count

      def initialize(attributes={})
        attributes.each do |k,v|
          self.send("#{k}=", v) if self.respond_to?(k)
        end
      end
    end
  end
end
