class ProcessPaymentJob
  def perform
    CallRequest.where(status: [:completed, :processed_member, :processed_advisor]).find_each do |call_request|
      call_request.process_payment
    end
  end
end