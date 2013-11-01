class Call < ActiveRecord::Base
  belongs_to :member
  belongs_to :mentor

  has_many :reviews

  just_define_datetime_picker :scheduled_at
end
