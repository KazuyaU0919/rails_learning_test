# spec/requests/password_resets_spec.rb
require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  it "GET /password_resets/new が 200" do
    get new_password_reset_path
    expect(response).to have_http_status(:ok)
  end

  it "GET /password_resets/:token/edit が 200（ダミーtoken）" do
    get edit_password_reset_path("dummy-token")
    expect(response).to have_http_status(:ok)
  end
end
