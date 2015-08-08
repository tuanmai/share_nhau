module Api
  module V1
    class BillsController < Api::V1::ApplicationController
      before_filter :set_bill, only: [:update]

      def create
        if has_params?(*required_params)
          if bill = Bill.create(create_bill_options)
            render json: BillSerializer.new(bill)
          else
            response_with_error(bill.errors.full_messages.join('. '), :unprocessable_entity)
          end
        end
      end

      def update
        if has_params?(*required_params)
          if @bill.update_attributes(create_bill_options)
            render json: BillSerializer.new(@bill)
          else
            response_with_error(@bill.errors.full_messages.join('. '), :unprocessable_entity)
          end
        end
      end

      def set_bill
        event_ids = Event.where(owner: @user).pluck(:id)
        @bill = Bill.where(:event_id.in => event_ids, id: params[:id]).first
        not_found_error unless @bill
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
