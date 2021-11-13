class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin, except: [:my_portfolio]
  def my_portfolio
    @tracked_stocks = current_user.stocks
  end
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
        flash[:notice] = "Account have successfully created"
        redirect_to users_path
    else
        render "new"
    end
  end

  def show
    @user = User.find(params[:id])
    @tracked_stocks = @user.stocks
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    if @user.update(user_params)
        @user.save
        flash[:notice] = 'You have successfully update the user'
        redirect_to users_path
      else
        render :edit
    end
  end

 def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = 'You have Successfully remove the pending trader'

    else
      flash.now[:alert] = 'There is something wrong please try again.'
    end
  end

  def pending_users
  
  end

  def edit_pending_users
    @users = current_user
  end

  def update_pending_users
    (current_user.role_id === 2) ? pending : approved
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role_id, :status)
  end

  def approved
    @user = User.find(params[:id])
    @user.update_attribute(:status, true)
    ApprovedMailer.with(email: @user.email).trader_approved.deliver_now
    redirect_to pending_user_path
  end

  def require_admin
    return if current_user.role_id === 1
    flash[:alert] = 'Access denied'
    redirect_to root_path
  end

end
