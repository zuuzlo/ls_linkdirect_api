module LsLinkdirectAPI
  class TextLinks < APIResource
    def params_path(params)
      "#{params[:token]}/#{params[:mid]}/#{params[:cat]}/#{check_date_format(params[:startDate])}/#{check_date_format(params[:endDate])}/#{params[:campaignID]}/#{params[:page]}"
    end
  end
end