require "spec_helper"

describe CallRequestMailer do
	let(:call_request){ create(:call_request) }

  describe '#request_approved' do
  	let(:mail) { CallRequestMailer.request_approved(call_request) }

  	it "renders approved subject" do
    	mail.subject.should == 'Call request have been approved!'
    end
    it "renders the reciever email" do
    	mail.to.should eql [call_request.member.email]
    end
    it "renders the sender email" do
    	mail.from.should eql ['no-reply@shyne.io']
    end
    it "contains the mentor" do
    	mail.body.encoded.should match(call_request.mentor.full_name)
    end
    it "contains the passcode" do
    	mail.body.encoded.should match(call_request.passcode.to_s)
    end
    it "contains the scheduled date and time" do
    	mail.body.encoded.should match(call_request.scheduled_at.to_s(:short))
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
