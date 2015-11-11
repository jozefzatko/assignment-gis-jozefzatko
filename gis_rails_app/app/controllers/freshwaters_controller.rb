class FreshwatersController < ApplicationController

  def index
 	
    @freshwaters = Freshwater.where("id <= ?",250)
		
    @geojson_data = Array.new
    
		@freshwaters.each do |freshwater|
      @geojson_data << freshwater.get_mapbox_point_geojson("small")
		end

		gon.geo_data = @geojson_data
    gon.longitude = 35.00
    gon.latitude = 45.00
    gon.zoom_level = 4
   
  end
  
  
  def show
    
    #todo: make this dynamic
    @freshwater = Freshwater.find(request.original_url.split('/')[4]) 
    
    @freshwaters = Freshwater.where("id <= ?",200)
		
    @geojson_data = Array.new
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
