# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user
  add_flash_types :success, :error, :warning
  # Protect for SCRF Attacks
  protect_from_forgery with: :exception

  # login functionality is to prevent from many logins to the same user session and she protect that by called a function in the user model that
  # reset the current_session_token
  def login_user!(user)
    # force other clients to log out by regenerating a new session token
    user.reset_session_token!
    # log in this client
    @current_user = user
    session[:session_token] = user.session_token
  end

  def already_logged_in?
    if login_in!
      flash[:error] = 'You already login In'
      redirect_to cats_path
    end
  end

  # destroy methdod for loging out
  def logout!
    # this reset_session_token is for login out for all the sessions
    # current_user.try(:reset_session_token!)
    session[:session_token] = nil
  end

  # fetches the user who login in
  def current_user
    return nil if session[:session_token].nil?

    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  # check if the current_user owns a cat
  def owns_cat?
    redirect_to cats_url, warning: 'You are not the owner' if current_user.cats.find_by(id: params[:id]).nil?
  end

  # check if the user is login in
  def login_in!
    !current_user.nil?
  end
end
