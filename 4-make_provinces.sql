CREATE TABLE provinces_t(
  province_name TEXT,
  region_name TEXT
);

SELECT
  topology.AddTopoGeometryColumn(
	  'communes_topo',
	  'public',
	  'provinces_t', 
	  'topo',
	  'POLYGON',
	  1 -- Which layer to use as Childs
  ) As layer_id;

INSERT INTO
  provinces_t(
    province_name,
    region_name,
    topo
  )
  SELECT
    province_name,
    region_name,
    topology.CreateTopoGeom(
      -- Topology name
      'communes_topo',
      -- Spatial type
      3,
      -- Layer Id (provinces_t.topo)
      2,
      topology.TopoElementArray_Agg(
        topo::topoelement
      )
    )
  FROM communes_t
  GROUP BY province_name, region_name;
