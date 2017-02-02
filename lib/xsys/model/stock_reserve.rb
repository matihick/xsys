module Xsys
  module Model
    class StockReserve
      def self.attr_list
        [:code, :shop_code, :status, :user_login, :transaction_date,
         :transaction_time, :expiration_date, :external_code,
         :deferral_number, :source, :items]
      end

      attr_reader *attr_list

      def initialize(attributes={})
        attributes.each do |k, v|
          if k.to_s == 'items'
            @items = v.map { |x| StockReserveItem.new(x) } unless v.nil?
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
