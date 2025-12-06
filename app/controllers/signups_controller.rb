class SignupsController < ApplicationController
  disallow_account_scope
  allow_unauthenticated_access
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_signup_path, alert: "Try again later." }
  before_action :redirect_authenticated_user

  layout "public"

  def new
    @signup = Signup.new
  end

  def create
    magic_link = Signup.new(signup_params).create_identity
    serve_development_magic_link(magic_link)
    redirect_to session_magic_link_path
  end

  private
    def redirect_authenticated_user
      redirect_to new_signup_completion_path if authenticated?
    end

    def signup_params
      params.expect signup: :email_address
    end
end
