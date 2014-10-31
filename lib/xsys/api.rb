module Xsys
  class Api
    def self.configure(args={})
      @endpoint = (args[:endpoint] || 'https://gestion.lhconfort.com.ar')
      @access_token = args[:access_token]
    end

    def self.get_background_job(code)
      Model::BackgroundJob.new(get_request("/api/background_jobs/#{code}")[:body])
    end

    def self.update_background_job(code, params)
      Model::BackgroundJob.new(put_request("/api/background_jobs/#{code}", params)[:body])
    end

    def self.add_background_job_event(code, event_description)
      params = { description: event_description }
      Model::JobEvent.new(post_request("/api/background_jobs/#{code}/job_events", params)[:body])
    end

    def self.get_price_lists(filters={})
      get_request('/api/price_lists')[:body].map { |r| Model::PriceList.new(r) }
    end

    def self.search_products(filters={})
      response = get_request('/api/products', filters)

      if response[:headers][:link]
        {
          pagination: Pagination.new(JSON.parse(response[:headers][:link])),
          results: response[:body].map { |r| Model::Product.new(r) }
        }
      else
        response[:body].map { |r| Model::Product.new(r) }
      end
    end

    def self.search_product_ids(filters={})
      response = get_request('/api/product_ids', filters)

      response[:body]['product_ids']
    end

    def self.get_product(product_id)
      response_body = get_request("/api/products/#{product_id}")[:body]

      if response_body == 'null'
        nil
      else
        Model::Product.new(get_request("/api/products/#{product_id}")[:body])
      end
    end

    def self.get_product_providers(filters={})
      response = get_request('/api/product_providers', filters)

      if response[:headers][:link]
        {
          pagination: Pagination.new(JSON.parse(response[:headers][:link])),
          results: response[:body].map { |r| Model::ProductProvider.new(r) }
        }
      else
        response[:body].map { |r| Model::ProductProvider.new(r) }
      end
    end

    def self.get_product_provider(provider_id)
      Model::ProductProvider.new(get_request("/api/product_providers/#{provider_id}")[:body])
    end

    def self.get_product_categories(filters={})
      response = get_request('/api/product_categories', filters)

      if response[:headers][:link]
        {
          pagination: Pagination.new(JSON.parse(response[:headers][:link])),
          results: response[:body].map { |r| Model::ProductCategory.new(r) }
        }
      else
        response[:body].map { |r| Model::ProductCategory.new(r) }
      end
    end

    def self.get_product_category(category_id)
      Model::ProductCategory.new(get_request("/api/product_categories/#{category_id}")[:body])
    end

    def self.get_product_price_lists(filters={})
      response = get_request('/api/product_price_lists', filters)

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
      get_request('/api/sellers')[:body].map { |r| Model::Seller.new(r) }
    end

    def self.get_shops(kind=nil)
      shop_kinds = [:commercial, :virtual, :physical, :stockable, :service, :with_target]

      if kind.nil?
        get_request('/api/shops')[:body].map { |r| Model::Shop.new(r) }
      elsif shop_kinds.include?(kind.to_sym)
        get_request("/api/shops/#{kind}")[:body].map { |r| Model::Shop.new(r) }
      else
        []
      end
    end

    def self.update_cash_withdrawals(shop_code, cash_withdrawals)
      post_request('/api/cash_withdrawals', {
        shop_code: shop_code,
        cash_withdrawals: cash_withdrawals
      })[:body]
    end

    def self.update_cash_withdrawal_items(shop_code, cash_withdrawal_items)
      post_request('/api/cash_withdrawal_items', {
        shop_code: shop_code,
        cash_withdrawal_items: cash_withdrawal_items
      })[:body]
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
