require "rails_helper"

RSpec.describe "Admin::Dashboards", type: :request do
  let(:admin) { create(:user, admin: true, password: "secret", password_confirmation: "secret") }

  it "GET /admin returns 200 for admin" do
    sign_in_as(admin, password: "secret")
    get admin_root_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Dashboard")
  end
end
