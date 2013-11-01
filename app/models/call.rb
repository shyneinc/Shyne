class Call < ActiveRecord::Base
  belongs_to :member
  belongs_to :mentor

  after_validation :generate_passcode, :on => :create

  has_many :reviews

  just_define_datetime_picker :scheduled_at

  private
    def generate_passcode
      #should check for uniqueness
      #smallint have 32,767 limit
      self.passcode = Random.new.rand(10_000..32_767-1) 
    end
end
