class CreateFreshwaters < ActiveRecord::Migration
  def change
    create_table :freshwaters do |t|

      t.integer   "feow_id"
      t.text      "name",                 limit: 50
      t.float     "area_km2"
      t.float     "perimeter_km"
      t.float     "longitude"
      t.float     "latitude"
      t.float     "elevation"
      t.text      "country",              limit: 50
      t.text      "secondary_countries",  limit: 200
      t.text      "river",                limit: 50
      t.text      "near_city",            limit: 50
            
      t.geometry "coordinates",           limit: {:srid=>4326, :type=>"geometry"}
      t.text     "json_coordinates"
      
      t.timestamps null: false
    end
    
    add_index "freshwaters", ["coordinates"], name: "index_freshwaters_on_coordinates", using: :gist
    
  end
end
