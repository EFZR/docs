# JSON in MySql

In MySql, JSON is a data type that stores JSON (JavaScript Object Notation) data. JSON is a lightweight data interchange format that is easy for humans to read and write and easy for machines to parse and generate. JSON data can be stored in a column of a table using the `JSON` data type.

The `JSON` data type in MySQL makes flexible schema design possible, as it allows you to store data in a structured format without the need to define a fixed schema. This can be useful when working with data that has varying attributes or when you want to store data that does not fit neatly into a traditional relational database schema.

## Index 📇

- [JSON Data Type](#json-data-type)
- [Insert JSON Data](#insert-json-data)
- [Query JSON Data](#query-json-data)
- [Query JSON Data with `JSON_EXTRACT`](#query-json-data-with-json_extract)
- [Update JSON Data](#update-json-data)
- [JSON Functions](#json-functions)

## JSON Data Type

To define a column with the `JSON` data type in MySQL, you can use the following syntax:

```sql
CREATE TABLE example (
    id INT PRIMARY KEY,
    data JSON
);
```

In this example, the `data` column is defined with the `JSON` data type. This column can store JSON data, which can be retrieved and manipulated using JSON functions provided by MySQL.

## Insert JSON Data

To insert JSON data into a column of the `JSON` data type, you can use the following syntax:

```sql
INSERT INTO example (id, data)
VALUES (1, '{"name": "John", "age": 30}');
```

The JSON data can be inserted as a string literal, enclosed in single quotes. When you retrieve the data, you can use JSON functions to extract and manipulate the JSON data.

## Query JSON Data

MySQL provides a set of functions that allow you to query and manipulate JSON, but before using these functions could be convenient to learn how to retrive some info without using them.

To retrieve the JSON data stored in a column, you can use a simple `SELECT` statement:

```sql
SELECT data -> '$.name' AS name
FROM example
WHERE id = 1;
```

In this example, the `->` operator is used to extract the value of the `name` key from the JSON data stored in the `data` column. The result of this query will be the value associated with the `name` key.

## Query JSON Data with `JSON_EXTRACT`

The `JSON_EXTRACT` function can be used to extract a value from a JSON document based on a JSON path expression. Here's an example of how to use `JSON_EXTRACT` to retrieve data from a JSON column:

```sql
SELECT JSON_EXTRACT(data, '$.name') AS name
FROM example
WHERE id = 1;
```

In this example, the `JSON_EXTRACT` function is used to extract the value of the `name` key from the JSON data stored in the `data` column. The result of this query will be the value associated with the `name` key.

## Update JSON Data

To update JSON data in a column, you can use the `JSON_REPLACE` function or `JSON_SET` to modify specific keys or values within the JSON data:

```sql
UPDATE example
SET data = JSON_REPLACE(data, '$.age', 31)
WHERE id = 1;
```

In this example, the `JSON_REPLACE` function is used to update the value associated with the `age` key in the JSON data stored in the `data` column. The value is changed from `30` to `31`.

```sql
UPDATE example
SET data = JSON_SET(data, '$.city', 'New York')
WHERE id = 1;
```

In this example, the `JSON_SET` function is used to add a new key-value pair (`city: New York`) to the JSON data stored in the `data` column.

The main difference between `JSON_REPLACE` and `JSON_SET` is that `JSON_REPLACE` only updates the value of an existing key, while `JSON_SET` can add a new key-value pair if it does not already exist.

## JSON Functions

MySQL provides a set of functions that allow you to query and manipulate JSON data. Some of the most commonly used JSON functions in MySQL include:

- `JSON_EXTRACT`: Extracts a value from a JSON document based on a JSON path expression.
- `JSON_UNQUOTE`: Removes quotation marks from a JSON string.
- `JSON_SEARCH`: Searches a JSON document for a specified value and returns the path to that value.
- `JSON_CONTAINS`: Checks whether a JSON document contains a specified value.
- `JSON_OBJECT`: Creates a JSON object from a list of key-value pairs.
- `JSON_ARRAY`: Creates a JSON array from a list of values.
- `JSON_MERGE`: Merges two or more JSON documents into a single JSON document.
- `JSON_VALID`: Checks whether a string is a valid JSON document.
- `JSON_REMOVE`: Removes a specified key or value from a JSON document.
