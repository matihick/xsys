module Xsys
  module Model
    class Locality
      def self.attr_list
        [:code, :province, :name, :zip_code, :description]
      end

      attr_reader *attr_list

      def initialize(attributes={})
        attributes.each do |k, v|
          if k.to_s == 'province'
            @province = StockReserveItem.new(v)
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