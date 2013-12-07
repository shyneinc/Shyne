require "spec_helper"

describe CallRequestMailer do
	let(:call_request){ create(:call_request) }

  describe '#request_approved' do
  	let(:mail) { CallRequestMailer.request_approved(call_request) }

  	it "renders approved subject" do
    	mail.subject.should == 'Call request have been approved!'
    end
    it "renders the reciever email" do
    	pending
    end
    it "renders the sender email" do
    	pending
    end
    it "contains the mentor" do
    	pending
    end
    it "contains the passcode" do
    	pending
    end
    it "contains the scheduled date and time" do
    	pending
    end
  end
  describe '#request_proposed' do
  	it "should description" do
      pending
    end
  end
  describe '#request_changed' do
    it "should description" do
      pending
    end
  end
  describe '#request_completed' do
    it "should description" do
    	pending 
    end
  end
end
