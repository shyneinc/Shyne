class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :first_name, :last_name, presence: true
  validates :time_zone, :inclusion => { :in => ActiveSupport::TimeZone.us_zones.map(&:name) << "UTC" }

  after_validation :generate_username, :on => :create

  mount_uploader :avatar, AvatarUploader

  belongs_to :role, :dependent => :destroy, :polymorphic => true

  def active_for_authentication?
    true
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  private

  def generate_username
    tmp_username = "#{self.first_name}#{self.last_name}".gsub(/\s+/, "").to_s.downcase
    iterator = User.where("username like ?", "%#{tmp_username}%").pluck(:username).count
    tmp_username += iterator.to_s if iterator > 0 #append count where there are similar usernames
    self.username = tmp_username
  end
end
