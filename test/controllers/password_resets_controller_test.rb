# test/controllers/password_resets_controller_test.rb
require "test_helper"

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  test "GET /password_resets/new は表示できる" do
    get new_password_reset_url
    assert_response :success
  end

  test "GET /password_resets/:token/edit は（仮）表示できる" do
    # 実装後は、実際の token を用意して動かす
    skip "reset_token 実装後に有効なトークンで検証する"
    get edit_password_reset_url("dummy-token")
    assert_response :success
  end
end
