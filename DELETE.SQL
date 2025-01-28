--DELETE
DELETE FROM productos p
WHERE
  p.Prod_Id = 6992;

-- DELETE using A subquery
DELETE FROM productos p
WHERE
  (
    SELECT
      SUBSTRING(pr.Prov_Nombre, 1, 1)
    FROM
      proveedores pr
    WHERE
      pr.Prov_Id = p.Prod_Id
  ) LIKE 'A';

-- DELETE using JOIN
DELETE p
FROM
  productos p
  JOIN proveedores pr ON p.Prod_ProvId = pr.Prov_Id
WHERE
  pr.Prov_Nombre LIKE 'A%';