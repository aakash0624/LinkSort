class UsersController < ApplicationController
    before_action :set_user, only: [:show, :update, :destroy]
  
    # GET /users
    def index
      @users = User.all
      respond_to do |format|
        format.html { render :index }
        format.json { render json: @users }
      end
    end
  
    # GET /users/1
    def show
      respond_to do |format|
        format.html 
        format.json { render json: @user }
      end
    end
  
    # POST /users
    def create
      @user = User.new(user_params)
  
      respond_to do |format|
        if @user.save
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render json: @user, status: :created }
        else
          format.html { render :new }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PATCH/PUT /users/1
    def update
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { render json: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /users/1
    def destroy
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
        format.json { render json: { message: 'User successfully deleted' } }
      end
    end
  
    private
  
    
    def set_user
      @user = User.find(params[:id])
    end
  
    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:email, :password)
    end
  end
  