require 'rails_helper'

describe "Message pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  before do 
    sign_in user 
  end

  describe "nothing messages" do
    before { visit message_path(other_user) }

    it { should have_content("メッセージがないか、相手がいません") }
  end

  describe "message creation" do
    before do 
      @message = Message.new(content: "test",sender_id: user.id, reciptient_id: other_user.id)
      @message.save
      visit message_path(other_user)
    end

    describe "with invalid information" do

      it "should not create a message" do
        expect { click_button "Post" }.not_to change(Message, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'message_content', with: "Lorem ipsum" }
      it "should create a message" do
        expect { click_button "Post" }.to change(Message, :count).by(1)
      end
    end

  end
end
