RSpec.describe "Photos", type: :request do
  describe "GET /photos" do
    it "returns a pending status" do
      pending "Implement this test"
      get "/photos"
      expect(response).to have_http_status(:pending)
    end
  end
end