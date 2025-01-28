# Triggers / Disparadores

Los `Triggers` o `Disparadores` son funcionalidades que la base de datos ejecuta automáticamente cuando se realiza una operación en una tabla, como por ejemplo, una inserción, actualización o eliminación de registros. Los `Triggers` son útiles para llevar a cabo tareas específicas antes o después de que se realice una operación en una tabla.

El uso de triggers puede ser útil para realizar tareas como:

- Validar los datos antes de insertarlos en una tabla.
- Actualizar una tabla secundaria cuando se inserta, actualiza o elimina un registro en una tabla principal, como podría ser una tabla de datos históricos.
- Mantener bitácoras de los cambios realizados en una tabla.
- Realizar cálculos o procesamientos adicionales antes o después de una operación en una tabla.

## Index

- [Cuerpo de un Trigger](#cuerpo-de-un-trigger)
- [`BEFORE`](#before)
- [`NEW`](#new)
- [`OLD`](#old)
- [`AFTER`](#after)
- [`DELIMITER`](#delimiter)

## Cuerpo de un Trigger

El cuerpo de un trigger es un bloque de código que se ejecuta cuando se cumple una condición específica. El cuerpo de un trigger puede contener una o más instrucciones SQL que se ejecutan cuando se activa el trigger.

La estructura básica de un trigger en MySQL es la siguiente:

```sql
CREATE TRIGGER nombre_disparador
AFTER INSERT
ON nombre_tabla
FOR EACH ROW BEGIN
    -- Cuerpo del disparador
END;
```

## `BEFORE`

El disparador `BEFORE` se ejecuta antes de que se realice una operación en una tabla. Es posible utilizar este tipo de disparador para realizar validaciones o modificaciones en los datos antes de que se inserten, actualicen o eliminen en una tabla.

La estructura de un disparador `BEFORE` en MySQL es la siguiente:

```sql
CREATE TRIGGER nombre_disparador
BEFORE INSERT
ON nombre_tabla
FOR EACH ROW BEGIN
    -- Cuerpo del disparador
END;
```

## `NEW`

La palabra clave `NEW` se utiliza en un trigger para hacer referencia a los valores que se van a insertar en una tabla. La palabra clave `NEW` se utiliza en un trigger `BEFORE INSERT` o `BEFORE UPDATE` para acceder a los valores que se van a insertar o actualizar en una tabla.

La palabra clave `NEW` se utiliza de la siguiente manera en un trigger:

```sql
CREATE TRIGGER nombre_disparador
BEFORE INSERT
ON nombre_tabla
FOR EACH ROW BEGIN
    SET NEW.columna = UCASE(NEW.columna); -- Convertir el valor de la columna a mayúsculas
END;
```

## `OLD`

La palabra clave `OLD` se utiliza en un trigger para hacer referencia a los valores que se van a eliminar o actualizar en una tabla. La palabra clave `OLD` se utiliza en un trigger `BEFORE DELETE` o `BEFORE UPDATE` para acceder a los valores que se van a eliminar o actualizar en una tabla.

La palabra clave `OLD` se utiliza de la siguiente manera en un trigger:

```sql
CREATE TRIGGER nombre_disparador
BEFORE DELETE
ON nombre_tabla
FOR EACH ROW BEGIN
    INSERT INTO tabla_historica (columna1, columna2) VALUES (OLD.columna1, OLD.columna2);
END;
```

## `AFTER`

El disparador `AFTER` se ejecuta después de que se realice una operación en una tabla. Es posible utilizar este tipo de disparador para realizar tareas adicionales después de que se inserten, actualicen o eliminen registros en una tabla.

La estructura de un disparador `AFTER` en MySQL es la siguiente:

```sql
CREATE TRIGGER nombre_disparador
AFTER INSERT
ON nombre_tabla
FOR EACH ROW BEGIN
    -- Cuerpo del disparador
END;
```

## `DELIMITER`

Cuando se crea un trigger en MySQL, es necesario cambiar el delimitador de sentencias para que el motor de base de datos pueda interpretar correctamente el bloque de código del trigger. Para cambiar el delimitador de sentencias, se utiliza la instrucción `DELIMITER`.

La instrucción `DELIMITER` se utiliza de la siguiente manera para cambiar el delimitador de sentencias:

```sql
DELIMITER //
```

Para finalizar el bloque de código del trigger, se utiliza el delimitador `//` en lugar del delimitador `;`. Una vez que se ha finalizado el bloque de código del trigger, se debe restablecer el delimitador de sentencias al valor predeterminado utilizando la instrucción `DELIMITER ;`.

La instrucción `DELIMITER` se utiliza de la siguiente manera para restablecer el delimitador de sentencias al valor predeterminado:

```sql
DELIMITER ;
```
