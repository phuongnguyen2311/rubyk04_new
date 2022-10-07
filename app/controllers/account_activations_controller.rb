class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated && user.authenticated?(:activation, params[:id])
      user.update(activated: true, activated_at: Time.zone.now)
      log_in user
      flash[:success] = "Account activated!"
      redirect_to users_path
    else
      flash[:danger] = "Invalid activation link"
      redirect_to login_url
    end
  end
end

user -> posts 

users = User.all  -> 1 cau query
users.each do |user|
  posts = user.posts -> 10 cau query
end
=> 11 cau query database => N+1

users = User.all.includes(:posts) 
-> users => List users
-> posts => Post.in()
=> 2 cau query
users = User.all.includes(:posts)
users.each do |user|
  posts = user.posts => ko con query databases 
end
=> performence => query connect -> time -> anh huwong performance