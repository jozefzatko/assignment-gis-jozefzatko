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

### Continents ###############################################################################################

Continent.create(name: "North America")
Continent.create(name: "Central America")
Continent.create(name: "South America")
Continent.create(name: "Europe")
Continent.create(name: "Africa")
Continent.create(name: "Asia")
Continent.create(name: "Australia and Oceania")
Continent.create(name: "Antarctica")

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
count_of_freshwater_ecoregions = 0

data_hash['features'].each do |ecoregion|
		
	id = case ecoregion["properties"]["FEOW_ID"]
	when 101..176
		1
	when 201..217
		2
	when 301..352
		3
	when 401..453
		4
	when 501..587
		5
	when 601..643
		6
	when 701..769
		6
	when 801..830
		7
	end

	FreshwaterEcoregion.create(
		
		feow_id:							ecoregion["properties"]["FEOW_ID"],
		continent_id:					id,
    realm:								ecoregions_data[i+1].to_s,
    major_habitat_type:		ecoregions_data[i+2].to_s,
		name:									ecoregions_data[i+3].to_s,
		area_km2:						  ecoregion["properties"]["AREA_SKM"],
		web_page:						  "http://www.feow.org/ecoregions/details/" + ecoregion["properties"]["FEOW_ID"].to_s,
		
		json_coordinates:		ecoregion["geometry"].to_s
	)
	
	i += 5
	count_of_freshwater_ecoregions += 1
end

connection.execute(" UPDATE freshwater_ecoregions SET json_coordinates = replace(json_coordinates, '=>', ':'); ")
connection.execute(" UPDATE freshwater_ecoregions SET coordinates=ST_SetSRID(st_geomfromgeojson(json_coordinates),4326); ")

for i in 1..count_of_freshwater_ecoregions 
	record = connection.execute(" SELECT ST_AsGeoJSON(ST_PointOnSurface(ST_MakeValid(coordinates))) FROM freshwater_ecoregions where id = " + i.to_s + "; ")
	point = JSON.parse(record[0]["st_asgeojson"])["coordinates"]
	
	longitude = point.split(",")[0][0]
	latitude = point.split(",")[0][1]
	
	connection.execute(" UPDATE freshwater_ecoregions SET longitude= " + longitude.to_s + " where id = " + i.to_s + "; ")
	connection.execute(" UPDATE freshwater_ecoregions SET latitude = " + latitude.to_s  + " where id = " + i.to_s + "; ")
end

### Freshwater no. 1 #########################################################################################

puts "Still seeding..."

data_hash = JSON.parse(File.read(freshwater_file_1))

count_of_freshwaters = 0

data_hash['features'].each do |freshwtr|

	country = freshwtr["properties"]["COUNTRY"]
	record = connection.select_all(" SELECT id FROM countries WHERE name like \'%" + country + "%\';")
	if record.empty?
		country_id = ""
	else
		country_id = record[0].to_s.split("\"")[3]
	end
	
	if freshwtr["geometry"].nil?
		# json_coordinates is nil
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
			country:							country,
			country_id:						country_id,
			secondary_countries:	freshwtr["properties"]["SEC_CNTRY"],
			river:								freshwtr["properties"]["RIVER"],
			near_city:						freshwtr["properties"]["NEAR_CITY"],

			json_coordinates:			freshwtr["geometry"].to_s

			)
		
		count_of_freshwaters += 1
	end
end

### Freshwater no. 2 #########################################################################################

data_hash = JSON.parse(File.read(freshwater_file_2))

data_hash['features'].each do |freshwtr|

	country = freshwtr["properties"]["COUNTRY"]
	
	if country.nil?
		country_id = ""
	else
		record = connection.select_all(" SELECT id FROM countries WHERE name like \'%" + country + "%\';")
		if record.empty?
			country_id = ""
		else
			country_id = record[0].to_s.split("\"")[3]
		end
	end

	if freshwtr["geometry"].nil?
		# json_coordinates is nil
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
			country:							country,
			country_id:						country_id,
			secondary_countries:	freshwtr["properties"]["SEC_CNTRY"],
			river:								freshwtr["properties"]["RIVER"],
			near_city:						freshwtr["properties"]["NEAR_CITY"],

			json_coordinates:			freshwtr["geometry"].to_s

			)
		
		count_of_freshwaters += 1
	end
	
end

### Freshwater no. 3 #########################################################################################

#data_hash = JSON.parse(File.read(freshwater_file_3))

#data_hash['features'].each do |freshwtr|

#	country = freshwtr["properties"]["COUNTRY"]
#	record = connection.execute(" SELECT id FROM countries WHERE name like \'%" + country + "%\';")
#	if record.blank?
#		country_id = ""
#	else
#		country_id = record[0].to_s.split("\"")[3]
#	end

#	if freshwtr["properties"]["TYPE"] == "Lake" or freshwtr["properties"]["TYPE"] == "Reservoir"
		# lakes and reservoirs
#	elsif freshwtr["geometry"].nil?
		# json_coordinates is nil
#	else
		
#		Freshwater.create(

#				feow_id: 							freshwtr["properties"]["FEOW_ID"],
#				name: 								freshwtr["properties"]["LAKE_NAME"],
#				freshwater_type:			freshwtr["properties"]["TYPE"],
#				area_km2:							freshwtr["properties"]["AREA_SKM"],
#				perimeter_km:					freshwtr["properties"]["PERIM_KM"],
#				longitude:						freshwtr["properties"]["LONG_DEG"],
#				latitude:							freshwtr["properties"]["LAT_DEG"],
#				elevation:						freshwtr["properties"]["ELEV_M"],
#				country:							country,
#				country_id:						country_id,
#				secondary_countries:	freshwtr["properties"]["SEC_CNTRY"],
#				river:								freshwtr["properties"]["RIVER"],
#				near_city:						freshwtr["properties"]["NEAR_CITY"],

#				json_coordinates:			freshwtr["geometry"].to_s

#				)
		
#		count_of_freshwaters += 1
#	end
#end

puts "Be patient..."

connection.execute(" UPDATE freshwaters SET json_coordinates = replace(json_coordinates, '=>', ':'); ")
connection.execute(" UPDATE freshwaters SET coordinates=ST_SetSRID(st_geomfromgeojson(json_coordinates),4326); ")

ecoregions_geometry = Array.new

for i in 1..count_of_freshwater_ecoregions
	record = connection.execute(" SELECT coordinates FROM freshwater_ecoregions WHERE id = " + i.to_s + " ;" )
	ecoregions_geometry[i] = record[0].to_s.split("\"")[3]
end

for i in 1..count_of_freshwaters
	record = connection.execute(" SELECT longitude, latitude FROM freshwaters WHERE id = " + i.to_s + ";" )
	longitude = record[0].to_s.split("\"")[3]
	latitude = record[0].to_s.split("\"")[7]

	for j in 1..count_of_freshwater_ecoregions
		record = connection.execute(" SELECT ST_Contains(coordinates, ST_SetSRID(ST_Point(" + longitude + "," + latitude + "),4326)) FROM freshwater_ecoregions WHERE id = "+ j.to_s + ";" )
		if record[0] == {"st_contains"=>"t"}
			connection.execute(" UPDATE freshwaters SET freshwater_ecoregion_id = " + j.to_s + " WHERE id = " + i.to_s + "; ")
		end
	end
end

puts "Seeding complete."

##############################################################################################################