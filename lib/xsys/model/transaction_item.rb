module Xsys
  module Model
    class TransactionItem
      attr_accessor :product_id, :transaction_status_id,
        :quantity, :remaining_quantity, :qa_flag, :qa_date,
        :amount_total, :cost,  :packages, :miles

      def initialize(attributes={})
        attributes.each do |k,v|
          self.send("#{k}=", v) if self.respond_to?(k)
        end
      end
    end
  end
end
