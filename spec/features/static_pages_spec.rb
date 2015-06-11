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

  scenario "should have the title 'Home'" do
    visit 'static_pages/home'
    expect(page).to have_title("Ruby on Rails Tutorial Sample App | Home")
  end
end

feature "Help page" do
  scenario "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
  end
end

feature "About page" do
  scenario "should have the content 'About Us'" do
      visit '/static_pages/about'
      expect(page).to have_content('About Us')
  end
end