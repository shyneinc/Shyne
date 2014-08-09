class AdvisorStatus < ClassyEnum::Base
end

class AdvisorStatus::Applied < AdvisorStatus
end

class AdvisorStatus::Reapplied < AdvisorStatus
end

class AdvisorStatus::Approved < AdvisorStatus
end

class AdvisorStatus::Declined < AdvisorStatus
end
