module Api
  module V1
    class BillsController < Api::V1::ApplicationController
      def create
        if has_params?(*required_params)
          if bill = Bill.create(create_bill_options)
            render json: BillSerializer.new(bill)
          else
            response_with_error(bill.errors.full_messages.join('. '), :unprocessable_entity)
          end
        end
      end

      def create_bill_options
        params.permit(:total, :event_id, user_ids: [])
      end

      def event
        @event ||= Event.find(params[:event_id])
      end

      def required_params
        %w(total user_ids event_id)
      end
    end
  end
end
