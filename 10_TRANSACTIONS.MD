# Transactions / Transacciones

Las transacciones son un conjunto de operaciones que se realizan de forma atómica, es decir, todas las operaciones se realizan o ninguna se realiza. Las transacciones garantizan la integridad de los datos y permiten mantener la consistencia de la base de datos

## `START TRANSACTION`

La instrucción `START TRANSACTION` se utiliza para iniciar una transacción. Todas las operaciones que se realicen después de la instrucción `START TRANSACTION` formarán parte de la transacción.

```sql
START TRANSACTION;
```

## `COMMIT`

La instrucción `COMMIT` se utiliza para confirmar una transacción. Todas las operaciones que se realizaron después de la instrucción `START TRANSACTION` se confirman y se guardan de forma permanente en la base de datos.

```sql
COMMIT;
```

## `ROLLBACK`

La instrucción `ROLLBACK` se utiliza para cancelar una transacción. Todas las operaciones que se realizaron después de la instrucción `START TRANSACTION` se cancelan y se deshacen.

```sql
ROLLBACK;
```

## `SAVEPOINT`

La instrucción `SAVEPOINT` se utiliza para crear un punto de guardado dentro de una transacción. Los puntos de guardado permiten deshacer solo una parte de la transacción, en lugar de deshacer toda la transacción.

```sql
SAVEPOINT nombre_punto_guardado;
```

## `ROLLBACK TO SAVEPOINT`

La instrucción `ROLLBACK TO SAVEPOINT` se utiliza para deshacer una parte de la transacción hasta un punto de guardado específico.

```sql
ROLLBACK TO SAVEPOINT nombre_punto_guardado;
```

## EJEMPLO

Supongamos que tienes una tabla llamada `productos` y quieres realizar una transacción que consiste en insertar un nuevo producto y actualizar el stock de un producto existente. Puedes realizar esta transacción de la siguiente manera:

```sql
START TRANSACTION;

INSERT INTO productos (nombre, precio, stock) VALUES ('Nuevo Producto', 100, 10);

UPDATE productos SET stock = stock - 1 WHERE id = 1;

ROLLBACK;

COMMIT;
```
