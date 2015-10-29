class Freshwater < ActiveRecord::Base
  
  def get_marker
    if freshwater_type == "Lake"  
      @marker = "water"
      else
      if freshwater_type == "Reservoir"
        @marker = "dam"
      else 
        if freshwater_type == "River"
          @marker = "ferry"
        else
          @marker = "marker"
        end
      end
    end
  end
  
  
  def get_tooltip
    @tooltip = "<b>Type:</b> " + get_type.to_s + "<br>"
    @tooltip += "<b>Country:</b> " + get_country.to_s + "<br>"
    @tooltip +=  "<b>Area:</b> " + get_area.to_s + "km2<br>"
    
    if freshwater_type == "Reservoir"
      @tooltip +=  "<b>River:</b> " + get_river.to_s + "<br>"
    end
    
    
    @tooltip += "<a href=\"http://localhost:3000/freshwaters/" + id.to_s + "\">Show Details</a>"
  end
  
  
  def get_type
    if freshwater_type.nil?
      @type = "-"
    end
    @type = freshwater_type.to_s
  end
  
  
  def get_country
    if country.nil?
      @country = "-"
    end
    @country = country
  end
  
  
  def get_area
    if area_km2.nil?
      @area = "-"
    end
    @area = area_km2.to_s
  end
  
  
  def get_perimeter
    if perimeter_km.nil?
      @perimeter = "-"
    end
    @perimeter = perimeter_km.to_s
  end
  
  
  def get_elevation
    if elevation.nil?
      @elevation = "-"
    end
    @elevation = elevation.to_s
  end
  
  def get_countries
    if secondary_countries.nil?
      @countries = "-"
    end
    @countries = secondary_countries.to_s
  end
  
  
  def get_river
    if river.nil?
      @river = "-"
    end
    @river = river.to_s
  end
  
  
  def get_city
    if near_city.nil?
      @city = "-"
    end
    @city = near_city.to_s
  end
  
  
  def get_zoom_level
    @zoom_level = 14 - get_area.to_s.length
  end
  

  def get_geojson
    
    @geojson = {
			"type": "Feature",
			"geometry": {
				"type": "Point",
				"coordinates": [longitude,latitude]
    			},
    			"properties": {
						"title": "<big>" + name.to_s + "</big>",
            "description": get_tooltip,
      				"marker-color": "#fc4353",
      				"marker-size": "large",
            "marker-symbol": get_marker
			}
		}
    
  end
  
end
