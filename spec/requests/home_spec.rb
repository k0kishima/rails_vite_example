require "rails_helper"

RSpec.describe "Home", type: :request do
  describe "GET /" do
    it "renders the index template" do
      get root_path

      expect(response).to have_http_status(:success)

      expect(response.body).to include("<h1>Home#index</h1>")
      expect(response.body).to include("<p>Find me in app/views/home/index.html.erb</p>")
    end
  end
end
