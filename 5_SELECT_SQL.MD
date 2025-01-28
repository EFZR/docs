# SELECT

La sentencia `SELECT` se utiliza para recuperar información de la base de datos. Esta sentencia permite recuperar todos los registros de una tabla, o solo los registros que cumplan con ciertas condiciones.

## Index

- [SELECT *](#select-)
- [WHERE](#where)
- [UNION](#union)
- [ORDER BY](#order-by)
- [GROUP BY](#group-by)
- [IN NOT IN](#in-not-in)
- [LIKE](#like)
- [HAVING](#having)

## `SELECT *`

La sentencia `SELECT *` se utiliza para recuperar todos los registros de una tabla. Esta sentencia permite recuperar todos los campos de una tabla, sin importar cuántos campos tenga la tabla.

```sql
SELECT * FROM usuarios;
```

## `WHERE`

La cláusula `WHERE` se utiliza para filtrar los registros que se recuperan de la base de datos. Esta cláusula permite especificar una o más condiciones que deben cumplir los registros para ser recuperados. Algo importante que aclarar es que esta clausula simplemente puede filtrar por los campos de la tabla, no por los campos calculados en la consulta.

```sql
SELECT * FROM usuarios WHERE id = 1;
```

## `UNION`

La cláusula `UNION` se utiliza para combinar los resultados de dos o más consultas. Esta cláusula permite combinar los resultados de dos o más consultas que devuelvan el mismo número de columnas y tipos de datos.

```sql
SELECT * FROM usuarios WHERE id = 1 UNION SELECT * FROM usuarios WHERE id = 2;
```

## `ORDER BY`

La cláusula `ORDER BY` se utiliza para ordenar los registros que se recuperan de la base de datos. Esta cláusula permite especificar una o más columnas por las cuales se deben ordenar los registros. Por defecto, los registros se ordenan de forma ascendente, pero se puede especificar que se ordenen de forma descendente utilizando la palabra clave `DESC`.

```sql
SELECT * FROM usuarios ORDER BY id DESC;
```

## `GROUP BY`

La cláusula `GROUP BY` se utiliza para agrupar los registros que se recuperan de la base de datos. Esta cláusula permite especificar una o más columnas por las cuales se deben agrupar los registros. Esta cláusula solo se puede utilizar en combinación con funciones de agregación, como `COUNT`, `SUM`, `AVG`, `MIN` y `MAX`.

```sql
SELECT COUNT(*) FROM usuarios GROUP BY genero;
```

## `IN NOT IN`

La clausula de comparación `IN` se utiliza para comparar un valor con una lista de valores. Esta clausula permite especificar una o más valores con los cuales se debe comparar el valor. Esta clausula es equivalente a utilizar múltiples clausulas `OR`.

```sql
SELECT * FROM usuarios WHERE genero IN ('M', 'F');
```

La clausula de comparación `NOT IN` se utiliza para comparar un valor con una lista de valores. Esta clausula permite especificar una o más valores con los cuales se debe comparar el valor. Esta clausula es equivalente a utilizar múltiples clausulas `AND`.

```sql
SELECT * FROM usuarios WHERE genero NOT IN ('M', 'F');
```

## `LIKE`

La clausula de comparación `LIKE` se utiliza para comparar un valor con una cadena de caracteres. Esta clausula permite especificar una o más caracteres comodín, que pueden ser `%` o `_`. El carácter `%` representa cero o más caracteres, y el carácter `_` representa un solo caracter.

```sql
SELECT * FROM usuarios WHERE nombre LIKE 'A%';
```

## `HAVING`

La cláusula `HAVING` se utiliza para filtrar los grupos que se recuperan de la base de datos. Esta cláusula permite especificar una o más condiciones que deben cumplir los grupos para ser recuperados. Esta cláusula solo se puede utilizar en combinación con la cláusula `GROUP BY`.

```sql
SELECT COUNT(*) FROM usuarios GROUP BY genero HAVING COUNT(*) > 10;
```
