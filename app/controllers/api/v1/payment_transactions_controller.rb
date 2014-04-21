class Api::V1::PaymentTransactionsController < Api::V1::BaseController

  def index
    if ['credit.failed', 'debit.failed'].include? params[:type]
      type = params[:type].split('.').first
      status = params[:type].split('.').last
      call_request_id = params[:entity][:meta][:call_request_id]
      call_request = CallRequest.find(call_request_id)
      last_transaction = call_request.payment_transactions.where(type: type).last
      call_request.payment_transactions.create(type: type, amount: last_transaction.amount, status: status, uri: last_transaction.uri)
      #TODO: Set the call_request status to "review" and trigger an email to call for some action
    end

    render :json => {}, :status => 200
  end

end
