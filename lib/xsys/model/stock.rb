module Xsys
  module Model
    class Stock
      attr_accessor :shop_id, :shop_code, :shop_name, :quantity

      def initialize(attributes={})
        attributes.each do |k,v|
          self.send("#{k}=", v)
        end
      end
    end
  end
end
