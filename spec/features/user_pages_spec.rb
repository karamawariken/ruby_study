require 'rails_helper'
include ApplicationHelper

feature "User pages" do
  subject { page }

  feature "signup page" do
    before { visit signup_path }
    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end
end