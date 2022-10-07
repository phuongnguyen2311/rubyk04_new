class Api::V1::UsersController < Api::V1::BaseController
  def index
    users = User.all
    render json: success_message('List successfully', users)
  end
end