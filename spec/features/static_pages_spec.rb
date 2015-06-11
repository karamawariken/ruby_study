require 'rails_helper'

# RSpec.describe "StaticPages", type: :request do
#   describe "GET /static_pages" do
#     it "works! (now write some real specs)" do
#       visit '/static_pages/home'
#       expect(response).to have_content('Sample App')
#     end
#   end
# end

feature "Home page" do
  scenario "should have the content 'Sample App'" do
    visit '/static_pages/home'
    expect(page).to have_content('Sample App')
  end
end
