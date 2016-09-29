module Xsys
  module Model
    class ProductPriceList
      def self.attr_list
        [:product_id, :product_name, :price_list_id, :total_price,
         :markup, :price_update_date, :price_update_time]
      end

      attr_reader *attr_list

      def initialize(attributes={})
        time_fields = ['price_update_time']
        date_fields = ['price_update_date']
        decimal_fields = ['total_price']

        attributes.each do |k, v|
          if time_fields.include?(k.to_s)
            self.send("#{k}=", Time.parse(v)) unless v.nil?
          elsif date_fields.include?(k.to_s)
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
