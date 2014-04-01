module Xsys
  module Model
    class PriceList
      attr_accessor :id, :name

      def initialize(attributes={})
        attributes.each do |k,v|
          self.send("#{k}=", v) if self.respond_to?(k)
        end
      end
    end
  end
end
