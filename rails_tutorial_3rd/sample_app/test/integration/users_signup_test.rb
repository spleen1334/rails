require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    # delivers je global array, zato ga i resetujemo za slucaj da ga koristimo
    # u nekim drugim testovima
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: '',
                              email: 'invalid@email',
                              password: 'foo',
                              password_confirmation: 'bar'}
    end
    assert_template 'users/new'
    # assert_select 'div#error_explanation'
    # assert_select 'div#field_with_errors'
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do # 1 = opcioni parametar za tacnu vrednost razlike
      # method koji nakon post prati redirect, normalno se samo salje post req
      # u testu. Ovo je parent method
      # requiest_via_redirect(http_method, path, params.., headers...)
      post users_path, user: { name: 'Valid Name',
                               email: 'valid@email.com',
                               password: 'password',
                               password_confirmation: 'password'}
    end

    assert_equal 1, ActionMailer::Base.deliveries.size # provera da li postoji nesto u array

    user = assigns(:user) # ASSIGNS omogucava koriscenje instance vars odgovarajuce akcije
    # user >> user_ctrl_new action (to je signup path)
    assert_not user.activated?

    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?

    # Invalid activation token
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?

    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?

    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated? # ponovo ucitaj obj .reload
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end


end


# ASSERT_NO_DIFFERENCE
# Isto sto i:
# before_count = User.count
# post users_path, ...
# after_count  = User.count
# assert_equal before_count, after_count
