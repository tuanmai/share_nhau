class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Extensions::Hash::IndifferentAccess
  include Concerns::User::Session
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable

  devise :trackable

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  field :name,               type: String
  field :fb_id,              type: String
  field :expired_in,         type: Date

  has_many :events

  def set_long_live_token
    if !expired_in || 2.days.from_now > expired_in
      @long_live_token = CGI::parse(HTTParty.get(facebook_graph_long_live_url).parsed_response)
      debugger
      self.set token: @long_live_token['access_token'].first
      self.set expired_in: 60.days.from_now
    end
  end

  def facebook_graph_long_live_url
    "https://graph.facebook.com/oauth/access_token?grant_type=fb_exchange_token&client_id=1629273283955926&client_secret=53d9126cde330907cb687d2be4890cc2&fb_exchange_token=#{self.token}"
  end
end
