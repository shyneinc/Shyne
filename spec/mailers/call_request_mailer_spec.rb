require "spec_helper"

describe CallRequestMailer do
  let(:call_request) { create(:call_request) }

  describe '#request_approved_mentor' do
    let(:approved_call_request) { CallRequestMailer.request_approved_mentor(call_request) }

    it "renders approved subject" do
      #approved_call_request.subject.should == "Call with #{call_request.member.user.first_name} scheduled for #{call_request.scheduled_date}"
      pending
    end
    it "renders the receiver email" do
      #approved_call_request.to.should eql [call_request.member.email]
      pending
    end
  end

  describe '#request_approved_member' do
    pending
  end

  describe '#request_proposed' do
    let(:proposed_call_request) { CallRequestMailer.request_proposed(call_request) }

    it "renders the receiver email" do
      proposed_call_request.to.should eql [call_request.mentor.email]
    end
    it "render proposed subject" do
      proposed_call_request.subject.should == "You've received a Call Request!"
    end
  end

  describe '#request_changed_mentor' do
    pending
  end

  describe '#request_changed_member' do
    pending
  end

  describe '#request_declined_mentor' do
    pending
  end

  describe '#request_declined_member' do
    pending
  end

  describe '#request_cancelled_mentor' do
    pending
  end

  describe '#request_cancelled_member' do
    pending
  end

  describe '#request_completed' do
    let(:completed_call_request) { CallRequestMailer.request_completed(call_request) }

    it "renders the receiver email" do
      completed_call_request.to.should eql [call_request.mentor.email]
    end
    it "renders completed subject" do
      completed_call_request.subject.should == "Summary of your call with #{call_request.member.full_name}"
    end
  end

  describe "#send_reminder" do
    let(:call_request_reminder) { CallRequestMailer.send_reminder(call_request) }

    it "renders a receiver email" do
      call_request_reminder.to.should eql [call_request.mentor.email]
    end
    it "renders a reminder subject" do
      call_request_reminder.subject.should == 'Reminder for your scheduled call'
    end
  end
end
