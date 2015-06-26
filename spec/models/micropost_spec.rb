require 'rails_helper'
  

describe Micropost do
  let(:user) { FactoryGirl.create(:user) }
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end

  describe "when content is not present" do
    before { @micropost.content = nil }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end
end

describe "Reply Micropost" do
  let(:user) { FactoryGirl.create(:user, nickname: "ExUser") }
  let(:other_user) { FactoryGirl.create(:user, nickname: "ExReUser") }
  before do
    user.save
    other_user.save
    @micropost = user.microposts.build(content: "@ExReUser test")
    @micropost.save
  end

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }

  its(:in_reply_to) { should eq other_user}

  it { should be_valid }
end
