class MessageSerializer < ActiveModel::Serializer
  attributes :_id, :subject, :event_id

  has_one :rsvp

  def _id
    object.id.to_s
  end

  def event_id
    object.event.id.to_s
  end
end
