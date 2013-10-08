class Call < ActiveRecord::Base
  belongs_to :member
  belongs_to :mentor
end
