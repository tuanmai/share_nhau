module Api
  module V1
    class EventsController < Api::V1::ApplicationController
      def index
        render json: @user.events.to_a, each_serializer: EventSerializer
      end

      def create
        if has_params?(*required_params)
          if event = @user.events.create(create_event_options)
            render json: { event: EventSerializer.new(event, root: false) }
          else
            response_with_error(event_management.errors, :unprocessable_entity, 'failed')
          end
        end
      end

      def required_params
        %w(name start_time)
      end

      def create_event_options
        params.permit(:name, :start_time)
      end
    end
  end
end
