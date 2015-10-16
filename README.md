# General course assignment

Build a map-based application, which lets the user see geo-based data on a map and filter/search through it in a meaningfull way. Specify the details and build it in your language of choice. The application should have 3 components:

1. Custom-styled background map, ideally built with [mapbox](http://mapbox.com). Hard-core mode: you can also serve the map tiles yourself using [mapnik](http://mapnik.org/) or similar tool.
2. Local server with [PostGIS](http://postgis.net/) and an API layer that exposes data in a [geojson format](http://geojson.org/).
3. The user-facing application (web, android, ios, your choice..) which calls the API and lets the user see and navigate in the map and shows the geodata. You can (and should) use existing components, such as the Mapbox SDK, or [Leaflet](http://leafletjs.com/).


# My project (not completely specified yet)


## Application description
- Showing lakes and rivers for selected country with detailed information about them
- Showing lakes and rivers for selected ecoregion
- Showing country and ecoregion for selected river or lake

## Data source
[Borders of World Countries](https://github.com/johan/world.geo.json/tree/master/countries)
[Global Lakes and Wetlands Database - Level 1](https://www.worldwildlife.org/publications/global-lakes-and-wetlands-database-large-lake-polygons-level-1)
[Global Lakes and Wetlands Database: Small Lake Polygons- Level 2](http://www.worldwildlife.org/publications/global-lakes-and-wetlands-database-small-lake-polygons-level-2)
[Freshwater Ecoregions of the World](http://www.feow.org/)

## Technologies used
[Ruby on Rails](http://rubyonrails.org/) (v4.2.4)<br />
[Mapbox](http://mapbox.com) (v2.2.2)<br />
[PostgreSQL](http://www.postgresql.org/) (v9.3)<br />
[PostGIS](http://postgis.net/) (v2.2)<br />

## Source code
[https://github.com/jozefzatko/assignment-gis-jozefzatko/tree/master/gis_rails_app](https://github.com/jozefzatko/assignment-gis-jozefzatko/tree/master/gis_rails_app)
