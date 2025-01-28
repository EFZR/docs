# Data Types in MySQL

MySQL supports the following data types:

- **Numeric**: `TINYINT`, `SMALLINT`, `MEDIUMINT`, `INT`, `BIGINT`, `FLOAT`, `DOUBLE`, `DECIMAL`.
- **Date and Time**: `DATE`, `TIME`, `DATETIME`, `TIMESTAMP`, `YEAR`.
- **Text**: `CHAR`, `VARCHAR`, `TINYTEXT`, `TEXT`, `MEDIUMTEXT`, `LONGTEXT`.
- **Binary**: `TINYBLOB`, `BLOB`, `MEDIUMBLOB`, `LONGBLOB`.
- **Others**: `ENUM`, `SET`, `JSON`.

## Numeric

### `TINYINT`

The `TINYINT` data type is used to store integer numbers between -128 and 127.

```sql
CREATE TABLE users (
    id TINYINT
);
```

### `SMALLINT`

The `SMALLINT` data type is used to store integer numbers between -32768 and 32767.

```sql
CREATE TABLE users (
    id SMALLINT
);
```

### `MEDIUMINT`

The `MEDIUMINT` data type is used to store integer numbers between -8388608 and 8388607.

```sql
CREATE TABLE users (
    id MEDIUMINT
);
```

### `INT`

The `INT` data type is used to store integer numbers between -2147483648 and 2147483647.

```sql
CREATE TABLE users (
    id INT
);
```

### `BIGINT`

The `BIGINT` data type is used to store integer numbers between -9223372036854775808 and 9223372036854775807.

```sql
CREATE TABLE users (
    id BIGINT
);
```

### `FLOAT`

The `FLOAT` data type is used to store floating-point numbers between -3.402823466E+38 and -1.175494351E-38, 0 and 1.175494351E-38, and 3.402823466E+38.

```sql
CREATE TABLE users (
    id FLOAT
);
```

### `DOUBLE`

The `DOUBLE` data type is used to store floating-point numbers between -1.7976931348623157E+308 and -2.2250738585072014E-308, 0 and 2.2250738585072014E-308, and 1.7976931348623157E+308.

```sql
CREATE TABLE users (
    id DOUBLE
);
```

### `DECIMAL`

The `DECIMAL` data type is used to store floating-point numbers between -9999999999999999999999999999.9999999999999999999999999999 and 9999999999999999999999999999.9999999999999999999999999999.

```sql
CREATE TABLE users (
    id DECIMAL
);
```

## Date and Time

### `DATE`

The `DATE` data type is used to store dates in the format `YYYY-MM-DD`.

```sql
CREATE TABLE users (
    date_of_birth DATE
);
```

### `TIME`

The `TIME` data type is used to store times in the format `HH:MM:SS`.

```sql
CREATE TABLE users (
    login_time TIME
);
```

### `DATETIME`

The `DATETIME` data type is used to store dates and times in the format `YYYY-MM-DD HH:MM:SS`.

```sql
CREATE TABLE users (
    login_datetime DATETIME
);
```

### `TIMESTAMP`

The `TIMESTAMP` data type is used to store dates and times in the format `YYYY-MM-DD HH:MM:SS`. This data type is used to store the date and time when a record is inserted or updated.

```sql
CREATE TABLE users (
    login_timestamp TIMESTAMP
);
```

### `YEAR`

The `YEAR` data type is used to store years in the format `YYYY`.

```sql
CREATE TABLE users (
    joining_year YEAR
);
```

## Text

### `CHAR`

The `CHAR` data type is used to store fixed-length text strings. The maximum length of this data type is 255 characters.

```sql
CREATE TABLE users (
    name CHAR(255)
);
```

### `VARCHAR`

The `VARCHAR` data type is used to store variable-length text strings. The maximum length of this data type is 65535 characters.

```sql
CREATE TABLE users (
    name VARCHAR(255)
);
```

### `TINYTEXT`

The `TINYTEXT` data type is used to store variable-length text strings. The maximum length of this data type is 255 characters.

```sql
CREATE TABLE users (
    name TINYTEXT
);
```

### `TEXT`

The `TEXT` data type is used to store variable-length text strings. The maximum length of this data type is 65535 characters.

```sql
CREATE TABLE users (
    name TEXT
);
```

### `MEDIUMTEXT`

The `MEDIUMTEXT` data type is used to store variable-length text strings. The maximum length of this data type is 16777215 characters.

```sql
CREATE TABLE users (
    name MEDIUMTEXT
);
```

### `LONGTEXT`

The `LONGTEXT` data type is used to store variable-length text strings. The maximum length of this data type is 4294967295 characters.

```sql
CREATE TABLE users (
    name LONGTEXT
);
```

## Binary

### `TINYBLOB`

The `TINYBLOB` data type is used to store variable-length binary data. The maximum length of this data type is 255 bytes.

```sql
CREATE TABLE users (
    photo TINYBLOB
);
```

### `BLOB`

The `BLOB` data type is used to store variable-length binary data. The maximum length of this data type is 65535 bytes.

```sql
CREATE TABLE users (
    photo BLOB
);
```

### `MEDIUMBLOB`

The `MEDIUMBLOB` data type is used to store variable-length binary data. The maximum length of this data type is 16777215 bytes.

```sql
CREATE TABLE users (
    photo MEDIUMBLOB
);
```

### `LONGBLOB`

The `LONGBLOB` data type is used to store variable-length binary data. The maximum length of this data type is 4294967295 bytes.

```sql
CREATE TABLE users (
    photo LONGBLOB
);
```

## Others

### `ENUM`

The `ENUM` data type is used to store a list of values. This data type can only store one of the values from the list.

```sql
CREATE TABLE users (
    gender ENUM('Male', 'Female')
);
```

### `SET`

The `SET` data type is used to store a list of values. This data type can store one or more values from the list.

```sql
CREATE TABLE users (
    gender SET('Male', 'Female')
);
```

### `JSON`

The `JSON` data type is used to store data in JSON format.

```sql
CREATE TABLE users (
    data JSON
);
```
