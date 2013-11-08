class CallStatus < ClassyEnum::Base
end

class CallStatus::Inprogress < CallStatus
end

class CallStatus::Completed < CallStatus
end

class CallStatus::Failed < CallStatus
end

class CallStatus::Canceled < CallStatus
end
