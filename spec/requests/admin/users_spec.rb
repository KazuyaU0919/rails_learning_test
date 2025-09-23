require "rails_helper"

RSpec.describe "Admin::Users", type: :request do
  let(:admin) { create(:user, admin: true) }
  let(:target) { create(:user) }

  before { sign_in admin }

  describe "GET /admin/users" do
    it "一覧が表示される" do
      target = create(:user, email: "test_user@example.com")
      get admin_users_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("test_user@example.com")
    end
  end

  describe "PATCH /toggle_editor" do
    it "編集者権限を切替できる" do
      patch toggle_editor_admin_user_path(target)
      expect(target.reload.editor).to eq(true)
    end
  end

  describe "PATCH /toggle_ban" do
    it "BANを設定できる" do
      patch toggle_ban_admin_user_path(target), params: { ban_reason: "test" }
      expect(target.reload).to be_banned
    end
  end

  describe "DELETE /users/:id" do
    it "ユーザーを削除できる" do
      delete admin_user_path(target)
      expect(User.exists?(target.id)).to eq(false)
    end
  end
end
