class RequestStatus < ClassyEnum::Base
end

class RequestStatus::Proposed < RequestStatus
end

class RequestStatus::Scheduled < RequestStatus
end

class RequestStatus::Rescheduled < RequestStatus
end
