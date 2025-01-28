-- Funcion IF
SELECT
  p.Prod_Id,
  p.Prod_Descripcion,
  IF (p.Prod_Status, 'Habilitado', 'Deshabilitado') AS Estado
FROM
  productos p;

-- Funcion CASE
SELECT
  p.Prod_Id,
  p.Prod_Descripcion,
  CASE p.Prod_Status
    WHEN 0 THEN 'Deshabilitado'
    WHEN 1 THEN 'Habilitado'
    WHEN 2 THEN 'Otro Estado'
  END AS Estado
FROM
  productos p;

-- Funcion CASE y IFNULL usando una subconsulta
SELECT
  p.Prod_Id,
  p.Prod_Descripcion,
  CASE p.Prod_Status
    WHEN 0 THEN 'Deshabilitado'
    WHEN 1 THEN IFNULL (
      (
        SELECT
          SUM(vd.VD_Cantidad)
        FROM
          ventas_detalle vd
        WHERE
          vd.VD_ProdId = p.Prod_id
      ),
      0
    )
    WHEN 2 THEN 'Otro Estado'
  END AS Estado
FROM
  productos p;

-- Funcion CASE y SUBSTRING
SELECT
  p.Prod_Id,
  p.Prod_Descripcion,
  CASE SUBSTRING(p.Prod_Descripcion, 1, 1)
    WHEN 'A' THEN 'LETRA A'
    WHEN 'B' THEN 'LETRA B'
  END AS 'LETRAS'
FROM
  productos p;

-- Funcion CURRENT_DATE y CURRENT_TIME
SELECT
  p.Prod_Id,
  p.Prod_Descripcion,
  CURRENT_DATE() AS 'FECHA ACTUAL',
  CURRENT_TIME() AS 'HORA ACTUAL'
FROM
  productos p;

-- Funcion CURRENT_TIMESTAMP
SELECT
  p.Prod_Id,
  p.Prod_Descripcion,
  CURRENT_TIMESTAMP() AS 'FECHA Y HORA ACTUAL'
FROM
  productos p;

-- Function DATABASE()
SELECT
  DATABASE () AS 'BASE DE DATOS ACTUAL';

-- Function CURRENT_USER
SELECT
  CURRENT_USER () AS 'USUARIO ACTUAL';

-- Function DATEDIFF
SELECT
  v.Ventas_NroFactura,
  DATEDIFF (CURRENT_DATE, v.Ventas_Fecha) AS "DIFERENCIA EN DIAS"
FROM
  ventas v;

-- Function DAYOFWEEK
SELECT
  DAYOFWEEK (CURRENT_DATE) AS 'DIA DE LA SEMANA';

-- Function ADDDATE
SELECT
  ADDDATE (CURRENT_DATE(), 100) AS 'FECHA ACTUAL + 100 DIAS';

-- Function ADDTIME
SELECT
  ADDTIME (CURRENT_TIMESTAMP, '00:30:00') AS 'HORA ACTUAL + 30 MINUTOS';

-- Function CAST
SELECT
  CAST('100000000' AS CHAR) AS 'CAST CHAR';

-- Function CHAR_LENGTH
SELECT
  p.Prod_Descripcion,
  CHAR_LENGTH(p.Prod_Descripcion) AS 'CANTIDAD DE CARACTERES'
FROM
  productos p;

-- Function COMPRESS y UNCOMPRESS
SELECT
  p.Prod_Descripcion,
  COMPRESS (p.Prod_Descripcion) AS 'COMPRESION',
  UNCOMPRESS (COMPRESS (p.Prod_Descripcion)) AS 'DESCOMPRESION'
FROM
  productos p;

-- Function CONCAT
SELECT
  CONCAT (
    "(",
    p.Prod_Id,
    ") ",
    p.Prod_Descripcion,
    " ",
    p.Prod_Color
  ) AS 'Descripción'
FROM
  productos p;

-- Function CONCAT_WS
SELECT
  CONCAT_WS (" ", p.Prod_Id, p.Prod_Descripcion, p.Prod_Color) AS 'Descripcion'
FROM
  productos p;

-- Function CONV
SELECT
  CONV ("100", 10, 2) AS 'CONVERSION DEL 100 A BASE 2';

-- Function CONV
SELECT
  CONV ("F", 16, 10) AS 'CONVERSION DEL F A BASE 10';

-- Function DATE_ADD
SELECT
  DATE_ADD (CURRENT_DATE, INTERVAL 100 DAY) AS 'FECHA ACTUAL + 100 DIAS';

-- Function DATE_FORMAT
SELECT
  DATE_FORMAT (CURRENT_DATE, '%d/%m/%Y') AS 'FECHA ACTUAL FORMATO DD/MM/YYYY';

-- Function DATE_SUB
SELECT
  DATE_SUB (CURRENT_DATE, INTERVAL 100 DAY) AS 'FECHA ACTUAL - 100 DIAS';