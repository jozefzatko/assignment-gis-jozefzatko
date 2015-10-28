# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
########################################################################################################


include ActiveModel::Serializers::JSON
require 'json'

puts "Making data seed. It may takes a few minutes. Please wait..."

connection = ActiveRecord::Base.connection()

##############################################################################################################

countries_file 				= "/home/jozef/rails_projects/assignment-gis-jozefzatko/data/countries.json"
feow_hydrosheds_file 	= "/home/jozef/rails_projects/assignment-gis-jozefzatko/data/feow_hydrosheds.json"
freshwater_ecoregions = "/home/jozef/rails_projects/assignment-gis-jozefzatko/data/freshwater_ecoregions.txt"
freshwater_file_1 		= "/home/jozef/rails_projects/assignment-gis-jozefzatko/data/glwd_1.json"
freshwater_file_2 		= "/home/jozef/rails_projects/assignment-gis-jozefzatko/data/glwd_2.json"
freshwater_file_3 		= "/home/jozef/rails_projects/assignment-gis-jozefzatko/data/glwd_3.json"

### Countries ################################################################################################

data_hash = JSON.parse(File.read(countries_file))

data_hash['features'].each do |country|
	
	Country.create(
		
		iso_code: 		country["properties"]["iso_a3"],
		name: 				country["properties"]["admin"],
		formal_name:	country["properties"]["formal_en"],
		sovereignt: 	country["properties"]["sovereignt"],
		continent:	 	country["properties"]["continent"],
		region:				country["properties"]["subregion"],
		population:		country["properties"]["pop_est"].to_int,
		
		json_coordinates:	country["geometry"].to_s
	)

end

connection.execute(" UPDATE countries SET json_coordinates = replace(json_coordinates, '=>', ':'); ")
connection.execute(" UPDATE countries SET coordinates=ST_SetSRID(st_geomfromgeojson(json_coordinates),4326); ")

### Freshwater Ecoregions ####################################################################################

ecoregions_data = Array.new
i = 0

File.readlines(freshwater_ecoregions).each do |line|
	
	ecoregions_data[i] = line
	i += 1
end


data_hash = JSON.parse(File.read(feow_hydrosheds_file))
i = 0

data_hash['features'].each do |ecoregion|
		
	FreshwaterEcoregion.create(
		
		feow_id:							ecoregion["properties"]["FEOW_ID"],
    realm:								ecoregions_data[i+1].to_s,
    major_habitat_type:		ecoregions_data[i+2].to_s,
		name:									ecoregions_data[i+3].to_s,
		area_km2:						  ecoregion["properties"]["AREA_SKM"],
		web_page:						  "http://www.feow.org/ecoregions/details/" + ecoregion["properties"]["FEOW_ID"].to_s,
		
		json_coordinates:		ecoregion["geometry"].to_s
	)
	
	i += 5
	
end

connection.execute(" UPDATE freshwater_ecoregions SET json_coordinates = replace(json_coordinates, '=>', ':'); ")
connection.execute(" UPDATE freshwater_ecoregions SET coordinates=ST_SetSRID(st_geomfromgeojson(json_coordinates),4326); ")

### Freshwater no. 1 #########################################################################################

puts "Still seeding..."

data_hash = JSON.parse(File.read(freshwater_file_1))

data_hash['features'].each do |freshwtr|

	Freshwater.create(
		
		feow_id: 							freshwtr["properties"]["FEOW_ID"],
		name: 								freshwtr["properties"]["LAKE_NAME"],
		freshwater_type:			freshwtr["properties"]["TYPE"],
		area_km2:							freshwtr["properties"]["AREA_SKM"],
		perimeter_km:					freshwtr["properties"]["PERIM_KM"],
		longitude:						freshwtr["properties"]["LONG_DEG"],
		latitude:							freshwtr["properties"]["LAT_DEG"],
		elevation:						freshwtr["properties"]["ELEV_M"],
		country:							freshwtr["properties"]["COUNTRY"],
		secondary_countries:	freshwtr["properties"]["SEC_CNTRY"],
		river:								freshwtr["properties"]["RIVER"],
		near_city:						freshwtr["properties"]["NEAR_CITY"],
		
		json_coordinates:			freshwtr["geometry"].to_s
		
		) unless freshwtr["geometry"].nil?
	
end

### Freshwater no. 2 #########################################################################################

data_hash = JSON.parse(File.read(freshwater_file_2))

data_hash['features'].each do |freshwtr|

	Freshwater.create(
		
		feow_id: 							freshwtr["properties"]["FEOW_ID"],
		name: 								freshwtr["properties"]["LAKE_NAME"],
		freshwater_type:			freshwtr["properties"]["TYPE"],
		area_km2:							freshwtr["properties"]["AREA_SKM"],
		perimeter_km:					freshwtr["properties"]["PERIM_KM"],
		longitude:						freshwtr["properties"]["LONG_DEG"],
		latitude:							freshwtr["properties"]["LAT_DEG"],
		elevation:						freshwtr["properties"]["ELEV_M"],
		country:							freshwtr["properties"]["COUNTRY"],
		secondary_countries:	freshwtr["properties"]["SEC_CNTRY"],
		river:								freshwtr["properties"]["RIVER"],
		near_city:						freshwtr["properties"]["NEAR_CITY"],
		
		json_coordinates:			freshwtr["geometry"].to_s
		
		) unless freshwtr["geometry"].nil?
	
end

### Freshwater no. 3 #########################################################################################

data_hash = JSON.parse(File.read(freshwater_file_3))

data_hash['features'].each do |freshwtr|

	if freshwtr["properties"]["TYPE"] == "Lake" or freshwtr["properties"]["TYPE"] == "Reservoir"
	else
		
		

		Freshwater.create(

				feow_id: 							freshwtr["properties"]["FEOW_ID"],
				name: 								freshwtr["properties"]["LAKE_NAME"],
				freshwater_type:			freshwtr["properties"]["TYPE"],
				area_km2:							freshwtr["properties"]["AREA_SKM"],
				perimeter_km:					freshwtr["properties"]["PERIM_KM"],
				longitude:						freshwtr["properties"]["LONG_DEG"],
				latitude:							freshwtr["properties"]["LAT_DEG"],
				elevation:						freshwtr["properties"]["ELEV_M"],
				country:							freshwtr["properties"]["COUNTRY"],
				secondary_countries:	freshwtr["properties"]["SEC_CNTRY"],
				river:								freshwtr["properties"]["RIVER"],
				near_city:						freshwtr["properties"]["NEAR_CITY"],

				json_coordinates:			freshwtr["geometry"].to_s

				)
	end
end

connection.execute(" UPDATE freshwaters SET json_coordinates = replace(json_coordinates, '=>', ':'); ")
connection.execute(" UPDATE freshwaters SET coordinates=ST_SetSRID(st_geomfromgeojson(json_coordinates),4326); ")

puts "Seeding complete."

##############################################################################################################