class Message
  include Mongoid::Document
  include Mongoid::Extensions::Hash::IndifferentAccess
  include Mongoid::Timestamps::Created

  field :subject, type: String
  field :rsvp_id, type: String

  belongs_to :event
  belongs_to :user
  belongs_to :rsvp
end
