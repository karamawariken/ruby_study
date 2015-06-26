require 'rails_helper'
# RSpec.describe "StaticPages", type: :request do
#   describe "GET /static_pages" do
#     it "works! (now write some real specs)" do
#       visit '/static_pages/home'
#       expect(response).to have_content('Sample App')
#     end
#   end
# end

describe "Static pages" do
  subject { page }

  shared_examples_for "all static pages" do
    it{should have_content(heading)}
    it{should have_title(full_title(page_title))}
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading) {'Sample App'}
    let(:page_title) {''}

    it { should_not have_title('Home') }
    it_should_behave_like "all static pages"


    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      #フォローしているユーザーとフォロワーのカウントがページに表示され、それぞれに正しいURLが設定されている
      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end

    describe "reply microposts " do
      let(:user) { FactoryGirl.create(:user) }
      let(:reply_user) { FactoryGirl.create(:user) }
      before do
        user.save
        reply_user.save
        FactoryGirl.create(:micropost, user: user, content: "@#{reply_user.name} from #{user.name}")
        sign_in reply_user
        visit root_path
      end

      it { should have_content("@#{reply_user.name} from #{user.name}")}
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading) {'Help'}
    let(:page_title) {'Help'}

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading) {'About Us'}
    let(:page_title) {'About Us'}

    it_should_behave_like "all static pages"
  end


  describe "Contact page"  do
    before { visit contact_path }
    let(:heading) {'Contact'}
    let(:page_title) {'Contact'}

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
    click_link "sample app"
    expect(page).to have_title(full_title(''))
  end

end
