# 👩‍💻 MySQL CLI

The MySQL Command-Line Interface (CLI) provides a powerful tool for interacting with MySQL databases directly from the terminal. This documentation outlines essential commands to switch from JavaScript to SQL syntax, connect to a database, and perform basic operations.

## Index

- [Enter the MySQL CLI](#enter-the-mysql-cli)
- [Switch from JS to SQL](#switch-from-js-to-sql)
- [Connect to the database](#connect-to-the-database)
- [Show databases](#show-databases)
- [Use a specific database](#use-a-specific-database)
- [Show tables in the current database](#show-tables-in-the-current-database)
- [Describe a table](#describe-a-table)

## Enter the MySQL CLI

To access the MySQL CLI, open a terminal window and execute the following command:

```bash
mysql -u root -p -h localhost
```

## Switch from JS to SQL

To switch from JavaScript to SQL mode within the MySQL CLI, use the following command:

```bash
\sql
```

This command enables SQL syntax for subsequent queries and commands.

## Connect to the database

To establish a connection to a MySQL database, use the following command:

```bash
\connect root@localhost
```

Here, `root` represents the username, and `localhost` indicates the server where the MySQL database is hosted. Replace `root` with the appropriate username and `localhost` with the correct server address if necessary.

## Show databases

To display a list of available databases on the connected MySQL server, execute the following command:

```bash
\show databases;
```

This command retrieves and lists all databases accessible by the current user.

## Use a specific database

Once connected to the MySQL server, you can switch to a specific database using the following command:

```bash
\use database_name;
```

Replace `database_name` with the name of the database you want to use.

## Show tables in the current database

To view the tables within the currently selected database, use the following command:

```bash
\show tables;
```

This command lists all tables present in the active database.

## Describe a table

To retrieve information about the structure of a specific table, use the following command:

```bash
\describe table_name;
```

Replace `table_name` with the name of the table you want to describe. This command provides details such as column names, data types, and any constraints applied to the table.
