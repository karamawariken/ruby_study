require 'rails_helper'


describe Message do

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  before do  
    user.save
    other_user.save
    @message = Message.new(content: "test",sender_id: user.id, reciptient_id: other_user.id)
  end

  subject { @message }

  it { should respond_to(:content) }
  it { should respond_to(:sender_id) }
  it { should respond_to(:reciptient_id) }

  it { should respond_to(:sender_user) }
  it { should respond_to(:reciptient_user) }

  it { should be_valid }

  describe "when content is not present" do
    before { @message.content = nil }
    it { should_not be_valid }
  end

  describe "when sender_id is not present" do
    before { @message.sender_id = nil }
    it { should_not be_valid }
  end

  describe "when reciptient_id is not present" do
    before { @message.reciptient_id = nil }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @message.content = "a" * 141 }
    it { should_not be_valid }
  end

end