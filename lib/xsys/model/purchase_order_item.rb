module Xsys
  module Model
    class PurchaseOrderItem
      attr_accessor :product_id, :quantity, :remaining_quantity,
        :transaction_date, :transaction_status_id, :transaction_kind_id

      def initialize(attributes={})
        attributes.each do |k,v|
          self.send("#{k}=", v)
        end
      end
    end
  end
end
