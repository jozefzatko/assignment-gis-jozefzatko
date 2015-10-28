class FreshwatersController < ApplicationController

  def index
    @freshwaters = Freshwater.all
  end
  
  def show
    @freshwater = Freshwater.find(params[:id])
  end

end