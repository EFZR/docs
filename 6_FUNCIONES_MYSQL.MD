# Funciones de MySQL

## Index

- [if](#if)
- [case](#case)
- [ifnull](#ifnull)
- [substring](#substring)
- [current_date y current_time](#curent_date-y-current_time)
- [database](#database)
- [current_user](#current_user)
- [datediff](#datediff)
- [dayofweek](#dayofweek)
- [adddate](#adddate)
- [subdate](#subdate)
- [addtime](#addtime)
- [cast](#cast)
- [char_length](#char_length)
- [compress y uncompress](#compress-y-uncompress)
- [concat](#concat)
- [concat_ws](#concat_ws)
- [conv](#conv)
- [aes_encrypt y aes_decrypt](#aes_encrypt-y-aes_decrypt)
- [length](#length)
- [date_format](#date_format)
- [in](#in)

## `IF`

La función `IF` de MySQL es una función de control de flujo que permite evaluar una condición y devolver un valor si la condición es verdadera y otro valor si la condición es falsa.

```sql
SELECT
    p.Prod_Id,
    p.Prod_Descripcion,
    IF (p.Prod_Status, 'Habilitado', 'Deshabilitado') AS Estado
FROM
  productos p;
```

## `CASE`

La función `CASE` de MySQL es una función de control de flujo que permite evaluar múltiples condiciones y devolver un valor diferente para cada condición.

```sql
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
```

## `IFNULL`

La función `IFNULL` de MySQL es una función que permite evaluar si un valor es nulo y devolver un valor alternativo en caso de que el valor sea nulo.

```sql
SELECT
    p.Prod_Id,
    p.Prod_Descripcion,
    IFNULL(p.Prod_Precio, 0) AS Precio
FROM
    productos p;
```

## `SUBSTRING`

La función `SUBSTRING` de MySQL permite extraer una subcadena de una cadena de texto, que recibe 3 parametros, la cadena de texto, la posición inicial y la longitud de la subcadena.

```sql
SELECT
    p.Prod_Id,
    p.Prod_Descripcion,
    SUBSTRING(p.Prod_Descripcion, 1, 10) AS Descripcion_Corta
FROM
    productos p;
```

## `CURENT_DATE` y `CURRENT_TIME`

Las funciones `CURRENT_DATE` y `CURRENT_TIME` de MySQL permiten obtener la fecha y la hora actual del sistema.

```sql
SELECT
    p.Prod_Id,
    p.Prod_Descripcion,
    CURRENT_DATE() AS Fecha_Actual,
    CURRENT_TIME() AS Hora_Actual
FROM
    productos p;
```

## `DATABASE`

La función `DATABASE` de MySQL permite obtener el nombre de la base de datos actual.

```sql
SELECT DATABASE() AS Base_Datos_Actual;
```

## `CURRENT_USER`

La función `CURRENT_USER` de MySQL permite obtener el usuario actual que está conectado a la base de datos.

```sql
SELECT CURRENT_USER() AS Usuario_Actual;
```

## `DATEDIFF`

La función `DATEDIFF` de MySQL permite obtener la diferencia en días entre dos fechas, recibe dos parametros, la fecha inicial y la fecha final.

```sql
SELECT
    p.Prod_Id,
    p.Prod_Descripcion,
    DATEDIFF(p.Prod_Fecha_Vencimiento, CURRENT_DATE()) AS Dias_Restantes
FROM
    productos p;
```

## `DAYOFWEEK`

La función `DAYOFWEEK` de MySQL permite obtener el día de la semana de una fecha, donde el día 1 es Domingo y el día 7 es Sábado.

```sql
SELECT
    p.Prod_Id,
    p.Prod_Descripcion,
    DAYOFWEEK(p.Prod_Fecha_Vencimiento) AS Dia_Semana
FROM
    productos p;
```

## `ADDDATE`

La función `ADDDATE` de MySQL permite sumar una cantidad de días a una fecha.

```sql
SELECT
    p.Prod_Id,
    p.Prod_Descripcion,
    ADDDATE(p.Prod_Fecha_Vencimiento, 10) AS Nueva_Fecha_Vencimiento
FROM
    productos p;
```

## `SUBDATE`

La función `SUBDATE` de MySQL permite restar una cantidad de días a una fecha.

```sql
SELECT
    p.Prod_Id,
    p.Prod_Descripcion,
    SUBDATE(p.Prod_Fecha_Vencimiento, 10) AS Nueva_Fecha_Vencimiento
FROM
    productos p;
```

## `ADDTIME`

La función `ADDTIME` de MySQL permite sumar una cantidad de tiempo a una hora.

```sql
SELECT
    p.Prod_Id,
    p.Prod_Descripcion,
    ADDTIME(p.Prod_Hora_Vencimiento, '02:30:00') AS Nueva_Hora_Vencimiento
FROM
    productos p;
```

## `CAST`

La función `CAST` de MySQL permite convertir un valor de un tipo de dato a otro tipo de dato.

```sql
SELECT
    p.Prod_Id,
    p.Prod_Descripcion,
    CAST(p.Prod_Precio AS CHAR) AS Precio
FROM
    productos p;
```

## `CHAR_LENGTH`

La función `CHAR_LENGTH` de MySQL permite obtener la longitud de una cadena de texto.

```sql
SELECT
    p.Prod_Id,
    p.Prod_Descripcion,
    CHAR_LENGTH(p.Prod_Descripcion) AS Longitud_Descripcion
FROM
    productos p;
```

## `COMPRESS` Y `UNCOMPRESS`

Las funciones `COMPRESS` y `UNCOMPRESS` de MySQL permiten comprimir y descomprimir una cadena de texto.

```sql
SELECT
    p.Prod_Id,
    p.Prod_Descripcion,
    COMPRESS(p.Prod_Descripcion) AS Descripcion_Comprimida,
    UNCOMPRESS(COMPRESS(p.Prod_Descripcion)) AS Descripcion_Descomprimida
FROM
    productos p;
```

## `CONCAT`

La función `CONCAT` de MySQL permite concatenar dos o más cadenas de texto.

```sql
SELECT
    p.Prod_Id,
    p.Prod_Descripcion,
    CONCAT(p.Prod_Descripcion, ' - ', p.Prod_Precio) AS Descripcion_Precio
FROM
    productos p;
```

## `CONCAT_WS`

La función `CONCAT_WS` de MySQL permite concatenar dos o más cadenas de texto separadas por un separador.

```sql
SELECT
    p.Prod_Id,
    p.Prod_Descripcion,
    CONCAT_WS(' - ', p.Prod_Descripcion, p.Prod_Precio) AS Descripcion_Precio
FROM
    productos p;
```

## `CONV`

La función `CONV` de MySQL permite convertir un número de un sistema numérico a otro sistema numérico.

```sql
SELECT
    p.Prod_Id,
    p.Prod_Descripcion,
    CONV(p.Prod_Precio, 10, 16) AS Precio_Hexadecimal
FROM
    productos p;
```

## `AES_ENCRYPT` y `AES_DECRYPT`

Las funciones `AES_ENCRYPT` y `AES_DECRYPT` de MySQL permiten encriptar y desencriptar una cadena de texto.

```sql
SELECT
    p.Prod_Id,
    p.Prod_Descripcion,
    AES_ENCRYPT(p.Prod_Descripcion, 'clave_secreta') AS Descripcion_Encriptada,
    AES_DECRYPT(AES_ENCRYPT(p.Prod_Descripcion, 'clave_secreta'), 'clave_secreta') AS Descripcion_Desencriptada
FROM
    productos p;
```

## `LENGTH`

La función `LENGTH` de MySQL permite obtener la longitud de una cadena de texto.

```sql
SELECT
    p.Prod_Id,
    p.Prod_Descripcion,
    LENGTH(p.Prod_Descripcion) AS Longitud_Descripcion
FROM
    productos p;
```

## `DATE_FORMAT`

La función `DATE_FORMAT` de MySQL permite formatear una fecha en un formato específico, Este recibe dos parametros, la fecha y el formato en el que se desea mostrar la fecha.

El formato de la fecha se compone de los siguientes caracteres:

- `%d`: Día del mes (01-31)
- `%m`: Mes (01-12)
- `%Y`: Año (cuatro dígitos)
- `%y`: Año (dos dígitos)
- `%H`: Hora (00-23)
- `%h`: Hora (01-12)
- `%i`: Minutos (00-59)
- `%s`: Segundos (00-59)
- `%a`: Abreviatura del día de la semana (Sun-Sat)
- `%W`: Nombre completo del día de la semana (Sunday-Saturday)
- `%b`: Abreviatura del mes (Jan-Dec)
- `%M`: Nombre completo del mes (January-December)

```sql
SELECT
    p.Prod_Id,
    p.Prod_Descripcion,
    DATE_FORMAT(p.Prod_Fecha_Vencimiento, '%d/%m/%Y') AS Fecha_Vencimiento
FROM
    productos p;
```

## `IN`

La clausula de comparación `IN` se utiliza para comparar un valor con una lista de valores. Esta clausula permite especificar una o más valores con los cuales se debe comparar el valor. Esta clausula es equivalente a utilizar múltiples clausulas `OR`.

```sql
SELECT
    p.Prod_Id,
    p.Prod_Descripcion,
    p.Prod_Genero
FROM
    productos p
WHERE
    p.Prod_Genero IN ('M', 'F');
```
