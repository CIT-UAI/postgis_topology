CREATE TABLE communes_overlaps AS (
  WITH used_faces AS (
      SELECT topology.GetTopoGeomElements(topo) face
      FROM communes_t
  ),
  face_counter AS (
    SELECT face, COUNT(1) counter
    FROM used_faces
    GROUP BY face
  )
  SELECT face
  FROM face_counter
  WHERE counter != 1
);