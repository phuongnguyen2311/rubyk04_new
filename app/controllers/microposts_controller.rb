class MicropostsController < ApplicationController
  before_action :loggin?
  before_action :check_valid_micropost?, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    byebug
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @all_posts = Micropost.includes(:user).paginate(page: params[:page], per_page: 10)
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = "Micropost deleted"
    else
      flash[:danger] = "Deleted fail"
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def check_valid_micropost?
    @micropost = Micropost.find(params[:id])
    user = @micropost.user
    return if correct_user?(user)
    flash[:danger] = "You can't delete this post"
    return redirect_to root_url
  end
end
