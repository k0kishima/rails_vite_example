require "rails_helper"

RSpec.describe "Sample E2E Test", type: :system do
  it "displays dynamically updated content via JavaScript" do
    visit root_path

    expect(page).to have_content("E2E Test Example")
  end
end
