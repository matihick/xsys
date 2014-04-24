module Xsys
  module Model
    class Shop
      def self.attr_list
        [:id, :code, :name, :stock_description, :commercial,
         :virtual, :stockable, :has_target, :service, :physical_shop_code]
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

      def with_target?
        with_target == true
      end

      private

      attr_writer *attr_list
    end
  end
end
