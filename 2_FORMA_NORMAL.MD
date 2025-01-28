# Forma Normal

La forma normal en base de datos es una serie de reglas que se deben cumplir para evitar la redundancia de datos y la inconsistencia de los mismos.

## `Primera Forma Normal`

Principios de la primera forma normal:

- Cada tabla debe tener una clave primaria, que es un indice que identifica univocamente cada registro de la tabla.
- No se permiten grupos repetitivos de datos.
- Columna con valores atomicos, esto se refiere que cada columna debe tener un solo valor y no valores compuestos.
- Columna con un solo valor por fila.

## `Segunda Forma Normal`

La segunda forma Normal nos dice que debemos eliminar dependencia parcial de los datos, es decir, que cada columna de la tabla debe depender de la clave primaria. Una manera de representar esto es que si tenemos una tabla de cliente, no debemos de tener una columna que se llame "nombre del departamento" ya que esto es una dependencia parcial, ya que el nombre del departamento depende del id del departamento y no del nombre del cliente, en estos casos se crea otra tabla maestra para el departamento y se relaciona con la tabla de clientes.

## `Tercera Forma Normal`

La tercera forma normal nos dice que debemos eliminar dependencia transitiva de los datos, es decir, que cada columna de la tabla debe depender de la clave primaria y no de otra columna. por ejemplo si tenemos una tabla en dondes se muestran los datos de empleado, no deberiamos tener datos del jefe del empleado, ya que esto es una dependencia transitiva, ya que el jefe del empleado depende del id del jefe y no del id del empleado, en estos casos se crea otra tabla maestra para el jefe y se relaciona con la tabla de empleados o se crea una tabla de departamentos y se relacion a traves de una llave foranea los datos del jefe.
