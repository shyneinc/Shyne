class Call < ActiveRecord::Base
  belongs_to :member
  belongs_to :mentor

  after_validation :generate_passcode, :on => :create

  has_many :reviews

  just_define_datetime_picker :scheduled_at

  private
    def generate_passcode
      #smallint have 32,767 limit and checked for uniqueness
      begin
        tmp_passcode = Random.new.rand(10_000..32_767-1) 
      end while Call.find_by_passcode(tmp_passcode)
        
      self.passcode = tmp_passcode
    end
end
