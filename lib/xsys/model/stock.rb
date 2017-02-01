module Xsys
  module Model
    class Stock
      def self.attr_list
        [
          :shop_code,
          :quantity,
          :available,
          :reserved,
          :quantity_update_time,
          :quantity_update_date,
          :reserved_update_time,
          :reserved_update_date
        ]
      end

      attr_reader *attr_list

      def initialize(attributes={})
        time_fields = ['quantity_update_time', 'reserved_update_time']
        date_fields = ['quantity_update_date', 'reserved_update_date']

        attributes.each do |k, v|
          if time_fields.include?(k.to_s)
            self.send("#{k}=", Time.parse(v)) unless v.nil?
          elsif date_fields.include?(k.to_s)
            self.send("#{k}=", Date.parse(v)) unless v.nil?
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
