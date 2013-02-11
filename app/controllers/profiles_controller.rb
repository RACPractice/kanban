class ProfilesController < ApplicationController

	before_filter :authenticate_user!

  def show
    @user = current_user
  end

  def update
    @user = current_user
    @user.update_attributes params[:user]
    if @user.errors.empty?
      flash[:notice] = "Your profile was successfully updated"
      redirect_to root_path
    else
      render action: 'show'
    end
  end
end
