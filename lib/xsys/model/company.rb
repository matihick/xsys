module Xsys
  module Model
    class Company
      def self.attr_list
        [:code, :name, :tax_retention_rate, :tax_perception_rate]
      end

      attr_reader *attr_list

      def initialize(attributes={})
        attributes.each do |k, v|
          decimal_fields = ['tax_retention_rate', 'tax_perception_rate']

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
