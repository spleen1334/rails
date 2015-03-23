class ApplicationController < ActionController::Base
  protect_from_forgery

  private

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    # helper_method is useful when the functionality is something that's used
    # between both the controller and the view. A good example is something
    # like current_user.
    helper_method :current_user
end
