CREATE TABLE to_remove_edges AS (

  WITH communes_elements AS MATERIALIZED (
    SELECT
      topo,
      topology.GetTopoGeomElements(communes_t.topo) topo_element
    FROM communes_t
  ),

  possible_edges AS MATERIALIZED (
    SELECT
      edge_id,
      ARRAY[left_face, 3]::topoelement left_face,
      ARRAY[right_face, 3]::topoelement right_face
    FROM communes_topo.edge_data
    WHERE
      (edge_data.left_face != 0) AND
        (edge_data.right_face != 0)
  ),

  gap_on_right AS (
    SELECT
      possible_edges.edge_id,
      possible_edges.right_face gap_face,
      communes_elements.topo
    FROM possible_edges
    LEFT JOIN communes_elements
      ON communes_elements.topo_element =
        possible_edges.left_face
  ),

  gap_on_left AS (
    SELECT
      possible_edges.edge_id,
      possible_edges.left_face gap_face,
      communes_elements.topo
    FROM possible_edges
    LEFT JOIN communes_elements
      ON communes_elements.topo_element =
        possible_edges.right_face
  ),

  assign_gap_to_commune AS (
    SELECT * FROM gap_on_right
    UNION ALL
    SELECT * FROM gap_on_left
  )

  SELECT neighbor.edge_id
  FROM communes_gaps,
  LATERAL (
      SELECT
        assign_gap_to_commune.edge_id,
        assign_gap_to_commune.topo
      FROM assign_gap_to_commune
      WHERE assign_gap_to_commune.gap_face = communes_gaps.face
      LIMIT 1
  ) neighbor,
  LATERAL (
    SELECT TopoGeom_addElement(neighbor.topo, communes_gaps.face)
  )
);