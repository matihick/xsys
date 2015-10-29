module Xsys
  module Model
    class Sale
      def self.attr_list
        [:code, :transaction_number, :shop_code, :transaction_kind_code, :transaction_status_id,
        :customer_code, :receipt_number, :receipt_date, :total_amount, :seller_code, :observations,
        :user_login, :sale_order_code, :receiver_name, :cuit, :items]
      end

      attr_reader *attr_list

      def initialize(attributes={})
        time_fields = ['receipt_date']
        decimal_fields = ['total_amount']

        attributes.each do |k, v|
          if k.to_s == 'items'
            self.items = v.map { |s| SaleItem.new(s) }
          elsif time_fields.include?(k.to_s)
            self.send("#{k}=", Date.parse(v)) unless v.nil?
          elsif decimal_fields.include?(k.to_s)
            self.send("#{k}=", BigDecimal.new(v)) unless v.nil?
          else
            self.send("#{k}=", v) if self.respond_to?(k)
          end
        end
      end

      private

      attr_writer *attr_list
    end
  end
end
