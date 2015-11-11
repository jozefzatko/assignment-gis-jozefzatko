class FreshwaterEcoregionsController < ApplicationController

  def index
    @freshwater_ecoregions = FreshwaterEcoregion.all
		
    @geojson_data = Array.new
    
		@freshwater_ecoregions.each do |ecoregion|
      @geojson_data << ecoregion.get_mapbox_point_geojson("small")
		end

		gon.geo_data = @geojson_data
    gon.longitude = 10.00
    gon.latitude = 10.00
    gon.zoom_level = 2
  end
  
  def show
    @freshwater_ecoregion = FreshwaterEcoregion.find(params[:id])
  end

end