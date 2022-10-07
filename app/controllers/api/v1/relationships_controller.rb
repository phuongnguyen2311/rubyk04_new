class Api::V1::RelationshipsController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token
  def create
    user = User.find_by(id: params[:followed_id])
    return render json: error_message('User not found') unless user
    if current_user.following?(user)
      render json: error_message('User was following')
    else
      current_user.follow(user)
      render json: success_message('Congrat follow user')
    end
  end
  
  def destroy
    user = User.find_by(id: params[:id])
    if current_user.following?(user)
      current_user.unfollow(user)
      render json: success_message('Unfllow user success')
    else
      render json: error_message('User was unfollow')
    end
  end
end