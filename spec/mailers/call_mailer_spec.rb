require "spec_helper"

describe CallRequestMailer do
	let(:call_request){ create(:call_request) }

  describe '#request_approved' do
  	let(:mailapproved) { CallRequestMailer.request_approved(call_request) }

  	it "renders approved subject" do
    	mailapproved.subject.should == 'Call request have been approved!'
    end
    it "renders the reciever email" do
    	mailapproved.to.should eql [call_request.member.email]
    end
    it "renders the sender email" do
    	mailapproved.from.should eql ['no-reply@shyne.io']
    end
    it "contains the mentor" do
    	mailapproved.body.encoded.should match(call_request.mentor.full_name)
    end
    it "contains the passcode" do
    	mailapproved.body.encoded.should match(call_request.passcode.to_s)
    end
    it "contains the scheduled date and time" do
    	mailapproved.body.encoded.should match(call_request.scheduled_at.to_s(:short))
    end
  end
  describe '#request_proposed' do
  	let(:mailproposed) { CallRequestMailer.request_proposed(call_request) }

  	it "renders the reciever email" do
      mailproposed.to.should eql [call_request.mentor.email]
    end
    it "render proposed subject" do
    	mailproposed.subject.should == 'Call request have been proposed!'
    end
  end
  describe '#request_changed' do
  	let(:mailchanged) { CallRequestMailer.request_changed(call_request) }

    it "renders the reciever email" do
      mailchanged.to.should eql [call_request.member.email]
    end
    it "renders changed subject" do
    	mailchanged.subject.should == 'Schedule change has been proposed!'
    end
  end
  describe '#request_completed' do
  	let(:mailcomplete) { CallRequestMailer.request_completed(call_request) }

    it "renders the reciever email" do
    	mailcomplete.to.should eql [call_request.mentor.email]
    end
    it "renders completed subject" do
    	mailcomplete.subject.should == "Summary of your call with #{call_request.member.full_name}"
    end
  end
  describe "#send_reminder" do
  	let(:mailreminder) { CallRequestMailer.send_reminder(call_request) }

  	it "renders a reciever email" do
  		mailreminder.to.should eql [call_request.mentor.email]
  	end
  	it "renders a reminder subject" do
  		mailreminder.subject.should == 'Reminder for your scheduled call'	
  	end
  end
end
