module Api
  module V1
    class FriendsController < Api::V1::ApplicationController
      def index
        render json: @user.friends, each_serializer: UserSerializer
      end
    end
  end
end
