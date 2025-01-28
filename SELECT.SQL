-- SELECT usando WHERE y ORDER BY
SELECT
  V.Ventas_NroFactura,
  V.Ventas_CliId,
  V.Ventas_Fecha,
  C.Cli_RazonSocial,
  VD.VD_ProdId,
  P.Prod_Descripcion,
  PR.Prov_Nombre
FROM
  ventas V,
  clientes C,
  ventas_detalle VD,
  productos P,
  proveedores PR
WHERE
  V.Ventas_CliId = C.Cli_Id
  AND VD.VD_VentasId = V.Ventas_Id
  AND VD.VD_ProdId = P.Prod_Id
  AND P.Prod_ProvId = PR.Prov_Id
ORDER BY
  V.Ventas_Fecha DESC,
  P.Prod_Descripcion ASC;

-- SELECT usando COUNT, GROUP BY, HAVING, ORDER BY
SELECT
  vd.VD_ProdId,
  COUNT(*) AS ventas_Por_Producto
FROM
  ventas_detalle vd
GROUP BY
  vd.VD_ProdId
HAVING
  ventas_por_producto > 100
ORDER BY
  ventas_por_producto DESC;

-- SELECT usando SUM, GROUP BY Y HAVING
SELECT
  YEAR (v.Ventas_Fecha) AS AÑO,
  MONTH (v.Ventas_Fecha) AS MES,
  SUM(v.Ventas_Total) AS TOTAL
FROM
  ventas v
GROUP BY
  AÑO,
  MES
HAVING
  TOTAL > 1000000;

-- SELECT usando DISTINCTROW
SELECT
  DISTINCTROW (vd.VD_ProdId)
FROM
  ventas_detalle vd;

-- SELECT usando DISTINCTROW, NOT IN y una subconsulta
SELECT
  *
FROM
  productos p
WHERE
  p.Prod_Id NOT IN (
    SELECT
      DISTINCTROW (vd.VD_ProdId)
    FROM
      ventas_detalle vd
  );

-- SELECT usando DISTINCTROW, NOT IN y una subconsulta
SELECT
  c.Cli_Id,
  c.Cli_RazonSocial
FROM
  clientes c
WHERE
  c.Cli_Id NOT IN (
    SELECT
      DISTINCTROW (v.Ventas_CliId)
    FROM
      ventas v
  );

-- SELECT usando LIKE junto a %
SELECT
  p.Prod_Id,
  p.Prod_Descripcion,
  p.Prod_Color,
  p.Prod_Status
FROM
  productos p
WHERE
  p.Prod_Descripcion LIKE '%TARUGO%';

-- SELECT usando NOT LIKE junto a %
SELECT
  p.Prod_Id,
  p.Prod_Descripcion,
  p.Prod_Color,
  p.Prod_Status
FROM
  productos p
WHERE
  p.Prod_Descripcion NOT LIKE '%NEGRO%';

-- SELECT usando LIKE y CONCAT
SELECT
  p.Prod_Id,
  p.Prod_Descripcion,
  p.Prod_Color,
  p.Prod_Status
FROM
  productos p
WHERE
  CONCAT (p.Prod_Descripcion, p.Prod_Color) LIKE '%NEGRO%';

-- SELECT usando JOIN y AND
SELECT
  v.Ventas_NroFactura,
  c.Cli_Id,
  c.Cli_RazonSocial,
  p.Prod_Descripcion
FROM
  productos p
  JOIN ventas_detalle vd ON vd.VD_ProdId = p.Prod_Id
  AND vd.VD_Costo > 1000
  JOIN ventas v ON v.Ventas_Id = vd.VD_VentasId
  AND v.Ventas_Fecha BETWEEN '2018-01-22' AND '2018-01-24'
  JOIN proveedores pr ON pr.Prov_Id = p.Prod_ProvId
  JOIN clientes c ON c.Cli_Id = v.Ventas_CliId;

-- SELECT usando JOIN, GROUP BY y ORDER BY
SELECT
  p.Prod_Id,
  p.Prod_Descripcion,
  SUM(vd.VD_Cantidad) AS 'Unidades_Vendidas'
FROM
  productos p
  JOIN ventas_detalle vd ON vd.VD_ProdId = p.Prod_Id
GROUP BY
  p.Prod_Id,
  p.Prod_Descripcion
ORDER BY
  p.Prod_Id;

-- SELECT usando LEFT JOIN, GROUP BY y ORDER BY
SELECT
  p.Prod_Id,
  p.Prod_Descripcion,
  SUM(vd.VD_Cantidad) AS 'Unidades_Vendidas'
FROM
  productos p
  LEFT JOIN ventas_detalle vd ON vd.VD_ProdId = p.Prod_Id
GROUP BY
  p.Prod_Id,
  p.Prod_Descripcion
ORDER BY
  p.Prod_Id;

-- SELECT usando RIGHT JOIN, GROUP BY y ORDER BY
SELECT
  p.Prod_Id,
  p.Prod_Descripcion,
  SUM(vd.VD_Cantidad) AS 'Unidades_Vendidas',
  vd.VD_ProdId
FROM
  productos p
  RIGHT JOIN ventas_detalle vd ON p.Prod_Id = vd.VD_ProdId
GROUP BY
  vd.VD_ProdId
ORDER BY
  vd.VD_ProdId;

-- SELECT usando IFNULL y una subconsulta dentro de las columnas
SELECT
  p.Prod_Id,
  p.Prod_Descripcion,
  p.Prod_Color,
  IFNULL (
    (
      SELECT
        SUM(vd.VD_Cantidad)
      FROM
        ventas_detalle vd
      WHERE
        vd.VD_ProdId = p.Prod_Id
      GROUP BY
        vd.VD_ProdId
    ),
    0
  ) AS 'TOTAL UNIDADES',
  IFNULL (
    (
      SELECT
        SUM(vd.VD_Precio)
      FROM
        ventas_detalle vd
      WHERE
        vd.VD_ProdId = p.Prod_Id
      GROUP BY
        vd.VD_ProdId
    ),
    0
  ) AS 'TOTAL VENTAS'
FROM
  productos p;

-- SELECT usando JOIN y una subconsulta dentro del JOIN
SELECT
  p.Prod_Id,
  p.Prod_Descripcion,
  v.unidades
FROM
  productos p
  JOIN (
    SELECT
      VD_ProdId,
      SUM(VD_Cantidad) AS 'unidades'
    FROM
      ventas_detalle
    GROUP BY
      VD_ProdId
  ) v ON p.Prod_Id = v.VD_ProdId
  AND v.unidades > 100;

-- SELECT usando una subconsulta dentro del WHERE
SELECT
  p.Prod_Id,
  p.Prod_Descripcion
FROM
  productos p
WHERE
  (
    SELECT
      SUM(vd.VD_Cantidad)
    FROM
      ventas_detalle vd
    WHERE
      vd.VD_ProdId = p.Prod_Id
  ) > 100;