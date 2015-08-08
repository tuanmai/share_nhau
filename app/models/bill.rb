class Bill
  include Mongoid::Document
  include Mongoid::Extensions::Hash::IndifferentAccess
  include Mongoid::Timestamps::Created

  field :total, type: Integer
  field :user_ids, type: Array, default: []

  belongs_to :event

  def share_for_user
    self.total / self.user_ids.count
  end
end
