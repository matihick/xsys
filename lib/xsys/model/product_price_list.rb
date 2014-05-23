module Xsys
  module Model
    class ProductPriceList
      def self.attr_list
        [:product_id, :product_name, :price_list_id,
         :total_price, :markup, :price_updated_at]
      end

      attr_reader *attr_list

      def initialize(attributes={})
        attributes.each do |k, v|
          if k.to_s == 'price_updated_at'
            @price_updated_at = Time.parse(v)
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
