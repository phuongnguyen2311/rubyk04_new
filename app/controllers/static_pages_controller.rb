class StaticPagesController < ApplicationController
  def home
    @micropost = current_user.microposts.build
    @all_posts = Micropost.includes(:user, :comments).newest.paginate(page: params[:page], per_page: 10)
  end

  def help
  end
end
