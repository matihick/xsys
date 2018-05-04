module Xsys
  class Api
    def self.configure(args={})
      if args[:endpoint].present?
        @endpoint = "#{args[:endpoint]}/api"
      else
        @endpoint = "https://gestion.lhconfort.com.ar/api"
      end

      @access_token = args[:access_token]

      self
    end

    def self.get_background_job(code)
      Model::BackgroundJob.new(get_request("/background_jobs/#{code}")[:body])
    end

    def self.update_background_job(code, params)
      Model::BackgroundJob.new(put_request("/background_jobs/#{code}", params)[:body])
    end

    def self.add_background_job_event(code, event_description)
      params = { description: event_description }
      Model::JobEvent.new(post_request("/background_jobs/#{code}/job_events", params)[:body])
    end

    def self.get_price_lists(filters={})
      get_request('/price_lists')[:body].map { |r| Model::PriceList.new(r) }
    end

    def self.search_products(filters={})
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

    def self.search_product_ids(filters={})
      response = get_request('/product_ids', filters)

      response[:body]['product_ids']
    end

    def self.get_product(product_id)
      response_body = get_request("/products/#{product_id}")[:body]

      if response_body == 'null'
        nil
      else
        Model::Product.new(response_body)
      end
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

    def self.get_product_provider(provider_id)
      Model::ProductProvider.new(get_request("/product_providers/#{provider_id}")[:body])
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

    def self.get_product_category(category_id)
      Model::ProductCategory.new(get_request("/product_categories/#{category_id}")[:body])
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

    def self.update_cash_withdrawals(shop_code, cash_withdrawals)
      post_request('/cash_withdrawals', {
        shop_code: shop_code,
        cash_withdrawals: cash_withdrawals
      })[:body]
    end

    def self.update_cash_withdrawal_items(shop_code, cash_withdrawal_items)
      post_request('/cash_withdrawal_items', {
        shop_code: shop_code,
        cash_withdrawal_items: cash_withdrawal_items
      })[:body]
    end

    def self.get_sale(code)
      response_body = get_request("/sales/#{code}")[:body]

      if response_body == 'null'
        nil
      else
        Model::Sale.new(response_body)
      end
    end

    def self.update_product(product_id, attrs={})
      Model::Product.new(put_request("/products/#{product_id}", attrs)[:body])
    end

    def self.update_product_price_list(attrs={})
      put_request('/product_price_lists', attrs)[:body]
    end

    def self.create_stock_reserve(attrs={})
      response = post_request('/stock_reserves', attrs)

      if response[:status_code] == 200
        if response[:body] == 'null'
          false
        else
          Model::StockReserve.new(response[:body])
        end
      else
        false
      end
    end

    def self.get_stock_reserve(code)
      response_body = get_request("/stock_reserves/#{code}")[:body]

      if response_body == 'null'
        nil
      else
        Model::StockReserve.new(response_body)
      end
    end

    def self.search_stock_reserves(filters={})
      get_request('/stock_reserves', filters)[:body].map { |x| Model::StockReserve.new(x) }
    end

    def self.cancel_stock_reserve(stock_reserve_code, user_login, cancellation_reason=nil)
      response = put_request("/stock_reserves/#{stock_reserve_code}/cancel", {
        user_login: user_login,
        cancellation_reason: cancellation_reason
      })

      if response[:status_code] == 200
        Model::StockReserve.new(response[:body])
      else
        false
      end
    end

    def self.defer_stock_reserve(stock_reserve_code, expiration_date, user_login)
      response = put_request("/stock_reserves/#{stock_reserve_code}/defer", {
        expiration_date: expiration_date,
        user_login: user_login
      })

      if response[:status_code] == 200
        Model::StockReserve.new(response[:body])
      else
        false
      end
    end

    def self.get_company(code)
      result = get_request("/companies/#{code}")[:body]

      if result == 'null'
        nil
      else
        Model::Company.new(result)
      end
    end

    def self.calculate_company_taxes(company_code, items)
      attrs = {
        company_code: company_code,
        items: items.to_json
      }

      Model::CompanyTaxCalculation.new(get_request('/companies/calculate_taxes', attrs)[:body])
    end

    def self.get_corporation(cuit)
      result = get_request("/corporations/#{cuit}")[:body]

      if result.blank?
        nil
      else
        Model::Corporation.new(result)
      end
    end

    def self.calculate_corporation_taxes(cuit, items)
      response = post_request('/corporations/taxes_calculation', {
        cuit: cuit,
        items: items.to_json
      })

      Model::CorporationTaxesCalculation.new(response[:body])
    end

    def self.get_cash_register_periods(filters={})
      response = get_request('/cash_register_periods', filters)
      response[:body].map { |x| Model::CashRegisterPeriod.new(x) }
    end

    def self.get_cash_register_period(code)
      result = get_request("/cash_register_period/#{code}")[:body]

      if result.blank?
        nil
      else
        Model::CashRegisterPeriod.new(result)
      end
    end

    def self.get_invoice_kinds(filters={})
      response = get_request('/invoice_kinds', filters)
      response[:body].map { |x| Model::InvoiceKind.new(x) }
    end

    def self.get_invoice_kind(code)
      result = get_request("/invoice_kinds/#{code}")[:body]

      if result.blank?
        nil
      else
        Model::InvoiceKind.new(result)
      end
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
