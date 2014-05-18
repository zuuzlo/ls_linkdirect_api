module LsLinkdirectAPI
  class APIResource
    include HTTParty

    def class_name
      self.class.name.split('::')[-1]
    end

    def base_path
      if self.class == LsLinkdirectAPI::APIResource
        raise NotImplementedError.new(
          "APIResource is an abstract class. You should perform actions on its subclasses (i.e. TextLinks)"
        )
      end
      "/get#{CGI.escape(class_name)}/"
    end

    def get(params = {})
      
      unless token ||= LsLinkdirectAPI.token
        raise AuthenticationError.new(
          "No token provided. Set your token key using: LsLinkdirectAPI.token = 'TOKEN' " +
          "You can retrieve your Your Web Services Token from the Linkshare web interface. " +
          "http://helpcenter.linkshare.com/publisher/questions.php?questionid=58 for details."
        )
      end

      if token =~ /\s/
        raise AuthenticationError.new(
          "Your token looks invalid. " +
          "Double-check your token at http://linkshare.com"
        )
      end
      
      raise ArgumentError, "Params must be a Hash; got #{params.class} instead" unless params.is_a? Hash

      params.merge!({
        token: token,
      })
      make_params_valid(params)
      resource_url = LsLinkdirectAPI.api_base_url + base_path + self.params_path(params)
      request(resource_url, params)
    end

    def request(resource_url, params)
      timeout = LsLinkdirectAPI.api_timeout
      begin
        response = self.class.get(resource_url, query: nil, timeout: timeout)
      rescue Timeout::Error
        raise ConnectionError.new("Timeout error (#{timeout}s)")
      end
      process(response, "get#{class_name}Response")
    end

    private

    def process(response, response_name)
      case response.code
      when 200, 201, 204
        APIResponse.new(response, response_name)
      when 400, 404
        raise InvalidRequestError.new(response.message, response.code)
      when 401
        raise AuthenticationError.new(response.message, response.code)
      else
        raise Error.new(response.message, response.code)
      end
    end

    def check_date_format(date)
      if date
        if date =~ /(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])(19|20)\d\d/
          date
        else
          raise ArgumentError, "Data format needs to be MMDDYYYY."
        end
      else
        ''
      end
    end

    def make_params_valid(params)
      unless params[:mid]
        params[:mid] = -1
      end

      unless params[:cat]
        params[:cat] = -1
      end

      unless params[:page]
        params[:page] = 1
      end

      unless params[:campaignID]
        params[:campaignID] = -1
      end

      unless params[:size]
        params[:size] = -1
      end
    end
  end
end