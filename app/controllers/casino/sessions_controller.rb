# require 'casino/application_controller'

class Casino::SessionsController < Casino::ApplicationController
  include Casino::SessionsHelper
  include Casino::AuthenticationProcessor
  include Casino::TwoFactorAuthenticatorProcessor
  # The original way we overwrote these methods (for whatever reason)
  # so to not need to update the custom EMR code we can skip this because
  # the ticket gets generated in the create method in the new version.
  # before_action :validate_login_ticket, only: [:create]
  before_action :ensure_service_allowed, only: [:new, :create]
  before_action :load_ticket_granting_ticket_from_parameter, only: [:validate_otp]
  before_action :ensure_signed_in, only: [:index, :destroy]

  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  def index
    @ticket_granting_tickets = current_user.ticket_granting_tickets.active
    @two_factor_authenticators = current_user.two_factor_authenticators.active
    @login_attempts = current_user.login_attempts.order(created_at: :desc).first(5)
  end

  def new
    respond_to do |format|
      format.html do
        tgt = current_ticket_granting_ticket
        return handle_signed_in(tgt) unless params[:renew] || tgt.nil?
        redirect_to(params[:service], allow_other_host: true) if params[:gateway] && params[:service].present?
      end
      format.xml { head :not_acceptable }
      format.json do
        head :ok
      end
    end
  end

  def create
    validation_result = validate_login_credentials(params[:username], params[:password])
    if !validation_result
      log_failed_login params[:username]
      show_login_error I18n.t('login_credential_acceptor.invalid_login_credentials')
    else
      sign_in(validation_result, long_term: params[:rememberMe], credentials_supplied: true)
    end
  end

  def destroy
    tickets = current_user.ticket_granting_tickets.where(id: params[:id])
    tickets.first.destroy if tickets.any?
    redirect_to sessions_path
  end

  def destroy_others
    current_user
      .ticket_granting_tickets
      .where('id != ?', current_ticket_granting_ticket.id)
      .destroy_all if signed_in?
    if params[:service].present?
      redirect_to params[:service], allow_other_host: true
    else
      redirect_to sessions_path
    end
  end

  def logout
    sign_out
    @url = params[:url]
    if params[:service].present? && service_allowed?(params[:service])
      redirect_to params[:service], status: :see_other, allow_other_host: true
    end
  end

  def validate_otp
    validation_result = validate_one_time_password(params[:otp], @ticket_granting_ticket.user.active_two_factor_authenticator)
    return flash.now[:error] = I18n.t('validate_otp.invalid_otp') unless validation_result.success?
    @ticket_granting_ticket.update_attribute(:awaiting_two_factor_authentication, false)
    set_tgt_cookie(@ticket_granting_ticket)
    handle_signed_in(@ticket_granting_ticket)
  end

  private

  def show_login_error(message)
    flash.now[:error] = message
    render :new, status: :forbidden
  end

  def validate_login_ticket
    unless Casino::LoginTicket.consume(params[:lt])
      show_login_error I18n.t('login_credential_acceptor.invalid_login_ticket')
    end
  end

  def ensure_service_allowed
    if params[:service].present? && !service_allowed?(params[:service])
      render 'service_not_allowed', status: :forbidden
    end
  end

  def load_ticket_granting_ticket_from_parameter
    @ticket_granting_ticket = find_valid_ticket_granting_ticket(params[:tgt], request.user_agent, ignore_two_factor: true)
    redirect_to login_path if @ticket_granting_ticket.nil?
  end
end
