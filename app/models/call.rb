class Call < ActiveRecord::Base
  classy_enum_attr :status, default: :proposed

  belongs_to :member
  belongs_to :mentor

  after_validation :generate_passcode, :on => :create
  after_update :send_status_update, :if => :status_changed?

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

    def send_status_update
      if self.status.proposed?
        puts 'send proposed sked'
      elsif self.status.scheduled?
        puts 'send sked confirmation'
      elsif self.status.rescheduled?
        puts 'send sked retry'
      end   
    end
end
