require 'rails_helper'
include ApplicationHelper
# RSpec.describe "StaticPages", type: :request do
#   describe "GET /static_pages" do
#     it "works! (now write some real specs)" do
#       visit '/static_pages/home'
#       expect(response).to have_content('Sample App')
#     end
#   end
# end

feature "Static pages" do
  subject { page }

  feature "Home page" do
    before { visit root_path }
    it { should have_content('Sample App') }
    it { should have_title(full_title('')) }
    it { should_not have_title('Home') }
  end

  feature "Help page" do
    before { visit help_path }
    it { should have_content('Help') }
    it { should have_title(full_title("Help")) }
  end

  feature "About page" do
    before { visit about_path }
    it { should have_content('About Us') }
    it { should have_title(full_title("About Us")) }
  end


  feature "Contact page"  do
    before { visit contact_path }
    it { should have_content('Contact') }
    it { should have_title(full_title("Contact")) }
  end

end