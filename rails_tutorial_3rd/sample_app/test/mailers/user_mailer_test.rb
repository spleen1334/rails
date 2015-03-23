require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:spleen) # fixture
    user.activation_token = User.new_token # generate token
    mail = UserMailer.account_activation(user) # action

    assert_equal "Account Activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from

    # assert_match pretrazuje string i vrsi matching
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded # cgi build in methodi html escape
  end

  test "password_reset" do
    user = users(:spleen)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)

    assert_equal "Password reset", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from

    assert_match user.reset_token, mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded

  end

end
