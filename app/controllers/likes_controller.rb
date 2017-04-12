class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    gram = Gram.find(params[:gram_id])
    current_user.likes.create(gram: gram)
    respond_to do |format|
      format.json do
        render json: gram
      # format.html { redirect_to root_path }
      # format.js
      end
    end
  end

end
