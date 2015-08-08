module Api
  module V1
    class SessionsController < Api::V1::ApplicationController

      skip_before_filter :has_session_token, :set_auth_and_user

      def create
        if has_params?(*require_params)
          if login_service.create
            respond_with({ session: login_service.session_response }, status: 200, location: nil)
          else
            response_with_error login_service.errors, :forbidden
          end
        end
      end

      protected
      def init_params
        user_params = params.slice(*require_params)
        user_params.merge({
          token: params[:token],
          request: request,
          request_env: @request_env,
          source: "facebook"
        })
      end

      def require_params
        ["token"]
      end

      def login_service_class
        ::Services::User::SocialAuthentication
      end

      def login_service
        @login_service ||= login_service_class.new(init_params)
      end
    end
  end
end
