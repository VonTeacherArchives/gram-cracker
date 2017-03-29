class GramsController < ApplicationController

  def index
    @grams = Gram.all
  end

  def new
    @gram = Gram.new
  end


end
