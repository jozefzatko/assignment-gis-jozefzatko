class Continent < ActiveRecord::Base
  
  has_many :freshwater_ecoregions
  
end
