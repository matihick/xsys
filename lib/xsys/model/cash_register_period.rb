module Xsys
  module Model
    class CashRegisterPeriod
      def self.attr_list
        [
          :code, :cash_register_code, :cash_register_number, :period_number,
          :shop_code, :time_from, :time_to, :description, :status
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
