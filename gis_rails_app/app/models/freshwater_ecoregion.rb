class FreshwaterEcoregion < ActiveRecord::Base
  
  belongs_to :continent
  has_many :freshwaters
  
  def get_tooltip
    @tooltip  =  "<b>Continent:</b> "              + continent.name                           + "<br>"
    @tooltip +=  "<b>Realm:</b> "                  + realm                                    + "<br>"
    @tooltip +=  "<b>Major habitat type:</b> "     + major_habitat_type                       + "<br>"
    @tooltip +=  "<b>Area:</b> "                   + area_km2.to_s            + " km2"        + "<br>"
    
    # todo: make this dynamic
    @tooltip += "<a href=\"http://localhost:3000/freshwater_ecoregions/" + id.to_s + "\">More info</a>"
    @tooltip += " | "
    @tooltip += "<a href=\"" + web_page.to_s + "\">Oficial web page</a>"
  end
  
  
  def get_coordinates
    geometry = JSON.parse(json_coordinates)
    
    @geojson = {
      "type": "Feature",
      "properties": {
        "title":          "<h2>" + name.to_s + "</h2>",
        "description":    get_tooltip,
        "marker-color":   "#fc4353",
        "marker-size":    "small",
        "marker-symbol":  "wetland"
      },
      "geometry": {
        "type": geometry["type"].to_s,
        "coordinates": geometry["coordinates"],
        }
      }
  end
  
  
  def get_zoom_level
    geometry = JSON.parse(json_coordinates)
    
    if geometry["type"].to_s == "Polygon"
      @zoom_level = 14 - area_km2.to_s.length
    else
      @zoom_level = 14 - area_km2.to_s.length
    end
  end
  
end
