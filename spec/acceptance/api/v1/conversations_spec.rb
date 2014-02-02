require 'spec_helper'
require 'rspec_api_documentation/dsl'
include Warden::Test::Helpers

resource 'Conversation' do
  header "Accept", "application/vnd.shyne.v1"

  let(:user) { create(:member_user) }
  let(:mentor) { create(:mentor) }
  let(:conversation) { user.send_message(mentor.user, "World", "Hello").conversation }

  before do
    login_as user, scope: :user
  end

  get "/api/conversations" do
    parameter :box, "Box [inbox (default), sentbox, trash]", required: false
    parameter :page, "Page [1 (default)]", required: false

    example "Getting all conversations in inbox" do
      do_request(:box => "inbox", :page => 1)

      expect(response_body).to eq user.mailbox.inbox.page(1).per(9).to_json
      expect(status).to eq 200
    end

    example "Getting all conversations in sentbox" do
      do_request(:box => "sentbox", :page => 1)

      expect(response_body).to eq user.mailbox.sentbox.page(1).per(9).to_json
      expect(status).to eq 200
    end

    example "Getting all conversations in trash" do
      do_request(:box => "trash", :page => 1)

      expect(response_body).to eq user.mailbox.trash.page(1).per(9).to_json
      expect(status).to eq 200
    end
  end

  get "/api/conversations/:id" do
    let(:id) { conversation.id }

    example_request "Getting a specific conversation" do
      expect(response_body).to eq conversation.to_json(:include => [:messages => {:include => [:sender, :recipients]}])
      expect(status).to eq 200
    end
  end

  post "/api/conversations" do
    parameter :user_id, "User ID of the recepient", :required => true, :scope => :conversation
    parameter :subject, "Subject", :required => true, :scope => :conversation
    parameter :body, "Body", :required => true, :scope => :conversation

    example "Starting a conversation" do
      do_request(conversation: {user_id: mentor.user.id, subject: "Hello", body: "World"})

      expect(user.mailbox.sentbox.count).to eq 1
      expect(status).to eq 201
    end
  end

  put "/api/conversations/:id" do
    let(:id) { conversation.id }

    parameter :subject, "Subject", :required => true, :scope => :conversation
    parameter :body, "Body", :required => true, :scope => :conversation

    example "Replying to a conversation" do
      do_request(conversation: {subject: "Hello Again", body: "World"})

      expect(user.mailbox.sentbox.count).to eq 2
      expect(status).to eq 204
    end
  end

  delete "/api/conversations/:id" do
    let(:id) { conversation.id }

    example_request "Deleting a conversation" do
      expect(user.mailbox.trash.count).to eq 1
      expect(status).to eq 200
    end
  end
end