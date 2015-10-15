class StaticPagesController < ApplicationController

	def home

		@geojson_data = Array.new

		@geojson_data << {
			"type": "Feature",
			"geometry": {
				"type": "Point",
      				"coordinates": [17.071799,48.153833,]
    			},
    			"properties": {
      				"title": "FIIT STU",
      				"description": "the only place where magic happens",
      				"marker-color": "#fc4353",
      				"marker-size": "large",
      				"marker-symbol": "college"
			}
		}

		gon.geo_data = @geojson_data
	end

	def about_project
	end

end
