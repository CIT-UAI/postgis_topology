CREATE TABLE communes_gaps AS (
  SELECT face
  FROM (
    SELECT
      ARRAY[
        face_id, -- Primitive ID
        3 -- Primitive Type
      ]::topoelement face
    FROM communes_topo.face
    WHERE face_id != 0 -- Exclude Universal Face
    EXCEPT
    SELECT topology.GetTopoGeomElements(topo) face
    FROM communes_t
  )
);