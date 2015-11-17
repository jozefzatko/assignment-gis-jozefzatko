# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151113223402) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "continents", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "countries", force: :cascade do |t|
    t.text     "iso_code"
    t.text     "name"
    t.text     "formal_name"
    t.text     "sovereignt"
    t.text     "continent"
    t.text     "region"
    t.integer  "population"
    t.geometry "coordinates",      limit: {:srid=>4326, :type=>"geometry"}
    t.text     "json_coordinates"
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
  end

  add_index "countries", ["coordinates"], name: "index_countries_on_coordinates", using: :gist

  create_table "freshwater_ecoregions", force: :cascade do |t|
    t.integer  "feow_id"
    t.text     "name"
    t.integer  "continent_id"
    t.text     "realm"
    t.text     "major_habitat_type"
    t.float    "longitude"
    t.float    "latitude"
    t.float    "area_km2"
    t.text     "web_page"
    t.geometry "coordinates",        limit: {:srid=>4326, :type=>"geometry"}
    t.text     "json_coordinates"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
  end

  add_index "freshwater_ecoregions", ["coordinates"], name: "index_freshwater_ecoregions_on_coordinates", using: :gist

  create_table "freshwaters", force: :cascade do |t|
    t.integer  "feow_id"
    t.integer  "freshwater_ecoregion_id"
    t.text     "name"
    t.text     "freshwater_type"
    t.float    "area_km2"
    t.float    "perimeter_km"
    t.float    "longitude"
    t.float    "latitude"
    t.float    "elevation"
    t.text     "country"
    t.text     "secondary_countries"
    t.text     "river"
    t.text     "near_city"
    t.geometry "coordinates",             limit: {:srid=>4326, :type=>"geometry"}
    t.text     "json_coordinates"
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
  end

  add_index "freshwaters", ["area_km2"], name: "index_freshwaters_on_area_km2", using: :btree
  add_index "freshwaters", ["coordinates"], name: "index_freshwaters_on_coordinates", using: :gist
  add_index "freshwaters", ["country"], name: "index_freshwaters_on_country", using: :btree
  add_index "freshwaters", ["freshwater_ecoregion_id"], name: "index_freshwaters_on_freshwater_ecoregion_id", using: :btree
  add_index "freshwaters", ["freshwater_type"], name: "index_freshwaters_on_freshwater_type", using: :btree
  add_index "freshwaters", ["name"], name: "index_freshwaters_on_name", using: :btree

end
