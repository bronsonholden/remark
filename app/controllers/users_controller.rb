class UsersController < Clearance::UsersController
  include HasRemarkSearch

  before_action :redirect_signed_in_users, only: [:create, :new]
  skip_before_action :require_login, only: [:create, :new], raise: false

  def new
    @user = User.new
    render template: "users/new", locals: {search_enabled: false}
  end

  def create
    @user = User.new(user_params)

    if @user.save
      sign_in @user
      flash.discard
      redirect_back_or url_after_create
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render template: "users/new", status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params.require(:id))
    remark_search(params.except(:id).merge(user_id: @user.id))
  end

  private

  def redirect_signed_in_users
    if signed_in?
      redirect_to Clearance.configuration.redirect_url
    end
  end

  def url_after_create
    Clearance.configuration.redirect_url
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end
end
