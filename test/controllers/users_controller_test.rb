# test/controllers/users_controller_test.rb
require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "GET /users/new は表示できる" do
    get new_user_url
    assert_response :success
  end

  test "POST /users で新規登録できる" do
    assert_difference "User.count", +1 do
      post users_url, params: {
        user: {
          name: "テスト太郎",
          email: "taro@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end
    assert_redirected_to root_url
    assert_not_nil session[:user_id]
  end

  test "POST /users でバリデーションエラーなら422" do
    assert_no_difference "User.count" do
      post users_url, params: { user: { name: "", email: "bad", password: "1", password_confirmation: "2" } }
    end
    assert_response :unprocessable_entity
  end
end
