class FreshwatersController < ApplicationController

  def index
 
    @geojson_data = Array.new
		
    @freshwaters = Freshwater.where("freshwater_type = ?","River").limit(200)
    @freshwaters += Freshwater.where("id < ?",200)
		
		@freshwaters.each do |freshwater|
			
      @geojson_data << freshwater.get_mapbox_point_geojson("small")
			
		end

		gon.geo_data = @geojson_data
    gon.longitude = 41.85
    gon.latitude = 50.36
    gon.zoom_level = 6
    
  end
  
  
  def show
    
    @freshwater = Freshwater.find(request.original_url.split('/')[4])
    
    @geojson_data = Array.new
    
    @freshwaters = Freshwater.where("freshwater_type = ?","River").limit(200)
    @freshwaters += Freshwater.where("id < ?",200)
		
		@freshwaters.each do |freshwater|
			
      if freshwater.id == @freshwater.id
        @geojson_data << freshwater.get_mapbox_point_geojson("large")
      else
        @geojson_data << freshwater.get_mapbox_point_geojson("small")
      end
		end
  
    gon.geo_data = @geojson_data
    gon.longitude = @freshwater.longitude
    gon.latitude = @freshwater.latitude
    gon.zoom_level = @freshwater.get_zoom_level
    
  end

end