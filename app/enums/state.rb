class State < ClassyEnum::Base
end

class State::Queued < State
end

class State::Ringing < State
end

class State::Inprogress < State
end

class State::Completed < State
end

class State::Busy < State
end

class State::Failed < State
end

class State::Canceled < State
end
