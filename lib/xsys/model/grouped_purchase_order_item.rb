module Xsys
  module Model
    class GroupedPurchaseOrderItem
      attr_accessor :quantity, :remaining_quantity, :product_id

      def initialize(attributes={})
        attributes.each do |k,v|
          self.send("#{k}=", v) if self.respond_to?(k)
        end
      end
    end
  end
end
