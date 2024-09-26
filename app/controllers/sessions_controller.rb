# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :already_logged_in?, only: %i[new create]
  def create
    # check if the user email is present
    email_checked = User.is_email_valid?(params[:users][:email])

    user = User.find_by_credentials!(
      params[:users][:email],
      params[:users][:password]
    )

    if email_checked.present?
      redirect_to :new_session, alert: "Password is wrong !"
    elsif user.nil?
      redirect_to :new_session, alert: 'User not Found'
    else 
      login_user!(user)
      redirect_to cats_url
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end

  def new
    render :new
  end
end
