class Review < ActiveRecord::Base
  validates :review, :rating, :mentor, :member, presence: true
  validates :rating, :inclusion => 0..5

  belongs_to :mentor
  belongs_to :member
  belongs_to :call

  def created_date
    self.created_at.strftime("%^B %d")
  end
end
