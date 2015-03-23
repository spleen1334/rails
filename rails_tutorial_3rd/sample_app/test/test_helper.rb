ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# minitest-reporters gem, za output formating
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # Ovo je method da bi se testirao SessionsHelper.logged_in?
  # mora da se pise test method zbog toga sto testovima nisu dostupni
  # current_user methode modela...
  # True if user is logged in
  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user, options = {})
    password = options[:password] || 'password'
    remember_me = options[:remember_me] || '1'

    if integration_test?
      post login_path, session: { email: user.email,
                                  password: password,
                                  remember_me: remember_me}
    else
      session[:user_id] = user.id
    end
  end


  private

    def integration_test?
      defined?(post_via_redirect) # post... radi jedino integration test ne i u model/ctrl
    end

end
