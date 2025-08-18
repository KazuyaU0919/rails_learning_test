# test/controllers/sessions_controller_test.rb
require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "ログイン用",
      email: "login@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  test "GET /session/new は表示できる" do
    get new_session_url
    assert_response :success
  end

  test "正しい情報でログインできる" do
    post session_url, params: { email: @user.email, password: "password" }
    assert_redirected_to root_url
    assert_equal @user.id, session[:user_id]
  end

  test "誤った情報なら422" do
    post session_url, params: { email: @user.email, password: "wrong" }
    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "ログアウトできる" do
    # 先にログイン
    post session_url, params: { email: @user.email, password: "password" }
    delete session_url
    assert_redirected_to root_url
    assert_nil session[:user_id]
  end
end
