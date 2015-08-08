class Api::V1::ApplicationController < ApplicationController
  respond_to :json
  before_filter :has_session_token, :set_auth_and_user, :set_format
  skip_before_filter :verify_authenticity_token

  def set_format
    request.format = 'json'
  end

  def error_with_message(error_message, status)
    render json: { errors: error_message }, status: status
  end

  def response_with_error(message, status)
    error_with_message message, status
  end

  def bad_request_error
    response_with_error("Bad request#{". #{@message}" if @message}", 400)
  end

  def not_found_error
    response_with_error('Not found', 404)
  end

  def forbidden_error
    response_with_error('Forbidden', 403)
  end

  def session_not_available_error
    response_with_error('Session was expired', 401)
  end

  def no_user_associated_with_token_error
    response_with_error('No user associated with that token', 401)
  end

  def has_params?(*required_params)
    if required_params.any? { |required_param| params[required_param].blank? }
      @message = ["Request requires parameters:", required_params.join(', ')].join ' '
      bad_request_error
      false
    else
      true
    end
  end

  def set_auth_and_user
    @auth = Authorization.where(token: params[:nhau_i_token]).first
    if @auth
      if @auth.expired?
        @auth.destroy
        session_not_available_error
      else
        @user = @auth.user
        if @user.nil?
          no_user_associated_with_token_error
        end
      end
    else
      session_not_available_error
    end
  end

  def has_session_token
    bad_request_error unless params[:nhau_i_token].present?
  end
end
