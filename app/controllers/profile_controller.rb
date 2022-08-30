class ProfileController < ApplicationController
  include HasRemarkSearch

  before_action :require_login
  before_action :set_user

  def show
    remark_search(params.merge(user_id: @user.id))
  end

  def edit
  end

  def update
    @user.assign_attributes(params.require(:user).permit(:first_name, :last_name, :avatar))
    Users::CreateAvatarDerivativesJob.perform_later(@user) if @user.will_save_change_to_avatar_data?
    if @user.save
      flash.discard
      redirect_to profile_path
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end
end
