class GramsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  # 404 not_found
  # 422 unprocessable_entity

  def index
    @grams = Gram.all
  end

  def new
    @gram = Gram.new
  end

  def create
    @gram = current_user.grams.create(gram_params)
    # Guard clause
    return render :new, status: :unprocessable_entity unless @gram.valid?
    redirect_to root_path
  end

  def show
    @gram = Gram.find(params[:id])
  end

  def edit
    @gram = Gram.find(params[:id])
  end

  def update
    @gram = Gram.find(params[:id])
    @gram.update_attributes(gram_params)
    # Guard clause
    return render :edit, status: :unprocessable_entity unless @gram.valid?
    redirect_to root_path
  end

  def destroy
    @gram = Gram.find_by_id(params[:id])
    return render_404 if @gram.blank?
    @gram.destroy
    redirect_to root_path
  end

  private

  def gram_params
    params.require(:gram).permit(:caption)
  end

  def render_404
    render file: 'public/404.html', status: :not_found
  end

end
