module Api
  module V1
    class RsvpsController < Api::V1::ApplicationController
      def index
        render json: @user.events.to_a, each_serializer: EventSerializer
      end

      def create
        if has_params?(*required_params)
          params[:user_ids].each do |user_id|
            event.rsvps.first_or_create(user_id: user_id)
          end
          create_invite_message
          render json: EventSerializer.new(event)
        end
      end

      def show
        event = Rsvp.where(id: params[:id]).first
        if event
          render json: RsvpSerializer.new(rsvp)
        else
          forbidden_error
        end
      end

      def update
        rsvp = @user.rsvps.where(id: params[:id]).first
        if rsvp && rsvp.update_attributes(going: params[:going])
          render json: RsvpSerializer.new(rsvp)
        else
          forbidden_error
        end
      end

      private
      def required_params
        %w(user_ids event_id)
      end

      def create_event_options
        params.permit(:name, :start_time)
      end

      def event
        @event = Event.find params[:event_id]
      end

      def create_invite_message
        User.where(:id.in => params[:user_ids]).each do |user|
          rsvp = @user.rsvps.where(event_id: event.id.to_s).first
          Message.create(subject: "#{@user.name} invite you to an event.", event: event, user: user, rsvp: rsvp)
        end
      end
    end
  end
end
