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
    @tooltip =  "<b>Area:</b> " + get_area.to_s + "km2<br><b>Country:</b> " + get_country.to_s + "<br><b>Type:</b> " + get_type.to_s
  end
  
  
  def get_area
    if area_km2.nil?
      @area = "-"
    end
    @area = area_km2.to_s
  end
  
  
  def get_country
    if country.nil?
      @country = "-"
    end
    @country = country
  end
  
  
  def get_type
    if freshwater_type.nil?
      @type = "-"
    end
    @type = freshwater_type.to_s
  end
  
  
  def get_geojson
    
    @geojson = {
			"type": "Feature",
			"geometry": {
				"type": "Point",
				"coordinates": [longitude,latitude]
    			},
    			"properties": {
						"title": name,
            "description": get_tooltip,
      				"marker-color": "#fc4353",
      				"marker-size": "large",
            "marker-symbol": get_marker
			}
		}
    
  end
  
end
