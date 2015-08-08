class UserSerializer < ActiveModel::Serializer
  attributes :_id, :name

  def _id
    object.id.to_s
  end
end
