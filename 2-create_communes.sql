CREATE TABLE communes_t(
  commune_name TEXT,
  province_name TEXT,
  region_name TEXT
);

SELECT
  topology.AddTopoGeometryColumn(
	  'communes_topo',
	  'public',
	  'communes_t', 
	  'topo',
	  'POLYGON'
  ) As layer_id;