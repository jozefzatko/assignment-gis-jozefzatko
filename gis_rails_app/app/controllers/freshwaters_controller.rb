class FreshwatersController < ApplicationController

  def index
 
    @geojson_data = Array.new
		
    @freshwaters = Freshwater.where("freshwater_type = ?","River").limit(200)
    @freshwaters += Freshwater.where("id < ?",200)
		
		@freshwaters.each do |freshwater|
			
      @geojson_data << freshwater.get_geojson
			
		end

		gon.geo_data = @geojson_data
    
  end
  
  
  def show
    
    @freshwater = Freshwater.find(request.original_url.split('/')[4])
    
    @geojson_data = @freshwater.get_geojson
  
    gon.geo_data = @geojson_data
    gon.longitude = @freshwater.longitude
    gon.latitude = @freshwater.latitude
    gon.zoom_level = @freshwater.get_zoom_level
    
  end

end