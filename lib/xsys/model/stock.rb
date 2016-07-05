module Xsys
  module Model
    class Stock
      def self.attr_list
        [:shop_code, :quantity, :shop_has_exhibition, :shop_service]
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
