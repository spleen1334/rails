require 'test_helper'

class StoreControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success

    assert_select '#columns #side a', minimum: 4
    assert_select '#main .entry', 3
    assert_select 'h3', 'Programming Ruby 1.9' # testira fixure
    assert_select '.price', /\€[,\d]+\.\d\d/
  end

  # Proveri da li postoji <img> i input (dugme za add to cart)
  test "markup needed to store.js.coffe is in place" do
    get :index

    assert_select '.store .entry > img', 3
    assert_select '.entry input[type=submit]', 3
  end

end
