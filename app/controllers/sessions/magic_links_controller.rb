class Sessions::MagicLinksController < ApplicationController
  disallow_account_scope
  require_unauthenticated_access
  rate_limit to: 10, within: 15.minutes, only: :create, with: -> { redirect_to session_magic_link_path, alert: "Wait 15 minutes, then try again" }

  layout "public"

  def show
  end

  def create
    if magic_link = MagicLink.consume(code)
      authenticate_with magic_link
    else
      redirect_to session_magic_link_path, flash: { shake: true }
    end
  end

  private
    def authenticate_with(magic_link)
      if magic_link.identity.email_address == session[:pending_auth_email]
        session.delete(:pending_auth_email)
        start_new_session_for magic_link.identity
        redirect_to after_sign_in_url(magic_link)
      else
        redirect_to new_session_path, alert: "Authentication failed. Please try again."
      end
    end

    def code
      params.expect(:code)
    end

    def after_sign_in_url(magic_link)
      if magic_link.for_sign_up?
        new_signup_completion_path
      else
        after_authentication_url
      end
    end
end
