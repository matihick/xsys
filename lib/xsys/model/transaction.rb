module Xsys
  module Model
    class Transaction
      attr_accessor :id, :shop_id, :transaction_kind_id,
        :receipt_number, :product_id, :client_id, :workshop_id,
        :product_provider_id, :transaction_status_id, :transaction_date,
        :logical_section_id, :physical_section_id, :seller_id, :user_id,
        :shop_code, :user, :items

      def initialize(attributes={})
        attributes.each do |k,v|
          if k.to_s == 'transaction_date'
            self.transaction_date = Date.parse(v) unless v.nil?
          elsif k.to_s == 'user'
            self.user = User.new(v) unless v.nil?
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
