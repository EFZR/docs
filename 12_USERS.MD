# Users

In MySQL, users are accounts that can connect to the database server and perform various operations such as querying data, modifying data, and managing database objects. Users can be granted different privileges to control their access to databases and tables.

## Index

- [Create a new user](#create-a-new-user)
- [Grant privileges to a user](#grant-privileges-to-a-user)
- [Grant privileges to a user with a specific role](#grant-privileges-to-a-user-with-a-specific-role)
- [Revoke privileges from a user](#revoke-privileges-from-a-user)
- [Refresh privileges](#refresh-privileges)
- [Change a user's password](#change-a-users-password)
- [Type of privileges](#type-of-privileges)
- [List users](#list-users)
- [Delete a user](#delete-a-user)

## Create a new user

To create a new user in MySQL, you can use the `CREATE USER` statement. The following example demonstrates how to create a new user named `john` with the password `password123`:

```sql
CREATE USER 'john'@'localhost' IDENTIFIED BY 'password123';
```

## Grant privileges to a user

After creating a user, you can grant specific privileges to the user using the `GRANT` statement. The following example grants all privileges on the `mydatabase` database to the user `john`:

```sql
GRANT ALL PRIVILEGES ON mydatabase.* TO 'john'@'localhost';
```

## Grant privileges to a user with a specific role

You can also grant privileges to a user using a specific role. The following example demonstrates how to grant the `SELECT` privilege on the `mytable` table to the user `john` using the `readonly` role:

```sql
GRANT SELECT ON mydatabase.mytable TO 'john'@'localhost' WITH ROLE readonly;
```

## Revoke privileges from a user

To revoke privileges from a user in MySQL, you can use the `REVOKE` statement. The following example demonstrates how to revoke all privileges on the `mydatabase` database from the user `john`:

```sql
REVOKE ALL PRIVILEGES ON mydatabase.* FROM 'john'@'localhost';
```

## Refresh privileges

After granting or revoking privileges from a user, you need to refresh the privileges to apply the changes. You can do this by executing the `FLUSH PRIVILEGES` statement:

```sql
FLUSH PRIVILEGES;
```

## Change a user's password

To change a user's password in MySQL, you can use the `ALTER USER` statement. The following example demonstrates how to change the password for the user `john` to `newpassword123`:

```sql
ALTER USER 'john'@'localhost' IDENTIFIED BY 'newpassword123';
```

## Type of privileges

MySQL supports various types of privileges that can be granted to users. Some of the common privileges include:

- `SELECT`: Allows the user to read data from a database.
- `INSERT`: Allows the user to insert data into a database.
- `UPDATE`: Allows the user to modify data in a database.
- `DELETE`: Allows the user to delete data from a database.
- `CREATE`: Allows the user to create new databases and tables.
- `DROP`: Allows the user to delete databases and tables.
- `ALL PRIVILEGES`: Grants all privileges on a database or table.

## List users

To view a list of users in MySQL, you can query the `mysql.user` table. The following example demonstrates how to retrieve a list of users:

```sql
SELECT User, Host FROM mysql.user;
```

This query will return a list of users along with their corresponding hostnames.

## Delete a user

To delete a user in MySQL, you can use the `DROP USER` statement. The following example demonstrates how to delete the user `john

```sql
DROP USER 'john'@'localhost';
```
