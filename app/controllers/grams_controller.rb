class GramsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  # rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  # I was using this rescue action until Lesson 15, where I started receiving
  # "undefined method `to_i' for #<ActiveRecord::RecordNotFound0x00"> errors.
  # I tried a number of workarounds in the "render_not_found" method.
  # The fix occurred after adding ".find_by_id" to the instance variable
  # assignments in :show, :edit, :udpate, and :destroy actions.
  # I then went back and instituted conditional page renders based on status.

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
    @gram = Gram.find_by_id(params[:id])
    return render_not_found if @gram.blank?
  end

  def edit
    @gram = Gram.find_by_id(params[:id])
    return render_not_found if @gram.blank?
    return render_not_found(:forbidden) unless @gram.user == current_user
  end

  def update
    @gram = Gram.find_by_id(params[:id])
    return render_not_found if @gram.blank?
    return render_not_found(:forbidden) unless @gram.user == current_user

    @gram.update_attributes(gram_params)
    return render :edit, status: :unprocessable_entity unless @gram.valid?
    redirect_to root_path
  end

  def destroy
    @gram = Gram.find_by_id(params[:id])
    return render_not_found if @gram.blank?
    return render_not_found(:forbidden) unless @gram.user == current_user

    @gram.destroy
    redirect_to root_path
  end

  private

  def gram_params
    params.require(:gram).permit(:caption)
  end

  def render_not_found(status = :not_found)
    if status == :forbidden
      render file: 'public/403.html', status: status
    else
      render file: 'public/404.html', status: status
    end
  end
end
