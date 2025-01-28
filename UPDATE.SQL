-- UPDATE
UPDATE productos p
SET
  p.Prod_Descripcion = 'DOMITIC SPEAKER XIAOMI',
  p.Prod_Status = 0
WHERE
  p.Prod_Id = 6990;

-- UPDATE using IN
UPDATE clientes c
SET
  c.Cli_Estado = 1
WHERE
  c.Cli_Id IN (6, 20, 54, 56);

-- UPDATE
UPDATE productos p
SET
  p.Prod_Precio = p.Prod_Precio + 100
WHERE
  p.Prod_Id = 6989;