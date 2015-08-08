class EventSerializer < ActiveModel::Serializer
  attributes :_id, :name, :start_time, :status
  has_one :owner
  has_many :rsvps
  has_many :bills

  def _id
    object.id.to_s
  end
end
