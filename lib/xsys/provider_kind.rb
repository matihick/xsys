module Xsys
  class ProviderKind
    attr_accessor :id, :name

    def initialize(attributes={})
      attributes.each do |k,v|
        self.send("#{k}=", v)
      end
    end
  end
end
