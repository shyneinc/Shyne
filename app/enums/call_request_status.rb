class CallRequestStatus < ClassyEnum::Base
end

class CallRequestStatus::Proposed < CallRequestStatus
end

class CallRequestStatus::Scheduled < CallRequestStatus
end

class CallRequestStatus::Rescheduled < CallRequestStatus
end
