require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest

  # Da bi mogli da koristimo nase helper methode
  include StaticPagesHelper

  def setup
    @user = users(:spleen)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'

    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'

    assert_match @user.microposts.count.to_s, response.body # broj postova
    assert_select 'div.pagination'

    # Funkcionisanje:
    # ovo proverava sadrzaj svih postova sa prve strane
    # svaki pojedinacni micropost content mora da se nalazi u html strane
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
