class FreshwaterEcoregion < ActiveRecord::Base

  def get_tooltip
    @tooltip  =  "<b>Realm:</b> "                  + realm                                    + "<br>"
    @tooltip +=  "<b>Major habitat type:</b> "     + major_habitat_type                       + "<br>"
    @tooltip +=  "<b>Area:</b> "                   + area_km2.to_s            + " km2"        + "<br>"
    
    # todo: make this dynamic
    @tooltip += "<a href=\"http://localhost:3000/freshwater_ecoregions/" + id.to_s + "\">More info</a>"
  end
  
  
  def get_mapbox_point_geojson(size)
    
    @geojson = {
			"type": "Feature",
			"geometry": {
				"type": "Point",
				"coordinates": longlat
    			},
    			"properties": {
						"title":          "<h2>" + name.to_s + "</h2>",
            "description":    get_tooltip,
      			"marker-color":   "#fc4353",
            "marker-size":    size,
            "marker-symbol":  "wetland"
			}
		}
  end

  
  def longlat
    
    geometry = JSON.parse(json_coordinates)
    
    if geometry["type"].to_s == "MultiPolygon"
      point = geometry["coordinates"][0][0][0]
    end
    
    if geometry["type"].to_s == "Polygon"
      point = geometry["coordinates"][0][0]
    end
    
    @longlat = point.split(",")[0]
  end
  
end
