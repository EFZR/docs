# Views / Vistas

Una vista es una tabla virtual que se compone de los resultados de una consulta SQL. Las vistas se utilizan para simplificar las consultas complejas y para ocultar la complejidad de la base de datos a los usuarios finales. Las vistas también permiten reutilizar consultas comunes y simplificar la lógica de las aplicaciones.

Estas se pueden usar para:

- Simplificar consultas complejas.
- Ocultar la complejidad de la base de datos a los usuarios finales.
- Reutilizar consultas comunes.
- Simplificar la lógica de las aplicaciones.

## Crear una vista

Para crear una vista, se utiliza la siguiente sintaxis:

```sql
CREATE VIEW view_name AS
SELECT column1, column2, ...
FROM table_name
WHERE condition;
```

o

```sql
ALTER ALGORITHM = UNDEFINED
DEFINER=`root`@`localhost`
SQL SECURITY DEFINER VIEW `view_name`
AS
    select
        column 1,
        column 2,
        column 3 ...,
    from
        `table_name`;
```
