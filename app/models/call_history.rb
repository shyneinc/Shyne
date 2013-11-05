class CallHistory < ActiveRecord::Base
  classy_enum_attr :status, default: :inprogress

  belongs_to :call
end
