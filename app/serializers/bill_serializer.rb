class BillSerializer < ActiveModel::Serializer
  attributes :_id, :total, :rsvps, :share_for_user

  def _id
    object.id.to_s
  end

  def rsvps
    ActiveModel::ArraySerializer.new User.where(:id.in => object.user_ids), each_serializer: UserSerializer
  end

  def share_for_user
    object.share_for_user
  end
end
