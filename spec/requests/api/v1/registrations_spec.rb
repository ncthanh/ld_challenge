require "rails_helper"

RSpec.describe "Api::V1::Registrations", type: :request do
  describe "POST /create" do
    it "creates a new account" do
      post api_v1_registrations_path, params: { user: { username: "User1_#{Time.now.to_i}", password: "password!", password_confirmation: "password!" } }
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json).to eq("message" => "Success")
    end

    it "returns an error when password_confirmation doesn't match" do
      post api_v1_registrations_path, params: { user: { username: "User2_#{Time.now.to_i}", password: "password!", password_confirmation: "wrong" } }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to eq("errors" => { "password_confirmation" => ["doesn't match Password"] })
    end

    it "returns an error when username is already taken" do
      post api_v1_registrations_path, params: { user: { username: "User_#{Time.now.to_i}", password: "password!", password_confirmation: "password!" } }
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json).to eq("message" => "Success")

      post api_v1_registrations_path, params: { user: { username: "User_#{Time.now.to_i}", password: "password!", password_confirmation: "password!" } }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to eq("errors" => { "username" => ["has already been taken"] })
    end
  end
end
