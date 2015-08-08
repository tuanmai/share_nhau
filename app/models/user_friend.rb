class UserFriend
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Extensions::Hash::IndifferentAccess

  belongs_to :user_1, class_name: 'User'
  belongs_to :user_2, class_name: 'User'
end
