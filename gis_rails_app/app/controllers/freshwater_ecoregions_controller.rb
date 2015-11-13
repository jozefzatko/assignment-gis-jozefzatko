class FreshwaterEcoregionsController < ApplicationController

  def index
    @freshwater_ecoregions = FreshwaterEcoregion.all
		
    @geojson_data = Array.new
    
		@freshwater_ecoregions.each do |ecoregion|
      @geojson_data << ecoregion.get_coordinates
		end

		gon.geo_data = @geojson_data
    gon.longitude = 0.00
    gon.latitude = 10.00
    gon.zoom_level = 2
  end
  
  def show
    @freshwater_ecoregion = FreshwaterEcoregion.find(params[:id])
    @freshwaters = Freshwater.first(10)
    
    @geojson_data = Array.new
    @freshwaters.each do |freshwater|
      @geojson_data << freshwater.get_mapbox_point_geojson("small")
    end
    
    @geojson_data << @freshwater_ecoregion.get_coordinates 
      
    gon.geo_data = @geojson_data
    gon.longitude = @freshwater_ecoregion.longlat[0]
    gon.latitude = @freshwater_ecoregion.longlat[1]
    gon.zoom_level = @freshwater_ecoregion.get_zoom_level
  end

end