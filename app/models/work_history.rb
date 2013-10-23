class WorkHistory < ActiveRecord::Base
	validates :company, :date_started, :mentor, :title, presence: true
	belongs_to :mentor
end
