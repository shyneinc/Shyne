class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  acts_as_messageable

  validates :first_name, :last_name, presence: true
  validates :time_zone, :inclusion => { :in => ActiveSupport::TimeZone.us_zones.map(&:name) << "UTC" }
  validates_uniqueness_of :email, :message => "Email address has already been taken"

  after_validation :generate_username, :on => :create

  mount_uploader :avatar, AvatarUploader

  belongs_to :role, :dependent => :destroy, :polymorphic => true
  scope :not_deleted, -> { where("deleted_at = ?", nil) }

  def active_for_authentication?
    true && !deleted_at
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def balanced_customer
    return Balanced::Customer.find(self.customer_uri) if self.customer_uri

    begin
      customer = Balanced::Marketplace.mine.create_customer(
          :name   => self.full_name,
          :email  => self.email,
          :meta => {
              :user_id => self.id
          }
      )
    rescue
      'There was error fetching the Balanced customer'
    end

    self.customer_uri = customer.uri
    self.save
    customer
  end

  def soft_delete
    update_attribute(:deleted_at, Time.current)
  end

  private

  def generate_username
    tmp_username = "#{self.first_name}#{self.last_name}".gsub(/\s+/, "").to_s.downcase
    iterator = User.where("username like ?", "%#{tmp_username}%").pluck(:username).count
    tmp_username += iterator.to_s if iterator > 0 #append count where there are similar usernames
    self.username = tmp_username
  end
end
