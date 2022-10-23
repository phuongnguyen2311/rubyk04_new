class Api::V1::MicropostsController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token
  before_action :check_valid_micropost?, only: :destroy

  def create
    micropost = current_user.microposts.build micropost_params
    if micropost.save
      result = {
        user: serializer(current_user, UserSerializer),
        micropost: serializer(micropost, MicropostSerializer)
      }
      render json: success_message('Micropost created!', result)
    else
      render json: errors(micropost.errors.full_messages)
    end
  end

  def destroy
    return render json: error_message('Deleted fail') unless @micropost.destroy
    render json: success_message('Micropost deleted')
  end

  private

  def micropost_params
    { content: params[:content], image: params[:image] }
  end

  def check_valid_micropost?
    @micropost = Micropost.find(params[:id])
    user = @micropost.user
    return if correct_user?(user)
    render json: error_message('You can\'t delete this post')
  end
end
