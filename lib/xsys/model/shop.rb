module Xsys
  module Model
    class Shop
      def self.attr_list
        [:id, :code, :name, :stock_description, :commercial,
        :virtual, :stockable, :has_target, :service, :physical_shop_code,
        :position, :has_stock_control, :has_exhibition, :stock_sellable,
        :stock_sellable, :enabled, :physical_shop_id, :last_update]
      end

      attr_reader *attr_list

      def initialize(attributes={})
        attributes.each do |k, v|
          self.send("#{k}=", v) if self.respond_to?(k)
        end
      end

      def commercial?
        commercial == true
      end

      def virtual?
        virtual == true
      end

      def physical?
        !virtual?
      end

      def stockable?
        stockable == true
      end

      def service?
        service == true
      end

      def has_target?
        has_target == true
      end

      def has_exhibition?
        has_exhibition == true
      end

      def stock_sellable?
        stock_sellable == true
      end

      def enabled?
        enabled == true
      end

      private

      attr_writer *attr_list
    end
  end
end
