# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
########################################################################################################


include ActiveModel::Serializers::JSON
require 'json'

puts "Making data seed. It may takes a few  seconds. Please wait."

connection = ActiveRecord::Base.connection()

countries_file = "/home/jozef/rails_projects/assignment-gis-jozefzatko/data/countries.json"


### Countries ##########################################################################################

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

########################################################################################################