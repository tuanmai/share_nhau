class Rsvp
  include Mongoid::Document
  include Mongoid::Extensions::Hash::IndifferentAccess
  include Mongoid::Timestamps::Created

  field :going, type: Boolean, default: false

  belongs_to :event
  belongs_to :user
end