class Api::V1::CommentsController < Api::V1::BaseController
  def create
    comment = current_user.comments.build(params_comment)
    if comment.save
      result = {
        user: serializer(current_user, UserSerializer),
        comment: serializer(comment, CommentSerializer)
      }
      render json: success_message('Comment created!', result)
    else
      render json: errors(comment.errors.full_messages)
    end
  end

  def destroy
    comment = Comment.find_by(id: params[:id])
    if comment&.destroy
      render json: success_message('Comment deleted success!')
    else
      render json: error_message('Delete comment error!')
    end
  end

  private

  def params_comment
    { content: params[:content], micropost_id: params[:micropost_id] }
  end
end