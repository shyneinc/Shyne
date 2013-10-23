class WorkHistory < ActiveRecord::Base
	validates :company, :date_started, :mentor, presence: true
	belongs_to :mentor
end
