module Xsys
  module Model
    class Corporation
      def self.attr_list
        [:cuit, :name, :taxes]
      end

      attr_reader *attr_list

      def initialize(attributes={})
        attributes.each do |k, v|
          if k.to_s == 'taxes'
            @taxes = v.map { |x| CorporationTax.new(x) } unless v.nil?
          else
          end
          self.send("#{k}=", v) if self.respond_to?(k)
        end
      end

      private

      attr_writer *attr_list
    end
  end
end
