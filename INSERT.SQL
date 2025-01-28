-- INSERT
INSERT INTO
  alumnos (Alumno_Nombre)
VALUES
  ('John Doe');

INSERT INTO
  productos (Prod_Descripcion, Prod_Color)
VALUES
  ('DOMOTIC SPEAKER', 'WHITE');

INSERT INTO
  productos (
    Prod_Descripcion,
    Prod_Color,
    Prod_Precio,
    Prod_ProvId
  )
VALUES
  ('Samsung A53', 'Negro', 10000, 1);

-- BULK INSERT
INSERT INTO
  alumnos (Alumno_Nombre)
VALUES
  ('Johanna Smith'),
  ('Pedro Jerez'),
  ('Maria Antonieta'),
  ('Pablo Neruda');

INSERT INTO
  productos (Prod_Descripcion, Prod_Color)
VALUES
  ('DOMOTIC CAMERA', 'BEIGE'),
  ('MOUSE PRO', 'BLACK');

INSERT INTO 
  productos(
		Prod_Descripcion,
		Prod_Color,
		Prod_Precio,
		Prod_ProvId
	)
VALUES
	('SAMSUNG A54', 'NEGRO', 15000, 1), 
	('SAMSUNG A70', 'NEGRO', 12000, 1);