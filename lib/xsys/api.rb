module Xsys
  class Api
    def self.configure(args={})
      @access_token = args[:access_token]
      @endpoint = args[:endpoint]
    end

    def get_price_lists(filters={})
      get_request('/price_lists').map { |r| Xsys::PriceList.new(r) }
    end

    def get_provider_kinds(filters={})
      request = get_request('/provider_kinds', filters)
      request[:results] = request[:results].map { |r| Xsys::ProviderKind.new(r) }
      request
    end

    def get_provider_kind(id)
      Xsys::ProviderKind.new(get_request("/provider_kinds/#{id}"))
    end

    def get_product_providers(filters={})
      request = get_request('/product_providers', filters)
      request[:results] = request[:results].map { |r| Xsys::ProductProvider.new(r) }
      request
    end

    def get_product_provider(id)
      Xsys::ProductProvider.new(get_request("/product_providers/#{id}"))
    end

    def get_product_categories(filters={})
      request = get_request('/product_categories', filters)
      request[:results] = request[:results].map { |r| Xsys::ProductCategory.new(r) }
      request
    end

    def get_product_category(id)
      Xsys::ProductCategory.new(get_request("/product_categories/#{id}"))
    end

    def get_products(filters={})
      request = get_request('/products', filters)
      request[:results] = request[:results].map { |r| Xsys::Product.new(r) }
      request
    end

    def get_product(id)
      Xsys::Product.new(get_request("/products/#{id}"))
    end

    def get_shops(kind=nil)
      shops_url = (kind.nil? ? '/shops' : "/shops/#{kind}")
      get_request(shops_url).map { |r| Xsys::Shop.new(r) }
    end

    def get_sellers
      get_request('/sellers').map { |r| Xsys::Seller.new(r) }
    end

    def get_sales_period(period, from, to, shop_code=nil)
      get_request("/sales_periods/#{period}", {
        date_from: from,
        date_to: to,
        shop_code: shop_code
      }).map { |r| Xsys::SalesPeriod.new(r) }
    end

    def get_purchase_order_items(filters={})
      request = get_request('/purchase_order_items', filters)
      request[:results] = request[:results].map { |r| Xsys::PurchaseOrderItem.new(r) }
      request
    end

    def get_grouped_purchase_order_items(filters={})
      request = get_request('/purchase_order_items/grouped', filters)
      request[:results] = request[:results].map { |r| Xsys::GroupedPurchaseOrderItem.new(r) }
      request
    end

    def get_sale_items(filters={})
      request = get_request('/sale_items', filters)
      request[:results] = request[:results].map { |r| Xsys::SaleItem.new(r) }
      request
    end

    def get_grouped_sale_items(filters={})
      request = get_request('/sale_items/grouped', filters)
      request[:results] = request[:results].map { |r| Xsys::GroupedSaleItem.new(r) }
      request
    end

    private

    def self.access_token
      @access_token
    end

    def self.endpoint
      @endpoint || 'https://xsys.lhconfort.com.ar'
    end

    def get_request(action, params={}, headers={})
      response = ::RestClient.get("#{Xsys::Api.endpoint}#{action}", {params: params}.merge(headers))

      if response.headers[:link]
        {
          pagination: Xsys::Pagination.new(JSON.parse(response.headers[:link])),
          results: JSON.parse(response.body)
        }
      else
        JSON.parse(response.body)
      end
    end
  end
end
