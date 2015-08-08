class RsvpSerializer < ActiveModel::Serializer
  attributes :_id, :going, :event_id, :user_id

  def _id
    object.id.to_s
  end

  def event_id
    object.event.id.to_s
  end

  def user_id
    object.user.id.to_s
  end
end
