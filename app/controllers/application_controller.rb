class ApplicationController < ActionController::Base
  include ApplicationHelper
  include PaginationConcern

  protect_from_forgery with: :exception
end
