module Xsys
  module Model
    class SaleItem
      attr_accessor :shop_code, :product_id, :seller_id, :quantity, :amount_total,
        :client_id, :transaction_date, :receipt_number, :transaction_id,
        :transaction_kind_id, :transaction_status_id

      def initialize(attributes={})
        attributes.each do |k,v|
          self.send("#{k}=", v) if self.respond_to?(k)
        end
      end
    end
  end
end
