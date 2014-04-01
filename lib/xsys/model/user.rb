module Xsys
  module Model
    class User
      attr_accessor :id, :name, :shop_code

      def initialize(attributes={})
        attributes.each do |k,v|
          self.send("#{k}=", v) if self.respond_to?(k)
        end
      end
    end
  end
end
