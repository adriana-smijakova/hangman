class UsersController < ApplicationController

  before_action :set_user, only: [:edit, :update, :show]
  def new
    @user = User.new
  end
  
  def show
    redirect_to root_path
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_url, :notice => "Signed up!"
    else
      render "new"
    end
  end
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
  
  # GET /users/1/edit
  def edit
    authorize! :update, @user
  end
  
  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    authorize! :update, @user
  	respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
	rescue ActiveRecord::RecordNotFound
      redirect_to root_url, :flash => { :error => "Record not found." }
  end
  
  def catch_not_found
    yield
    rescue ActiveRecord::RecordNotFound
    redirect_to root_url, :flash => { :error => "Record not found." }
  end
  
end
