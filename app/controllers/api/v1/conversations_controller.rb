class Api::V1::ConversationsController < Api::V1::BaseController
  before_filter :authenticate_user!
  before_filter :get_mailbox

  def index
    if params[:box].blank? or !["inbox", "sentbox", "trash"].include? params[:box]
      params[:box] = 'inbox'
    end

    @box = params[:box]

    if @box.eql? "inbox"
      @conversations = @mailbox.inbox.page(params[:page]).per(9)
    elsif @box.eql? "sentbox"
      @conversations = @mailbox.sentbox.page(params[:page]).per(9)
    else
      @conversations = @mailbox.trash.page(params[:page]).per(9)
    end

    render :json => @conversations, :status => 200
  end

  def show
    conversation = @mailbox.conversations.find(params[:id])
    if conversation
      render :json => conversation, :status => 200
    else
      render :json => {}, :status => 401
    end
  end

  def create
    recipient = User.where(id: conversation_params[:user_id]).first
    conversation = current_user.send_message(recipient, conversation_params[:body], conversation_params[:subject]).conversation
    render :json => conversation, :status => 201
  end

  def update
    conversation = @mailbox.conversations.find(params[:id])
    current_user.reply_to_conversation(conversation, conversation_params[:body], conversation_params[:subject])
    render :json => {}, :status => 204
  end

  def destroy
    conversation = @mailbox.conversations.find(params[:id])
    conversation.move_to_trash(current_user)
    render :json => {}, :status => 200
  end

  private

  def get_mailbox
    @mailbox = current_user.mailbox
  end

  def conversation_params
    params.require(:conversation).permit(:user_id, :subject, :body)
  end

end