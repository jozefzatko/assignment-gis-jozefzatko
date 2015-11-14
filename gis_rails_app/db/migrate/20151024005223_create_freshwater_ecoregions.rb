class CreateFreshwaterEcoregions < ActiveRecord::Migration
  def change
    create_table :freshwater_ecoregions do |t|

      t.integer   "feow_id"
      t.text      "name",                 limit: 50
      t.integer   "continent_id"
      t.text      "realm",                limit: 50
      t.text      "major_habitat_type",   limit: 50
      t.float     "area_km2"
      t.text      "web_page",             limit: 100
      
      t.geometry "coordinates",           limit: {:srid=>4326, :type=>"geometry"}
      t.text     "json_coordinates"
           
      t.timestamps null: false
    end
    
    add_index "freshwater_ecoregions", ["coordinates"], name: "index_freshwater_ecoregions_on_coordinates", using: :gist
    
  end
end
