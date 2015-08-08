require 'bcrypt'

class Authorization
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  field :token, type: String
  field :uid, type: String # this is the owning users _id
  field :platform, type: String
  field :expires, type: DateTime
  field :ip, type: String
  field :fb_id, type: String
  field :token, type: String
  field :expired_in, type: Date

  validates :fb_id, :token, presence: true
  validates :uid, :user_id, presence: true

  belongs_to :user

  before_create :set_expire_time
  before_validation :generate_token


  scope :not_expired, ->(expires = DateTime.now.utc) { gte(:expires => expires) }
  scope :by_uid, ->(uid) { where(:uid => uid) }
  scope :by_uid_and_not_expired, ->(uid) do
    not_expired.by_uid(uid)
  end

  index({:token => 1}, {:unique => true})
  index({:uid => 1, :platform => 1}, {:unique => true})

  def expired?
    return false unless self.expires.present?
    if self.expires < Time.now
      true
    else
      false
    end
  end

  def set_expire_time
    self.expires ||= self.created_at + 30.days
  end

  def generate_token
    self.token ||= BCrypt::Password.create("#{uid}#{Time.now}")
  end
end
