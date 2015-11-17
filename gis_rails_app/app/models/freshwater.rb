class Freshwater < ActiveRecord::Base
  
  belongs_to :freshwater_ecoregion
  
  
  def get_marker
    if freshwater_type == "Lake"  
      @marker = "water"
    elsif freshwater_type == "Reservoir"
      @marker = "dam"
    elsif freshwater_type == "River"
      @marker = "ferry"
    else
      @marker = "marker"
    end
  end
    
  
  def get_tooltip
    @tooltip =  "<b>Type:</b> "             + get_type.to_s                             + "<br>"
    @tooltip += "<b>Country:</b> "          + get_country.to_s          + ""            + "<br>"
    @tooltip += "<b>Ecoregion:</b> "        + "<a href=\"http://localhost:3000/freshwater_ecoregions/" + freshwater_ecoregion_id.to_s + "\">" + get_freshwater_ecoregion_name +  "</a>"         + "<br>"
    @tooltip += "<b>Area:</b> "             + get_area.to_s             + " km2"        +" <br>"
    @tooltip += "<b>River:</b> "            + get_river.to_s                            + "<br>"          if freshwater_type == "Reservoir"
    @tooltip += "<b>Perimeter:</b> "        + get_perimeter.to_s        + " km"         + "<br>"
    @tooltip += "<b>Elevation:</b> "        + get_elevation.to_s        + " m"          + "<br>"
    @tooltip += "<b>Near city:</b> "        + get_near_city.to_s                        + "<br>"          if get_near_city.to_s != "-"
    @tooltip += "<b>Other countries:</b> "  + get_countries.to_s                        + "<br>"          if get_countries.to_s != "-" 
    @tooltip += "<b>GPS:</b> "              + get_gps.to_s                              + "<br>"
    
    # todo: make this dynamic
    @tooltip += "<a href=\"http://localhost:3000/freshwaters/" + id.to_s + "\">Target this " + get_type.to_s.downcase +  "</a>"
  end
  
  
  def get_name
    if name.nil?
      @name = "--Unknown--"
    else
      @name = name
    end
  end
  
  
  def get_short_name
    if get_name.length >= 30 
      @name = get_name[0..28] + "..."
    else
      @name = get_name
    end
  end
  
  
  def get_type
    if freshwater_type.nil?
      @type = "-"
    else
      @type = freshwater_type.to_s
    end
  end
  
  
  def get_country
    if country.nil?
      @country = "-"
    elsif country == "United States of America"
      @country = "USA"
    else
      @country = country.to_s
    end
  end
  
  
  def get_area
    if area_km2.nil?
      record = ActiveRecord::Base.connection.execute("SELECT ST_Area(ST_Transform(coordinates, utmzone(ST_Centroid(coordinates)))) FROM freshwaters where id = " + id.to_s + ";")
      counted_area_m2 = record[0].to_s.split("\"")[3].to_f
      counted_area_km2 = counted_area_m2 / 1000000
      @area = counted_area_km2.round(1).to_s
    else
      @area = area_km2.to_s
    end
  end
  
  
  def get_perimeter
    if perimeter_km.nil?
      @perimeter = "-"
    else
      @perimeter = perimeter_km.to_s
    end
  end
  
  
  def get_elevation
    if elevation.nil?
      @elevation = "-"
    else
      @elevation = elevation.to_s
    end
  end
  
  
  def get_countries
    if secondary_countries.nil?
      @countries = "-"
    else
      @countries = secondary_countries.to_s.split(": ")[1]
    end
  end
  
  
  def get_river
    if river.nil?
      @river = "-"
    else
      @river = river.to_s
    end
  end
  
  
  def get_near_city
    if near_city.nil?
      @city = "-"
    else
      @city = near_city.to_s
    end
  end
  
  
  def get_zoom_level
    if freshwater_type != "River"
      @zoom_level = 14 - get_area.to_s.length
    else
      @zoom_level = 13 - get_area.to_s.length
    end
  end
  
  
  def get_gps
    if longitude.nil? && latitude.nil?
      @gps = "-"
    else
      @gps = "[" + longitude.to_s + ", " + latitude.to_s + "]"
    end
  end
  
  
  def get_freshwater_ecoregion_name
    if freshwater_ecoregion.nil?
      @name = "-"
    else
      freshwater_ecoregion.name.to_s
    end
  end
  

  def get_mapbox_point_geojson(size)
    @geojson = {
			"type": "Feature",
			"geometry": {
        "type": "Point",
				"coordinates": [longitude,latitude]
      },
      "properties": {
        "title":          "<h2>" + get_name.to_s + "</h2>",
        "description":    get_tooltip,
        "marker-color":   "#fc4353",
        "marker-size":    size,
        "marker-symbol":  get_marker
        }
		}
  end
  
  
  def get_coordinates
    geometry = JSON.parse(json_coordinates)
    
    @geojson = {
      "type": "Feature",
      "properties": {
        "fillColor": "#ffffff",
        "fillOpacity": 0.0
      },
      "geometry": {
        "type": "Polygon",
        "coordinates": geometry["coordinates"],
      }
    }
  end
  
end
