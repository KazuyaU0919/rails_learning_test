# test/controllers/omni_auth_controller_test.rb
require "test_helper"

class OmniAuthControllerTest < ActionDispatch::IntegrationTest
  test "GET /auth/:provider は callback にリダイレクト(テストモード既定)" do
    get auth_url(provider: "github")
    assert_response :redirect
    assert_redirected_to omni_auth_callback_url(provider: "github")
  end

  test "GitHub 初回はユーザー作成されてログインする" do
    mock_omniauth(provider: "github", uid: "gh-1", name: "GH User", email: "gh@example.com")

    assert_difference "User.count", +1 do
      get omni_auth_callback_url(provider: "github")
    end
    assert_redirected_to root_url
    assert_not_nil session[:user_id]
  end

  test "GitHub 二回目は作成されずログインのみ" do
    # 1回目で作成
    mock_omniauth(provider: "github", uid: "gh-1", name: "GH User", email: "gh@example.com")
    get omni_auth_callback_url(provider: "github")

    # 2回目は作成されない
    mock_omniauth(provider: "github", uid: "gh-1", name: "GH User", email: "gh@example.com")
    assert_difference "User.count", 0 do
      get omni_auth_callback_url(provider: "github")
    end
    assert_redirected_to root_url
  end

  test "/auth/failure はログイン画面へリダイレクト" do
    get omni_auth_failure_url
    assert_redirected_to new_session_url
  end
end
