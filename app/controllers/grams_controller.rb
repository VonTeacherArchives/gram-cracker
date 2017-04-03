class GramsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :render_404_not_found

  # 403 forbidden
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
    return render_403_forbidden unless @gram.user == current_user
  end

  def update
    @gram = Gram.find(params[:id])
    return render_403_forbidden unless @gram.user == current_user
    @gram.update_attributes(gram_params)
    # Guard clause
    return render :edit, status: :unprocessable_entity unless @gram.valid?
    redirect_to root_path
  end

  def destroy
    @gram = Gram.find_by_id(params[:id])
    return render_404_not_found if @gram.blank?
    return render_403_forbidden unless @gram.user == current_user
    @gram.destroy
    redirect_to root_path
  end

  private

  def gram_params
    params.require(:gram).permit(:caption)
  end

  def render_404_not_found
    render file: 'public/404.html', status: :not_found
  end

  def render_403_forbidden
    render file: 'public/403.html', status: :forbidden
  end

end
