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
    @tooltip =  "<b>Type:</b> "             + get_type.to_s           + "<br>"
    @tooltip += "<b>Country:</b> "          + get_country.to_s        + "<br>"
    @tooltip += "<b>Area:</b> "             + get_area.to_s           + " km2<br>"
    @tooltip += "<b>River:</b> "            + get_river.to_s          + "<br>"          if freshwater_type == "Reservoir"
    @tooltip += "<b>Perimeter:</b> "        + get_perimeter.to_s      + " km<br>"
    @tooltip += "<b>Elevation:</b> "        + get_elevation.to_s      + " m<br>"
    @tooltip += "<b>Near city:</b> "        + get_near_city.to_s      + "<br>"          if get_near_city.to_s != ""
    @tooltip += "<b>Other countries:</b> "  + get_countries.to_s      + "<br>"          if get_countries.to_s != "" 
    @tooltip += "<b>GPS:</b> "              + get_gps.to_s            + "<br>"  
    @tooltip += "<a href=\"http://localhost:3000/freshwaters/" + id.to_s + "\">Target this " + get_type.to_s.downcase +  "</a>"   
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
    @countries = secondary_countries.to_s.split(": ")[1]
  end
  
  
  def get_river
    if river.nil?
      @river = "-"
    end
    @river = river.to_s
  end
  
  
  def get_near_city
    if near_city.nil?
      @city = "-"
    end
    @city = near_city.to_s
  end
  
  
  def get_zoom_level
    if freshwater_type != "River"
      @zoom_level = 14 - get_area.to_s.length
    else
      @zoom_level = 13 - get_area.to_s.length
    end
  end
  
  
  def get_gps
    @gps = "[" + longitude.to_s + ", " + latitude.to_s + "]"
  end
  

  def get_mapbox_point_geojson(size)
    @geojson = {
			"type": "Feature",
			"geometry": {
				"type": "Point",
				"coordinates": [longitude,latitude]
    			},
    			"properties": {
						"title": "<h2>" + name.to_s + "</h2>",
            "description": get_tooltip,
      			"marker-color": "#fc4353",
            "marker-size": size.to_s,
            "marker-symbol": get_marker
			}
		}
  end
  
end
