class GramsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  rescue_from ActiveRecord::RecordNotFound, with: :render_404_not_found

  def index
    @grams = Gram.all
  end

  def new
    @gram = Gram.new
  end

  def create
    @gram = current_user.grams.create(gram_params)
    if @gram.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @gram = Gram.find(params[:id])
  end

  private

  def gram_params
    params.require(:gram).permit(:caption)
  end

  def render_404_not_found
    render file: 'public/404.html', status: :not_found
  end

end
