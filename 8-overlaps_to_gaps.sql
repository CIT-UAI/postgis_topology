SELECT NULL
FROM communes_t,
LATERAL (
  SELECT TopoGeom_remElement(communes_t.topo, communes_overlaps.face)
  FROM communes_overlaps
);

-- Recreate the gaps table
DROP TABLE IF EXISTS communes_gaps;

CREATE TABLE communes_gaps AS (
  SELECT face
  FROM (
    SELECT
      ARRAY[
        -- Primitive ID
        face_id,
        -- Primitive Type
        3
      ]::topoelement face
    FROM communes_topo.face
    -- Exclude Universal Face
    WHERE face_id != 0
    EXCEPT
    SELECT
      topology.GetTopoGeomElements(topo) face
    FROM communes_t
  )
);