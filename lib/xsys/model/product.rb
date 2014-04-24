module Xsys
  module Model
    class Product
      def self.attr_list
        [:code, :name, :cost_updated_at, :sellable, :product_category_code,
         :product_provider_code, :vat_rate, :taxed_cost, :vat_cost, :total_cost,
         :pending_ordered_quantity, :stocks, :prices, :category, :provider]
      end

      attr_reader *attr_list

      def initialize(attributes={})
        attributes.each do |k, v|
          if k == 'category'
            @category = ProductCategory.new(v)
          elsif k == 'provider'
            @provider = ProductProvider.new(v)
          elsif k == 'stocks'
            @stocks = v.map { |s| Stock.new(s) }
          elsif k == 'prices'
            @prices = v.map { |s| ProductListPrice.new(s) }
          else
            self.send("#{k}=", v) if self.respond_to?(k)
          end
        end
      end

      def stock_total
        stocks.map(&:quantity).sum
      end

      def stock_sum(shop_codes)
        formatted_shop_codes = shop_codes.map(&:to_s).map(&:upcase)

        stocks.find_all { |s|
          formatted_shop_codes.include?(s.shop_code.to_s.upcase)
        }.map(&:quantity).sum
      end

      def stock_at(shop_code)
        stocks.find { |s|
          s.shop_code.to_s.upcase == shop_code.to_s.upcase
        }.try(:quantity).to_i
      end

      def price_date_for_list(price_list_code)
        prices.find { |p|
          p.price_list_code.to_i == price_list_code.to_i
        }.try(:price_updated_at)
      end

      def markup_with_list(price_list_code)
        prices.find { |p|
          p.price_list_code.to_i == price_list_code.to_i
        }.try(:markup) || 0.0
      end

      def price_with_list(price_list_code)
        prices.find { |p|
          p.price_list_code.to_i == price_list_code.to_i
        }.try(:total_price) || 0.0
      end

      private

      attr_writer *attr_list
    end
  end
end
