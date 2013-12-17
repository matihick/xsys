module Xsys
  module Model
    class Seller
      attr_accessor :id, :name, :shop_code

      def initialize(attributes={})
        attributes.each do |k,v|
          self.send("#{k}=", v)
        end
      end
    end
  end
end
