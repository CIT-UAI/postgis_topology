-- This will populate communes_t
-- and will fill the topology with goemetries

INSERT INTO
  communes_t(
    commune_name,
    province_name,
    region_name,
    topo
  )
  SELECT
    commune_name,
    province_name,
    region_name,
    topology.toTopoGeom(
      -- Geometry filed
      ST_Transform(geom, 32718),
      -- Topology name
      'communes_topo',
      -- Layer Id
      1
    )
  FROM communes;