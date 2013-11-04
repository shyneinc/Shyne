class Status < ClassyEnum::Base
end

class Status::Proposed < Status
end

class Status::Scheduled < Status
end

class Status::Rescheduled < Status
end
