module Xsys
  class Product
    attr_accessor :id, :name, :cost, :active, :sellable, :list_price_1, :list_price_6,
      :list_price_35, :markup_1, :markup_6, :markup_35, :category, :provider, :stocks,
      :remaining_quantity, :sales, :value_added_tax

    def initialize(attributes={})
      attributes.each do |k,v|
        if k == 'category'
          @category = ProductCategory.new(v)
        elsif k == 'provider'
          @provider = ProductProvider.new(v)
        elsif k == 'stocks'
          @stocks = v.map { |s| Stock.new(s) }
        else
          self.send("#{k}=", v)
        end
      end
    end

    def stock_in(shop_code)
      stocks.find { |s| s.shop_code.to_sym == shop_code.to_sym }.try(:quantity)
    end
  end
end
