class UserSerializer < ActiveModel::Serializer
  attributes :user_id, :name

  def user_id
    object.id.to_s
  end
end
