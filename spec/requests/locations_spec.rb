RSpec.describe "Locations", type: :request do
  describe "GET /locations" do
    it "returns a pending status" do
      pending "Implement this test"
      get "/locations"
      expect(response).to have_http_status(:pending)
    end
  end
end