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
    @freshwater = Freshwater.find(params[:id])
  end

end