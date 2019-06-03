module Xsys
  module Model
    class InvoiceKind
      def self.attr_list
        [
          :code, :shop_code, :sale_point_code, :receipt_identifier, :name, :description,
          :letter, :invoice_method, :invoice_operation, :operation_sign, :has_taxes, :business_unit_code
        ]
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
