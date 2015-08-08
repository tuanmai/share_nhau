class EventSerializer < ActiveModel::Serializer
  attributes :_id, :name, :start_time, :status
  has_one :owner

  def _id
    object.id.to_s
  end
end
