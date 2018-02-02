module Xsys
  module Model
    class ProductPackage
      def self.attr_list
        [:length, :width, :height, :weight, :ean, :name]
      end

      attr_reader *attr_list

      def initialize(attributes={})
        attributes.each do |k, v|
          decimal_fields = ['length', 'width', 'height', 'weight']

          if decimal_fields.include?(k.to_s)
            self.send("#{k}=", BigDecimal.new(v)) unless v.nil?
          else
            self.send("#{k}=", v) if self.respond_to?(k)
          end
        end
      end

      def volume
        length * width * height
      end

      private

      attr_writer *attr_list
    end
  end
end
