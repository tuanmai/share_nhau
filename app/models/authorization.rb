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

   def set_long_live_token
    if !expired_in || 2.days.from_now > expired_in
      @long_live_token = CGI::parse(HTTParty.get(facebook_graph_long_live_url).parsed_response)
      self.set token: @long_live_token['access_token'].first
      self.set expired_in: 60.days.from_now
    end
  end

  def facebook_graph_long_live_url
    "https://graph.facebook.com/oauth/access_token?grant_type=fb_exchange_token&client_id=1629273283955926&client_secret=53d9126cde330907cb687d2be4890cc2&fb_exchange_token=#{self.token}"
  end
end
