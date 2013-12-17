module Xsys
  module Model
    class ProviderKind
      attr_accessor :id, :name

      def initialize(attributes={})
        attributes.each do |k,v|
        if k == 'kind'
          @kind = ProviderKind.new(v)
        else
          self.send("#{k}=", v)
        end
        end
      end
    end
  end
end
