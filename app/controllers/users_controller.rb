class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
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
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
  (current_user.role_id === 2) ? pending : approved
  if @user.update(user_params)
        @user.save
        flash[:notice] = 'You have successfully update the user'
      else
        render :edit
      end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role_id, :status)
end

def set_user
    @user = User.find(params[:id])
end

  def approved
    @user = User.find(params[:id])
    @user.update_attribute(:status, true)
    redirect_to users_path
  end

  def require_admin
    return if current_user.role_id === 1
    flash[:alert] = 'Access denied'
    redirect_to root_path
  end

end
