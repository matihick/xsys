module Xsys
  class Api
    def self.configure(args={})
      @endpoint = (args[:endpoint] || 'https://gestion.lhconfort.com.ar/api')
      @access_token = args[:access_token]
    end

    def self.get_price_lists(filters={})
      get_request('/price_lists')[:body].map { |r| Model::PriceList.new(r) }
    end

    def self.get_products(filters={})
      response = get_request('/products', filters)

      if response[:headers][:link]
        {
          pagination: Pagination.new(JSON.parse(response[:headers][:link])),
          results: response[:body].map { |r| Model::Product.new(r) }
        }
      else
        response[:body].map { |r| Model::Product.new(r) }
      end
    end

    def self.get_product(product_code)
      Model::Product.new(get_request("/products/#{product_code}")[:body])
    end

    def self.get_product_providers(filters={})
      response = get_request('/product_providers', filters)

      if response[:headers][:link]
        {
          pagination: Pagination.new(JSON.parse(response[:headers][:link])),
          results: response[:body].map { |r| Model::ProductProvider.new(r) }
        }
      else
        response[:body].map { |r| Model::ProductProvider.new(r) }
      end
    end

    def self.get_product_provider(provider_code)
      Model::ProductProvider.new(get_request("/product_providers/#{provider_code}")[:body])
    end

    def self.get_product_categories(filters={})
      response = get_request('/product_categories', filters)

      if response[:headers][:link]
        {
          pagination: Pagination.new(JSON.parse(response[:headers][:link])),
          results: response[:body].map { |r| Model::ProductCategory.new(r) }
        }
      else
        response[:body].map { |r| Model::ProductCategory.new(r) }
      end
    end

    def self.get_product_category(category_code)
      Model::ProductCategory.new(get_request("/product_categories/#{category_code}")[:body])
    end

    def self.get_product_price_lists(filters={})
      response = get_request('/product_price_lists', filters)

      if response[:headers][:link]
        {
          pagination: Pagination.new(JSON.parse(response[:headers][:link])),
          results: response[:body].map { |r| Model::ProductPriceList.new(r) }
        }
      else
        response[:body].map { |r| Model::ProductPriceList.new(r) }
      end
    end

    def self.get_sellers
      get_request('/sellers')[:body].map { |r| Model::Seller.new(r) }
    end

    def self.get_shops(kind=nil)
      shop_kinds = [:commercial, :virtual, :physical, :stockable, :service, :with_target]

      if kind.nil?
        get_request('/shops')[:body].map { |r| Model::Shop.new(r) }
      elsif shop_kinds.include?(kind.to_sym)
        get_request("/shops/#{kind}")[:body].map { |r| Model::Shop.new(r) }
      else
        []
      end
    end

    def self.get_users
      get_request('/users')[:body].map { |r| Model::User.new(r) }
    end

    private

    def self.get_request(action, params={}, headers={})
      begin
        headers.merge!({ authorization: "Token token=\"#{@access_token}\"" })
        parse_response(RestClient.get("#{@endpoint}#{action}", {params: params}.merge(headers)))
      rescue => e
        parse_response(e.response)
      end
    end

    def self.post_request(action, params={}, headers={})
      begin
        headers.merge!({ authorization: "Token token=\"#{@access_token}\"" })
        parse_response(RestClient.post("#{@endpoint}#{action}", params, headers))
      rescue => e
        parse_response(e.response)
      end
    end

    def self.put_request(action, params={}, headers={})
      begin
        headers.merge!({ authorization: "Token token=\"#{@access_token}\"" })
        parse_response(RestClient.put("#{@endpoint}#{action}", params, headers))
      rescue => e
        parse_response(e.response)
      end
    end

    def self.parse_response(response)
      {
        headers: response.headers,
        body: (JSON.parse(response.body) rescue response.body),
        status_code: response.code
      }
    end
  end
end
