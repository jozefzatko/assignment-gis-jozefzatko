class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|

      t.text     "iso_code",          limit: 5
      t.text     "name",              limit: 50
      t.text     "formal_name",       limit: 50
      t.text     "sovereignt",        limit: 50
      t.text     "continent",         limit: 30
      t.text     "region",            limit: 50
      t.integer  "population",        limit: 2000000000
      t.geometry "coordinates",       limit: {:srid=>4326, :type=>"geometry"}
      t.text     "json_coordinates"
      
      t.timestamps null: false
    end
    
    add_index "countries", ["coordinates"], name: "index_countries_on_coordinates", using: :gist
    
  end
end
