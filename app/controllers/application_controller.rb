class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  rescue_from CanCan::AccessDenied do |exception|
    authenticate_user!
  end
end
