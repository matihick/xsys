module Xsys
  module Model
    class Shop
      attr_accessor :id, :code, :name, :is_commercial, :is_virtual,
        :is_physical, :is_stockable, :has_target, :is_service,
        :physical_shop_code, :physical_shop_id

      def initialize(attributes={})
        attributes.each do |k,v|
          self.send("#{k}=", v) if self.respond_to?(k)
        end
      end

      def commercial?
        is_commercial == true
      end

      def virtual?
        is_virtual == true
      end

      def stockable?
        is_stockable == true
      end

      def has_target?
        has_target == true
      end

      def service?
        is_service == true
      end
    end
  end
end
