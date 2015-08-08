module Concerns
  module User
    module Session
      extend ActiveSupport::Concern
      def find_authorization
        Authorization.by_uid_and_not_expired(id.to_s).first
      end

      def create_authorization
        Authorization.create(:uid => id.to_s, :user_id => id)
      end

      def delete_all_authorizations
        Authorization.by_uid(id.to_s).delete_all
      end

      def find_or_create_authorization
        if (authorization = find_authorization).nil?
          delete_all_authorizations
          authorization = create_authorization
        end
        authorization
      end
    end
  end
end
