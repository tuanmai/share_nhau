class EventSerializer < ActiveModel::Serializer
  attributes :_id, :name, :start_time, :status, :total_bill, :bill_for_user
  has_one :owner
  has_many :rsvps
  has_many :bills

  def _id
    object.id.to_s
  end

  def bill_for_user
    object.bill_for_user
  end
end
