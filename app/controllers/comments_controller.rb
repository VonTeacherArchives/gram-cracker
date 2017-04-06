class CommentsController < ApplicationController

  def new
    @comment = Comment.new
  end

  def create
    return redirect_to new_user_session_path if current_user.nil?
    @gram = Gram.find_by_id(params[:gram_id])
    return render plain: '404 Not Found', status: :not_found if @gram.nil?
    @gram.comments.create(comment_params.merge(user: current_user))
    redirect_to root_path
  end

  private

  def comment_params
    params.require(:comment).permit(:message)
  end

end
