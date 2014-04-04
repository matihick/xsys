module Xsys
  module Model
    class TransactionItem
      attr_accessor :product_id, :transaction_status_id,
        :quantity, :remaining_quantity, :qa_flag, :qa_date,
        :amount_total, :cost,  :packages, :miles

      def initialize(attributes={})
        attributes.each do |k,v|
          if k.to_s == 'transaction_date'
            self.transaction_date = Date.parse(v) unless v.nil?
          elsif k.to_s == 'user'
            self.user = User.new(v)
          elsif k.to_s == 'items'
            self.items = v.map { |x| TransactionItem.new(x) }
          else
            self.send("#{k}=", v) if self.respond_to?(k)
          end
        end
      end
    end
  end
end
