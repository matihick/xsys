module Xsys
  module Model
    class User
      def self.attr_list
        [:code, :name, :shop_code]
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
