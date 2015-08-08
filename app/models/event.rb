class Event
  include Mongoid::Document
  include Mongoid::Extensions::Hash::IndifferentAccess
  include Mongoid::Timestamps::Created

  field :name, type: String
  field :start_time, type: DateTime
  field :status, type: String, default: 'upcoming'

  belongs_to :owner, class_name: 'User'
  has_many :rsvps

  validates :status, inclusion: { in: %w(upcoming ended), message: "%{value} is not a valid status" }
end
