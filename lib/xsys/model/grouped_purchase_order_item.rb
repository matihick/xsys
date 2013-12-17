module Xsys
  module Model
    class GroupedPurchaseOrderItem
      attr_accessor :quantity, :remaining_quantity, :product_id

      def initialize(attributes={})
        attributes.each do |k,v|
          self.send("#{k}=", v)
        end
      end
    end
  end
end
