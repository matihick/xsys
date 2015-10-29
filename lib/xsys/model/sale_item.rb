module Xsys
  module Model
    class SaleItem
      def self.attr_list
        [:sale_code, :position, :transaction_number, :shop_code, :product_id, :quantity,
        :taxed_unit_price, :vat_unit_price, :total_unit_price, :taxed_amount, :vat_amount,
        :total_amount, :vat_rate]
      end

      attr_reader *attr_list

      def initialize(attributes={})
        decimal_fields = ['taxed_unit_price', 'vat_unit_price', 'total_unit_price',
          'taxed_amount', 'vat_amount', 'total_amount', 'vat_rate']

        attributes.each do |k, v|
          if decimal_fields.include?(k.to_s)
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
