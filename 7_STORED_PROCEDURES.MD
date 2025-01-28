# Procedimientos Almacenados (Stored Procedures)

Un procedimiento almacenado es un conjunto predefinido de instrucciones SQL que se almacenan en el servidor de la base de datos. Estos pueden ser invocados y ejecutados desde una aplicación. Los procedimientos almacenados son útiles para realizar diversas tareas, incluyendo la inserción, actualización, eliminación y recuperación de datos en una base de datos. Además, pueden ser utilizados para realizar cálculos complejos y procesar datos antes de devolverlos a la aplicación.

Los procedimientos almacenados son comúnmente utilizados en aplicaciones que interactúan con bases de datos relacionales, como las aplicaciones web, de escritorio y móviles. Permiten realizar operaciones en la base de datos de manera eficiente y segura.

## Index

- [Creación de un Procedimiento Almacenado en MySQL](#creación-de-un-procedimiento-almacenado-en-mysql)
- [Declaración de Variables en un Procedimiento Almacenado](#declaración-de-variables-en-un-procedimiento-almacenado)
- [Asignación de Valores a Variables en un Procedimiento Almacenado](#asignación-de-valores-a-variables-en-un-procedimiento-almacenado)
- [Asignacion de Valores de Select a Variables en un Procedimiento Almacenado](#asignacion-de-valores-de-select-a-variables-en-un-procedimiento-almacenado)
- [Parámetros de Entrada en un Procedimiento Almacenado](#parámetros-de-entrada-en-un-procedimiento-almacenado)
- [Manejo de Excepciones en un Procedimiento Almacenado](#manejo-de-excepciones-en-un-procedimiento-almacenado)
- [Manejo de excepciones específicas en un Procedimiento Almacenado](#manejo-de-excepciones-específicas-en-un-procedimiento-almacenado)
- [Ejecución de un Procedimiento Almacenado](#ejecución-de-un-procedimiento-almacenado)
- [Condiciones IF en un Procedimiento Almacenado](#condiciones-if-en-un-procedimiento-almacenado)
- [Bucles WHILE en un Procedimiento Almacenado](#bucles-while-en-un-procedimiento-almacenado)
- [Cursor en un Procedimiento Almacenado](#cursor-en-un-procedimiento-almacenado)

## Creación de un Procedimiento Almacenado en MySQL

La estructura básica de un procedimiento almacenado en MySQL es la siguiente:

```sql
CREATE PROCEDURE nombre_procedimiento()
BEGIN
    -- Cuerpo del procedimiento almacenado
END;
```

## Declaración de Variables en un Procedimiento Almacenado

Es posible declarar variables en un procedimiento almacenado para almacenar valores temporales. Las variables se pueden utilizar para realizar cálculos, almacenar resultados intermedios y realizar otras operaciones.

```sql
CREATE PROCEDURE nombre_procedimiento()
BEGIN
    DECLARE variable1 INT;
    DECLARE variable2 VARCHAR(50);
    -- Cuerpo del procedimiento almacenado
END;
```

## Asignación de Valores a Variables en un Procedimiento Almacenado

Las variables en un procedimiento almacenado pueden ser asignadas con valores utilizando la instrucción `SET`.

```sql
CREATE PROCEDURE nombre_procedimiento()
BEGIN
    DECLARE variable1 INT;
    DECLARE variable2 VARCHAR(50);
    SET variable1 = 10;
    SET variable2 = 'Ejemplo';
    -- Cuerpo del procedimiento almacenado
END;
```

## Asignacion de Valores de Select a Variables en un Procedimiento Almacenado

Las variables en un procedimiento almacenado pueden ser asignadas con valores de un `SELECT` utilizando la instrucción `SELECT INTO`.

```sql
CREATE PROCEDURE nombre_procedimiento()
BEGIN
    DECLARE variable1 INT;
    DECLARE variable2 VARCHAR(50);
    SELECT columna1, columna2 INTO variable1, variable2 FROM tabla WHERE condicion;
    -- Cuerpo del procedimiento almacenado
END;
```

## Parámetros de Entrada en un Procedimiento Almacenado

Los procedimientos almacenados pueden recibir parámetros de entrada que se utilizan para proporcionar valores a las instrucciones SQL dentro del procedimiento. Estos parámetros se definen en la declaración del procedimiento y se utilizan en el cuerpo del procedimiento.

```sql
CREATE PROCEDURE nombre_procedimiento(parametro1 INT, parametro2 VARCHAR(50))
BEGIN
    -- Cuerpo del procedimiento almacenado
END;
```

## Manejo de Excepciones en un Procedimiento Almacenado

Es posible manejar excepciones en un procedimiento almacenado utilizando bloques `TRY...CATCH`. Esto permite capturar errores y tomar acciones específicas en caso de que ocurran excepciones durante la ejecución del procedimiento.

```sql
CREATE PROCEDURE nombre_procedimiento()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Manejo de excepciones
    END;
    -- Cuerpo del procedimiento almacenado
END;
```

## Manejo de excepciones específicas en un Procedimiento Almacenado

En un procedimiento almacenado, es factible gestionar excepciones específicas mediante el uso de bloques `TRY...CATCH`. Estos bloques permiten definir condiciones específicas basadas en códigos de excepción. De esta manera, es posible capturar errores concretos y ejecutar acciones personalizadas en respuesta a las excepciones que puedan surgir durante la ejecución del procedimiento almacenado.

```sql
CREATE PROCEDURE nombre_procedimiento()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Manejo de excepciones
    END;

    DECLARE EXIT HANDLER FOR 1062
    BEGIN
        -- Manejo de excepciones específicas
    END;
    -- Cuerpo del procedimiento almacenado
END;
```

A continuación, se presenta una lista de algunos códigos de error comunes que puedes encontrar al trabajar con MySQL, junto con una breve descripción de cada uno:

- **1062**: Este error indica un conflicto de duplicación de clave primaria.
- **1064**: Este error se refiere a un problema de sintaxis en la consulta SQL.
- **1146**: Este error se produce cuando intentas acceder a una tabla que no existe en la base de datos.
- **1451**: Este error indica una violación de la restricción de clave foránea. Ocurre cuando intentas eliminar un registro que está siendo referenciado por un registro en otra tabla.
- **1452**: Este error también indica una violación de la restricción de clave foránea. Se produce cuando intentas insertar un registro en una tabla que tiene una clave foránea, pero el valor de la clave foránea no existe en la tabla referenciada.

## Ejecución de un Procedimiento Almacenado

Para ejecutar un procedimiento almacenado en MySQL, se utiliza la instrucción `CALL` seguida del nombre del procedimiento y los parámetros necesarios.

```sql
CALL nombre_procedimiento();
```

## Condiciones IF en un Procedimiento Almacenado

Es posible utilizar condiciones `IF` en un procedimiento almacenado para realizar operaciones condicionales. Esto permite ejecutar diferentes bloques de código dependiendo de una condición específica.

```sql
CREATE PROCEDURE nombre_procedimiento()

BEGIN
    DECLARE variable1 INT;
    SET variable1 = 10;
    
    IF variable1 > 5 THEN
        -- Código a ejecutar si la condición es verdadera
    ELSE
        -- Código a ejecutar si la condición es falsa
    END IF;
    
END;
```

## Bucles WHILE en un Procedimiento Almacenado

Los bucles `WHILE` se utilizan en procedimientos almacenados para repetir un bloque de código mientras se cumpla una condición específica. Esto permite ejecutar operaciones de forma iterativa hasta que la condición de salida se cumpla.

```sql
CREATE PROCEDURE nombre_procedimiento()

BEGIN
    DECLARE contador INT;
    SET contador = 1;
    
    WHILE contador <= 10 DO
        -- Código a ejecutar en cada iteración
        SET contador = contador + 1;
    END WHILE;
    
END;
```

## Cursor en un Procedimiento Almacenado

Un cursor es una estructura de control que actúa como un intermediario entre una consulta SQL y los resultados de esa consulta. En términos más sencillos, se puede considerar como una tabla en memoria que permite recorrer los resultados de una consulta SQL de manera secuencial. En el contexto de los procedimientos almacenados, los cursores son especialmente útiles para procesar individualmente las filas de una tabla, permitiendo realizar operaciones específicas en cada una de ellas.

```sql
CREATE PROCEDURE nombre_procedimiento() -- CREACION DE PROCEDIMIENTO ALMACENADO
READS SQL DATA -- INDICA QUE EL PROCEDIMIENTO SOLO LEE DATOS

BEGIN
    DECLARE done INT DEFAULT FALSE; -- DECLARACION DE VARIABLE done
    DECLARE variable1 INT; -- DECLARACION DE VARIABLE variable1
    DECLARE cursor1 CURSOR FOR SELECT columna1 FROM tabla; -- DECLARACION DE CURSOR cursor1
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; -- MANEJADOR DE CURSOR PARA SALIR DEL BUCLE
    
    OPEN cursor1; -- APERTURA DE CURSOR
    
    read_loop: LOOP -- BUCLE DE LECTURA
        FETCH cursor1 INTO variable1; -- OBTENER DATOS DEL CURSOR
        IF done THEN -- CONDICION DE SALIDA
            LEAVE read_loop; -- SALIDA DEL BUCLE
        END IF;
        
        -- Codigo a ejecutar en cada iteracion
    END LOOP;
    
    CLOSE cursor1; -- CIERRE DE CURSOR
    
END;
```
