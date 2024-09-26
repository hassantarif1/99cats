# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :already_logged_in?, only: %i[new create]
  # before action for the user to not see the users#show before log in
  def index
    @users = User.all
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login_user!(@user)
      msg = UsermailerMailer.welcome_email(@user)
      msg.deliver
      redirect_to cats_url
    else
      email_confirmation = UsermailerMailer.wrong_password(@user)
      email_confirmation.deliver
      redirect_to :new_session, success: 'User already Exist'
    end
  end

  def new
    @user = User.new # for some user who are just creating an account
    render :new
  end

  def show
    if current_user.nil?
      redirect_to new_user_path
      return
    end
    @user = current_user
    render :show
  end

  def last_logins
    req = Rack::Request.new(request.ip)
    render plain: req.ip
  end

  private

  def user_params
    params.require(:users).permit(:email, :password)
  end
end
