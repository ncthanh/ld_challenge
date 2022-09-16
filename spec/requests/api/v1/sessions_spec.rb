require "rails_helper"

RSpec.describe "Api::V1::Sessions", type: :request do
  describe "POST /create" do
    let(:user) { User.new(username: "Test user", password: "password!") }

    before do
      allow(User).to receive(:find) { user }
    end

    it "authenticates the user returning 200 OK message" do
      allow(AuthTokenManager).to receive(:generate_token).and_return("sample_token")
      post api_v1_sessions_path, params: { username: "Test user", password: "password!" }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to eq("message" => "success", "token" => "sample_token")
    end

    it "returns an error when authentication fails" do
      post api_v1_sessions_path, params: { username: "Test user", password: "wrong" }
      expect(response).to have_http_status(:unauthorized)
      json = JSON.parse(response.body)
      expect(json).to eq("errors" => ["Invalid username or password"])
    end
  end
end
