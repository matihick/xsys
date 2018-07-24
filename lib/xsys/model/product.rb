module Xsys
  module Model
    class Product
      def self.attr_list
        [:id, :name, :sellable, :product_category_id, :product_provider_id, :vat_rate,
         :taxed_cost, :vat_cost, :total_cost, :pending_ordered_quantity, :stocks, :prices,
         :category, :provider, :last_total_cost, :last_taxed_cost, :cost_update_date,
         :cost_update_time, :last_cost_update_date, :last_cost_update_time, :price_update_date,
         :price_update_time, :online_stock, :real_online_stock, :product_size_code, :weight,
         :length, :width, :height, :packages_quantity, :ean, :packages, :regular_price,
         :reduced_price, :credit_card_price, :brand, :model, :has_stock_on_hold,
         :availability_date, :stockable, :voice_description, :total_real_cost, 
         :real_cost_update_time, :real_cost_update_date]
      end

      attr_reader *attr_list

      def initialize(attributes={})
        time_fields = ['cost_update_time', 'last_cost_update_time', 'price_update_time', 'real_cost_update_time']
        date_fields = ['cost_update_date', 'last_cost_update_date', 'price_update_date', 
          'real_cost_update_date', 'availability_date']
        decimal_fields = ['vat_rate', 'taxed_cost', 'vat_cost', 'total_cost', 'last_total_cost', 'last_taxed_cost', 
          'regular_price', 'reduced_price', 'credit_card_price', 'total_real_cost']

        attributes.each do |k, v|
          if k.to_s == 'category'
            @category = ProductCategory.new(v) unless v.nil?
          elsif k.to_s == 'provider'
            @provider = ProductProvider.new(v) unless v.nil?
          elsif k.to_s == 'stocks'
            @stocks = v.map { |x| Stock.new(x) } unless v.nil?
          elsif k.to_s == 'prices'
            @prices = v.map { |x| ProductPriceList.new(x) } unless v.nil?
          elsif k.to_s == 'packages'
            @packages = v.map { |x| ProductPackage.new(x) } unless v.nil?
          elsif time_fields.include?(k.to_s)
            self.send("#{k}=", Time.parse(v)) unless v.nil?
          elsif date_fields.include?(k.to_s)
            self.send("#{k}=", Date.parse(v)) unless v.nil?
          elsif decimal_fields.include?(k.to_s)
            self.send("#{k}=", BigDecimal.new(v)) unless v.nil?
          else
            self.send("#{k}=", v) if self.respond_to?(k)
          end
        end
      end

      def stock_quantity(shop_code_or_array=nil)
        if shop_code_or_array.nil?
          stocks.map(&:quantity).sum
        elsif shop_code_or_array.is_a?(Array)
          stocks.find_all { |s| shop_code_or_array.include?(s.shop_code) }.map(&:quantity).sum
        elsif shop_code_or_array.is_a?(String)
          stocks.find_all { |s| shop_code_or_array.upcase == s.shop_code }.map(&:quantity).sum
        else
          raise 'invalid input!'
        end
      end

      def stock_available(shop_code_or_array=nil)
        if shop_code_or_array.nil?
          stocks.map(&:available).sum
        elsif shop_code_or_array.is_a?(Array)
          stocks.find_all { |s| shop_code_or_array.include?(s.shop_code) }.map(&:available).sum
        elsif shop_code_or_array.is_a?(String)
          stocks.find_all { |s| shop_code_or_array.upcase == s.shop_code }.map(&:available).sum
        else
          raise 'invalid input!'
        end
      end

      def stock_reserved(shop_code_or_array=nil)
        if shop_code_or_array.nil?
          stocks.map(&:reserved).sum
        elsif shop_code_or_array.is_a?(Array)
          stocks.find_all { |s| shop_code_or_array.include?(s.shop_code) }.map(&:reserved).sum
        elsif shop_code_or_array.is_a?(String)
          stocks.find_all { |s| shop_code_or_array.upcase == s.shop_code }.map(&:reserved).sum
        else
          raise 'invalid input!'
        end
      end

      def stock_at(shop_code)
        stocks.find { |s|
          s.shop_code.to_s.upcase == shop_code.to_s.upcase
        }
      end

      def sellable_stocks
        stocks.find_all { |x| x.sellable }
      end

      def sellable_stocks_quantity
        sellable_stocks.map(&:quantity).sum
      end

      def sellable_stocks_reserved
        sellable_stocks.map(&:reserved).sum
      end

      def sellable_stocks_available
        sellable_stocks.map(&:available).sum
      end

      def price_list(price_list_id)
        prices.find { |p|
          p.price_list_id.to_i == price_list_id.to_i
        }
      end

      def price_date_with_list(price_list_id)
        prices.find { |p|
          p.price_list_id.to_i == price_list_id.to_i
        }.try(:price_update_date)
      end

      def markup_with_list(price_list_id)
        prices.find { |p|
          p.price_list_id.to_i == price_list_id.to_i
        }.try(:markup) || BigDecimal.new('0.0')
      end

      def taxed_price_with_list(price_list_id)
        prices.find { |p|
          p.price_list_id.to_i == price_list_id.to_i
        }.try(:taxed_price) || BigDecimal.new('0.0')
      end

      def total_price_with_list(price_list_id)
        prices.find { |p|
          p.price_list_id.to_i == price_list_id.to_i
        }.try(:total_price) || BigDecimal.new('0.0')
      end

      private

      attr_writer *attr_list
    end
  end
end
