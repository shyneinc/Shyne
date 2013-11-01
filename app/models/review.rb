class Review < ActiveRecord::Base
  validates :review, :rating, :mentor, :member, presence: true

  belongs_to :mentor
  belongs_to :member
  belongs_to :call
end
