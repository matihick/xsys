module Xsys
  class Api
    include Singleton

    attr_accessor :endpoint, :access_token

    def self.configure(args={})
      instance.endpoint = (args[:endpoint] || 'https://xsys.lhconfort.com.ar')
      instance.access_token = args[:access_token]
    end

    def get_price_lists(filters={})
      get_request('/price_lists').map { |r| Model::PriceList.new(r) }
    end

    def get_provider_kinds(filters={})
      request = get_request('/provider_kinds', filters)
      request[:results] = request[:results].map { |r| Model::ProviderKind.new(r) }
      request
    end

    def get_provider_kind(id)
      Model::ProviderKind.new(get_request("/provider_kinds/#{id}"))
    end

    def get_product_providers(filters={})
      request = get_request('/product_providers', filters)
      request[:results] = request[:results].map { |r| Model::ProductProvider.new(r) }
      request
    end

    def get_product_provider(id)
      Model::ProductProvider.new(get_request("/product_providers/#{id}"))
    end

    def get_product_categories(filters={})
      request = get_request('/product_categories', filters)
      request[:results] = request[:results].map { |r| Model::ProductCategory.new(r) }
      request
    end

    def get_product_category(id)
      Model::ProductCategory.new(get_request("/product_categories/#{id}"))
    end

    def get_products(filters={})
      request = get_request('/products', filters)
      request[:results] = request[:results].map { |r| Model::Product.new(r) }
      request
    end

    def get_product(id)
      Model::Product.new(get_request("/products/#{id}"))
    end

    def get_shops(kind=nil)
      shops_url = (kind.nil? ? '/shops' : "/shops/#{kind}")
      get_request(shops_url).map { |r| Model::Shop.new(r) }
    end

    def get_sellers
      get_request('/sellers').map { |r| Model::Seller.new(r) }
    end

    def get_sales_period(period, from, to, shop_code=nil)
      get_request("/sales_periods/#{period}", {
        date_from: from,
        date_to: to,
        shop_code: shop_code
      }).map { |r| Model::SalesPeriod.new(r) }
    end

    def get_purchase_order_items(filters={})
      request = get_request('/purchase_order_items', filters)
      request[:results] = request[:results].map { |r| Model::PurchaseOrderItem.new(r) }
      request
    end

    def get_grouped_purchase_order_items(filters={})
      request = get_request('/purchase_order_items/grouped', filters)
      request[:results] = request[:results].map { |r| Model::GroupedPurchaseOrderItem.new(r) }
      request
    end

    def get_sale_items(filters={})
      request = get_request('/sale_items', filters)
      request[:results] = request[:results].map { |r| Model::SaleItem.new(r) }
      request
    end

    def get_grouped_sale_items(filters={})
      request = get_request('/sale_items/grouped', filters)
      request[:results] = request[:results].map { |r| Model::GroupedSaleItem.new(r) }
      request
    end

    private

    def get_request(action, params={})
      response = ::RestClient.get("#{@endpoint}#{action}", {params: params}.merge({
        authorization: "Token token=\"#{@access_token}\""
      }))

      if response.headers[:link]
        {
          pagination: Pagination.new(JSON.parse(response.headers[:link])),
          results: JSON.parse(response.body)
        }
      else
        JSON.parse(response.body)
      end
    end
  end
end
