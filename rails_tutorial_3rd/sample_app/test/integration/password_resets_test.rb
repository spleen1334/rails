require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:spleen)
  end

  test "password reset" do
    # target path
    get new_password_reset_path
    assert_template 'password_resets/new'

    # Invalid email
    post password_resets_path, password_reset: { email: "" }
    assert_not flash.empty?
    assert_template 'password_resets/new'

    # Valid email
    post password_resets_path, password_reset: { email: @user.email }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url

    # Password reset form
    user = assigns(:user) # instance vars @user iz action (root_url)

    # Wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url

    # Inactive user
    user.toggle!(:activated) # deaktiviraj usera, posto su po default svi active
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated) # vrati da bude activan

    # Right email, wrong token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url

    # Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email # value=? kao u bash << user.email

    # Invalid password & confirmation
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "foobaz",
                  password_confirmation: "barquux" }
    assert_select 'div#error_explanation'

    # Blank password
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "  ",
                  password_confirmation: "foobar" }
    assert_not flash.empty?
    assert_template 'password_resets/edit'

    # Valid password & confirmation
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "foobaz",
                  password_confirmation: "foobaz" }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path, password_reset: { email: @user.email }

    @user = assigns(:user) # instance var from action
    @user.update_attribute(:reset_sent_at, 3.hours.ago) # namerno failuj
    patch password_reset_path(@user.reset_token),
          email: @user.email,
          user: { password:              "foobar",
                  password_confirmation: "foobar" }
    assert_response :redirect
    follow_redirect!
    assert_match (/expired/i), response.body # regex expired error msg check_expiration
  end
end
