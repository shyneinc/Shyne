class AppointmentStatus < ClassyEnum::Base
end

class AppointmentStatus::Proposed < AppointmentStatus
end

class AppointmentStatus::Scheduled < AppointmentStatus
end

class AppointmentStatus::Rescheduled < AppointmentStatus
end
