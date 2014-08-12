module Xsys
  module Model
    class Product
      def self.attr_list
        [:id, :name, :cost_updated_at, :sellable, :product_category_id,
         :product_provider_id, :vat_rate, :taxed_cost, :vat_cost, :total_cost,
         :pending_ordered_quantity, :stocks, :prices, :category, :provider,
         :last_total_cost, :last_cost_updated_at]
      end

      attr_reader *attr_list

      def initialize(attributes={})
        attributes.each do |k, v|
          if k.to_s == 'category'
            @category = ProductCategory.new(v)
          elsif k.to_s == 'provider'
            @provider = ProductProvider.new(v)
          elsif k.to_s == 'stocks'
            @stocks = v.map { |s| Stock.new(s) }
          elsif k.to_s == 'prices'
            @prices = v.map { |s| ProductPriceList.new(s) }
          elsif k.to_s == 'cost_updated_at'
            @cost_updated_at = Time.parse(v) unless v.nil?
          elsif k.to_s == 'last_cost_updated_at'
            @cost_updated_at = Time.parse(v) unless v.nil?
          else
            self.send("#{k}=", v) if self.respond_to?(k)
          end
        end
      end

      def sellable_stocks
        stocks.find_all { |s|
          !['SER', 'EXT'].include?(s.shop_code)
        }
      end

      def sellable_stocks_quantity
        sellable_stocks.map(&:quantity).sum
      end

      def service_stocks
        stocks.find_all { |s|
          ['SER', 'EXT'].include?(s.shop_code)
        }
      end

      def service_stocks_quantity
        service_stocks.map(&:quantity).sum
      end

      def stocks_quantity
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

      def price_date_for_list(price_list_id)
        prices.find { |p|
          p.price_list_id.to_i == price_list_id.to_i
        }.try(:price_updated_at)
      end

      def markup_with_list(price_list_id)
        prices.find { |p|
          p.price_list_id.to_i == price_list_id.to_i
        }.try(:markup) || 0.0
      end

      def price_in_list(price_list_id)
        prices.find { |p|
          p.price_list_id.to_i == price_list_id.to_i
        }.try(:total_price) || 0.0
      end

      private

      attr_writer *attr_list
    end
  end
end
