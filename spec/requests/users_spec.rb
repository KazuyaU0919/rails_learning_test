# spec/requests/users_spec.rb
require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users/new" do
    it "200が返る" do
      get new_user_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /users" do
    it "ユーザーを作成してログインする" do
      params = { user: { name: "Alice", email: "a@example.com", password: "secret123", password_confirmation: "secret123" } }
      expect {
        post users_path, params: params
      }.to change(User, :count).by(1)
      expect(session[:user_id]).to be_present
      expect(response).to redirect_to(root_path)
    end
  end
end
