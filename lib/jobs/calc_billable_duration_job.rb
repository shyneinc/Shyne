class CalcBillableDurationJob
  def perform
    CallRequest.where(billable_duration: nil, status: [:approved_mentor, :approved_member]).find_each do |call_request|
      call_request.calculate_billable_duration
    end
  end
end