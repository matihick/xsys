module Xsys
  module Model
    class ProductPriceList
      def self.attr_list
        [:product_code, :product_name, :price_list_code,
         :total_price, :markup, :price_updated_at]
      end

      attr_reader *attr_list

      def initialize(attributes={})
        attributes.each do |k, v|
          self.send("#{k}=", v) if self.respond_to?(k)
        end
      end

      private

      attr_writer *attr_list
    end
  end
end
