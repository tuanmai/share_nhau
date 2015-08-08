module Services
  module User
    class SocialAuthentication < Services::Base
      ATTRIBUTES = [:token, :device_token, :request, :request_env]
      attr_accessor :user, :errors, *ATTRIBUTES

      def initialize(options = {})
        assign_attributes(options.slice(*self.class::ATTRIBUTES))
      end

      def create
        self.user = default
        if user && user.errors.blank?
          true
        else
          self.errors = "Invalid token"
          false
        end
      end


      def session_response
        authorization = user.find_or_create_authorization
        {
          token: authorization.token,
          expires: authorization.expires,
          platform: authorization.platform,
          user: UserSerializer.new(user)
        }
      end

      protected
      def creator_class
        ::Services::User::FacebookCreator
      end

      def default
        creator = creator_class.new(token, {})
        creator.find_or_create
      end
    end
  end
end
