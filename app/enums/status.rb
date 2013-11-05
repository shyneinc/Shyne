class Status < ClassyEnum::Base
end

class Status::Inprogress < Status
end

class Status::Completed < Status
end

class Status::Failed < Status
end

class Status::Canceled < Status
end
