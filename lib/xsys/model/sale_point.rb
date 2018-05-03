module Xsys
  module Model
    class SalePoint
      def self.attr_list
        [:code, :shop_code, :point_number, :description]
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
