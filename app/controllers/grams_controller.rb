class GramsController < ApplicationController
  # before_action :authenticate_user!, only: [:new, :create]

  def index
    @grams = Gram.all
  end

  def new
    @gram = Gram.new
  end

  def create
    @gram = Gram.create(gram_params)
    if @gram.valid?
      redirect_to root_path
    else
      render plain: 'unprocessable entity', status: :unprocessable_entity
    end
  end

  private

  def gram_params
    params.require(:gram).permit(:caption)
  end

end
