class FreshwatersController < ApplicationController

  @@freshwaters = Array.new

  def index
 	 
    if params[:expression].to_s.strip == "" and params[:area_from].to_s == "" and params[:area_to].to_s == "" and (params[:country].to_s == "" or params[:country].to_s == "[\"\"]") and (params[:ecoregion].to_s == "" or params[:ecoregion].to_s == "[\"\"]")
      @@freshwaters = Freshwater.where("id <= ?",250)
    else
      @@freshwaters = Freshwater.where("name ilike ?", "%" + params[:expression].to_s + "%")
      @@freshwaters = @@freshwaters.where("area_km2 >= #{params[:area_from]}") unless params[:area_from].to_s == ""
      @@freshwaters = @@freshwaters.where("area_km2 <= #{params[:area_to]}") unless params[:area_to].to_s == ""
      @@freshwaters = @@freshwaters.where("country = ?", params[:country].to_s.gsub!(/[^0-9A-Za-z\ ]/, '')) unless params[:country].to_s == "[\"\"]"
      @@freshwaters = @@freshwaters.where("freshwater_ecoregion_id = ?", params[:ecoregion])
  
      @lakes = @@freshwaters.where("freshwater_type = ?", "Lake")
      @reservoirs = @@freshwaters.where("freshwater_type = ?", "Reservoir")
      @rivers = @@freshwaters.where("freshwater_type = ?", "River")
   
      @@freshwaters = Array.new

      if params[:lakes]
        @@freshwaters += @lakes
      end

      if params[:rivers]
        @@freshwaters += @rivers
      end

      if params[:reservoirs]
        @@freshwaters += @reservoirs
      end
    end

    @freshwaters = Array.new
    @geojson_data = Array.new
    
    @freshwaters = @@freshwaters
    
		@@freshwaters.each do |freshwater|
      @geojson_data << freshwater.get_mapbox_point_geojson("small")
		end

		gon.geo_data = @geojson_data
    gon.longitude = 0.0
    gon.latitude = 0.0
    gon.zoom_level = 2
   
  end
  
  
  def show
    
    #todo: make this dynamic
    @freshwater = Freshwater.find(request.original_url.split('/')[4]) 
    
    @freshwaters = Array.new
    @geojson_data = Array.new
		
    @freshwaters = @@freshwaters

    puts @freshwaters.size
    
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
    gon.coordinates = @freshwater.get_coordinates
    
  end

end
