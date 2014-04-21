class MentorStatus < ClassyEnum::Base
end

class MentorStatus::Applied < MentorStatus
end

class MentorStatus::Reapplied < MentorStatus
end

class MentorStatus::Approved < MentorStatus
end

class MentorStatus::Declined < MentorStatus
end
