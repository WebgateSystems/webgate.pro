module Admin
  class UsersController < Admin::HomeController
    before_action :set_user, only: %i[show edit update destroy]

    def index
      @users = User.all
    end

    def show; end

    def new
      @user = User.new
    end

    def edit; end

    def create
      @user = User.new(user_params)
      respond_to do |format|
        if @user.save
          format.html { redirect_to admin_user_path(@user), notice: "#{t(:user)} #{t(:was_successfully_created)}." }
        else
          format.html { render action: 'new' }
        end
      end
    end

    def update
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to admin_user_path(@user), notice: "#{t(:user)} #{t(:was_successfully_updated)}." }
        else
          format.html { render action: 'edit' }
        end
      end
    end

    def destroy
      @user.destroy
      respond_to do |format|
        format.html { redirect_to admin_users_url, notice: "#{t(:user)} #{t(:was_successfully_destroyed)}." }
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end
end
