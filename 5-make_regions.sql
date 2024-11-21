CREATE TABLE regions_t(
  region_name TEXT
);

SELECT
  topology.AddTopoGeometryColumn(
	  'communes_topo',
	  'public',
	  'regions_t', 
	  'topo',
	  'POLYGON',
	  2 -- Which layer to use as Childs
  ) As layer_id;

INSERT INTO
  regions_t(
    region_name,
    topo
  )
  SELECT
    region_name,
    topology.CreateTopoGeom(
      'communes_topo',
      3, -- Primitive type
      (
        topology.FindLayer(
          'public',
          'regions_t',
          'topo'
        )
      ).layer_id, -- Layer 3
      topology.TopoElementArray_Agg(
        topo::topoelement
      )
    )
  FROM provinces_t
  GROUP BY region_name;