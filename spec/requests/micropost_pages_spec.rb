require 'rails_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end

    describe "reply micropost" do
      let(:reply_user) { FactoryGirl.create(:user) }
      before do
        user.save
        reply_user.save
        fill_in 'micropost_content', with: "@#{reply_user.nickname} test"
        click_button "Post"
        sign_in reply_user
        visit root_path
      end

      it { should have_content("@#{reply_user.nickname} test") }
    end

    describe "make message in micropost_form" do
      let(:message_user) { FactoryGirl.create(:user) }
      before do
        user.save
        message_user.save
      end
      describe "makeing message" do
        before do 
          fill_in 'micropost_content', with: "d @#{message_user.nickname} test"
          click_button "Post"
        end
        it "when valid_message " do
          valid_messages = ["d\s@#{message_user.nickname} test",
                            "d/\u3000/@#{message_user.nickname} test",
                            "d\t@#{message_user.nickname} test",
                            "d\r@#{message_user.nickname} test",
                            "d\n@#{message_user.nickname} test",
                            "d\f@#{message_user.nickname} test",
                            "d\v@#{message_user.nickname} test",
                            "d\t\r\n\f\v@#{message_user.nickname} test"
                            ]
          valid_messages.each do |valid_message|
            should_not have_content(valid_message) 
            visit message_path(message_user) 
            should_not have_content(valid_message)
            should have_content("test")
          end 
        end

        it "when invalid_message " do
          valid_messages = ["d @#{message_user.nickname}","d　@#{message_user.nickname}test"]
          valid_messages.each do |valid_message|
            should_not have_content(valid_message) 
            should_not have_content("error") 
            visit message_path(message_user) 
            should_not have_content(valid_message)
            should have_content("test")
          end 
        end

      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end
end
