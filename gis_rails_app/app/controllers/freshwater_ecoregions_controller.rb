class FreshwaterEcoregionsController < ApplicationController

  def index
    @freshwater_ecoregions = Freshwater.all
  end
  
  def show
    @freshwater_ecoregion = FreshwaterEcoregion.find(params[:id])
  end

end