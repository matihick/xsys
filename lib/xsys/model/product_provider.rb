module Xsys
  module Model
    class ProductProvider
      def self.attr_list
        [:id, :name, :address, :zip_code, :phone,
         :cuit, :email, :province, :locality, :vat_kind]
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
