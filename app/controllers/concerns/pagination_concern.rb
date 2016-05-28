module PaginationConcern
  extend ActiveSupport::Concern

  included do

    def set_page_params (default_page = 1, default_limit = 10)
      @page = (params[:page] || default_page).to_i
      @limit = (params[:limit] || default_limit).to_i
    end

  end

end
