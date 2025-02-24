# Principios de SOLID

El curso se enfoca para practicar y aprender buenas practicas de programación.

## Index

- [Principios de SOLID](#principios-de-solid)
  - [Index](#index)
  - [Clean Code y la Deuda Técnica](#clean-code-y-la-deuda-técnica)
    - [Nombres de Variables: Pronunciables y Expresivos](#nombres-de-variables-pronunciables-y-expresivos)
    - [Nombres Según el Tipo de Dato](#nombres-según-el-tipo-de-dato)
    - [Consideraciones para Nombres de Clases](#consideraciones-para-nombres-de-clases)
    - [Nombres de Funciones: Argumentos y Parámetros](#nombres-de-funciones-argumentos-y-parámetros)
    - [Principio DRY](#principio-dry)
  - [Clean Code en Programación Orientada a Objetos y comentarios](#clean-code-en-programación-orientada-a-objetos-y-comentarios)
    - [Herencia Problemática](#herencia-problemática)
    - [Estructura Recomendada de una Clase](#estructura-recomendada-de-una-clase)
    - [Comentarios en el Código](#comentarios-en-el-código)
    - [Uniformidad en el Proyecto](#uniformidad-en-el-proyecto)
  - [Acrónimo STUPID](#acrónimo-stupid)
    - [CodeSmells STUPID](#codesmells-stupid)
      - [Singleton](#singleton)
      - [Acoplamiento y Cohesión](#acoplamiento-y-cohesión)
      - [Código No Probable](#código-no-probable)
      - [Optimización Prematura](#optimización-prematura)
      - [Nombres Poco Descriptivos](#nombres-poco-descriptivos)
      - [Duplicidad de Código](#duplicidad-de-código)
    - [Code Smells Honoríficos](#code-smells-honoríficos)
      - [Inflación de Código](#inflación-de-código)
      - [Obsesión Primitiva](#obsesión-primitiva)
      - [Lista Larga de Parámetros](#lista-larga-de-parámetros)
      - [Feature Envy](#feature-envy)
      - [Intimidad Inapropiada](#intimidad-inapropiada)
      - [Cadena de Mensajes](#cadena-de-mensajes)
      - [The Middleman](#the-middleman)
  - [Principios S.O.L.I.D](#principios-solid)
    - [Single Responsibility Principle (SRP)](#single-responsibility-principle-srp)
    - [Open/Closed Principle (OCP)](#openclosed-principle-ocp)
    - [Liskov Substitution Principle (LSP)](#liskov-substitution-principle-lsp)
    - [Interface Segregation Principle (ISP)](#interface-segregation-principle-isp)
    - [Dependency Inversion Principle (DIP)](#dependency-inversion-principle-dip)

## Clean Code y la Deuda Técnica

La **deuda técnica** se refiere a la acumulación de problemas en el código debido a decisiones que priorizan la rapidez sobre la calidad. Esto puede resultar en costos futuros en términos de tiempo y esfuerzo.

Existen cuatro tipos de deuda técnica, que aunque no es crucial memorizar, es útil conocer:

- **Imprudente**: Deuda originada por copiar y pegar código sin considerar su impacto.
- **Inadvertido**: Deuda causada por desconocimiento o falta de experiencia.
- **Prudente**: Deuda en la que se es consciente de las fallas técnicas, pero se decide aceptarlas por razones específicas.
- **Prudente Inadvertida**: Deuda creada por desconocer una falla técnica, a pesar de tener un código limpio en apariencia.

La deuda técnica se puede "pagar" mediante **refactorización** y mejora continua del código.

> **Clean Code** es un código que se escribe con la intención de que sea fácilmente entendible por otros desarrolladores.

### Nombres de Variables: Pronunciables y Expresivos

Los nombres de las variables deben ser claros y escritos en inglés, además de ser fácilmente pronunciables.

**Ejemplo de malas convenciones:**

- **Imprudente**: Deuda originada por copiar y pegar código sin considerar su impacto.
- **Inadvertido**: Deuda causada por desconocimiento o falta de experiencia.
- **Prudente**: Deuda en la que se es consciente de las fallas técnicas, pero se decide aceptarlas por razones específicas.
- **Prudente Inadvertida**: Deuda creada por desconocer una falla técnica, a pesar de tener un código limpio en apariencia.

**Ejemplo corregido:**

```javascript
const numberOfUnits = 53;
const tax = 0.15;
const category = "T-Shirt";
const birthDate = new Date();
```

Es importante ser expresivo con los nombres de las variables para que sean fáciles de leer tanto para el autor original como para futuros desarrolladores.

### Nombres Según el Tipo de Dato

Asegúrate de que los nombres de las variables reflejen el tipo de dato con el que trabajan. Esto facilita la lectura del código.

**Ejemplo de malas convenciones para arreglos:**

```javascript
const fruit = ["manzana", "uva", "banana"];
```

**Ejemplo corregido:**

```javascript
const fruitNames = ["manzana", "uva", "banana"];
```

**Ejemplo de malas convenciones para booleanos:**

```javascript
// Malo
const open = false;
const write = false;
const active = false;
const values = false;
const empty = false;
```

Los nombres booleanos deben indicar claramente su propósito utilizando prefijos como `is`, `can`, `no`, `not`.

**Ejemplo corregido:**

```javascript
// Bueno
const isOpen = false;
const canWrite = false;
const isActive = false;
const noValues = false;
const notEmpty = false;
```

**Ejemplo de malas convenciones para números:**

```javascript
// Malo
const cars = 2;
const fruits = 3;
```

Es preferible utilizar nombres que indiquen claramente el significado del número.

**Ejemplo corregido:**

```javascript
// Bueno
const maxCars = 3;
const totalFruits = 2;
```

**Ejemplo de malas convenciones para nombres de funciones:**

```javascript
// Malo
createUserIfNotExists();
updateUserIfNotEmpty();
sendEmailIfFieldsValid();
```

Los nombres de las funciones deben representar acciones y ser claros y concisos.

**Ejemplo corregido:**

```javascript
// Bueno
createUser();
updateUser();
sendEmail();
```

### Consideraciones para Nombres de Clases

Los nombres de las clases deben:

- Estar compuestos por sustantivos o frases de sustantivos.
- Evitar nombres genéricos.
- Usar **UpperCamelCase**.
- Evitar nombres excesivamente largos.

**Ejemplos de nombres genéricos:**

```javascript
class Manager {}
class Data {}
class Individual {}
class Processor {}
```

Las clases deben centrarse en representar entidades o tareas específicas, evitando una sobreabundancia de métodos.

### Nombres de Funciones: Argumentos y Parámetros

Recuerda:

> Sabemos que estamos desarrollando código limpio cuando cada función realiza exactamente lo que su nombre indica.

Una función debe:

- Tener una única responsabilidad.
- Evitar realizar múltiples tareas.
- Limitar el número de parámetros a tres.
- Ser simple y concisa.
- Tener un tamaño reducido (menos de 20 líneas de código).
- Evitar el uso de `else` y priorizar condiciones ternarias cuando sea posible.

**Ejemplo de una buena función:**

```typescript
interface SendEmailOptions {
  toWhom: string;
  from: string;
  body: string;
  subject: string;
  apiKey: string;
}

function sendEmail({ toWhom, from, body, subject, apiKey }: SendEmailOptions) {
  // Tarea para enviar un email.
}
```

### Principio DRY

El principio **DRY** (Don't Repeat Yourself) promueve la reducción de la redundancia en el código. Aplicar este principio ayuda a:

- Simplificar pruebas.
- Centralizar procesos.
- Refactorizar código.

Existen varias técnicas para implementar este principio, como crear clases o funciones reutilizables que encapsulen la lógica común.

## Clean Code en Programación Orientada a Objetos y comentarios

En la Programación Orientada a Objetos (POO), el **principio de responsabilidad única** es fundamental. Según este principio, cada clase debe tener una única responsabilidad o tarea, evitando que sea genérica o que asuma múltiples responsabilidades. Esto ayuda a mantener el código limpio, modular y fácil de entender.

### Herencia Problemática

La herencia es uno de los pilares de la POO, pero si no se gestiona correctamente, puede llevar a problemas serios y a una mala calidad del código. Un problema común es el **problema del diamante**, donde la herencia múltiple puede hacer que el código sea complicado y difícil de mantener.

Para evitar estos problemas:

1. **Aplica el Principio de Responsabilidad Única**: Asegúrate de que cada clase tenga una única responsabilidad y evita que las clases acumulen múltiples tareas.
2. **Evita la Herencia Profunda**: Las jerarquías de herencia profundas pueden hacer que el código sea difícil de comprender y mantener. Prefiere la composición sobre la herencia cuando sea posible.

**Ejemplo de malas convenciones para clases:**

```typescript
(() => {
    // No aplicando el principio de responsabilidad única

    type Gender = 'M' | 'F';

    class Person {
        constructor(
            public name: string, 
            public gender: Gender, 
            public birthdate: Date
        ) {}
    }

    class User extends Person {
        public lastAccess: Date;

        constructor(
            public email: string,
            public role: string,
            name: string,
            gender: Gender,
            birthdate: Date,
        ) {
            super(name, gender, birthdate);
            this.lastAccess = new Date();
        }

        checkCredentials() {
            return true;
        }
    }

    class UserSettings extends User {
        constructor(
            public workingDirectory: string,
            public lastOpenFolder: string,
            email: string,
            role: string,
            name: string,
            gender: Gender,
            birthdate: Date
        ) {
            super(email, role, name, gender, birthdate);
        }
    }

    const userSettings = new UserSettings(
        '/usr/home',
        '/home',
        'fernando@google.com',
        'Admin',
        'Fernando',
        'M',
        new Date('1985-10-21')
    );

    console.log({ userSettings });
})();
```

En el ejemplo anterior, la herencia profunda y la acumulación de responsabilidades hacen que el código sea complejo y difícil de entender.

**Ejemplo corregido:**

```typescript
(() => {
    // Aplicando el principio de responsabilidad única

    type Gender = 'M' | 'F';

    interface PersonProps {
        birthdate: Date;
        gender: Gender;
        name: string;
    }

    class Person {
        public birthdate: Date;
        public gender: Gender;
        public name: string;

        constructor({ name, gender, birthdate }: PersonProps) {
            this.name = name;
            this.gender = gender;
            this.birthdate = birthdate;
        }
    }

    interface UserProps {
        email: string;
        role: string;
    }

    class User {
        public email: string;
        public role: string;
        public lastAccess: Date;

        constructor({ email, role }: UserProps) {
            this.email = email;
            this.role = role;
            this.lastAccess = new Date();
        }

        checkCredentials() {
            return true;
        }
    }

    interface SettingsProps {
        lastOpenFolder: string;
        workingDirectory: string;
    }

    class Settings {
        public workingDirectory: string;
        public lastOpenFolder: string;

        constructor({ workingDirectory, lastOpenFolder }: SettingsProps) {
            this.workingDirectory = workingDirectory;
            this.lastOpenFolder = lastOpenFolder;
        }
    }

    interface UserSettingProps {
        birthdate: Date;
        email: string;
        gender: Gender;
        lastOpenFolder: string;
        name: string;
        role: string;
        workingDirectory: string;
    }

    class UserSetting {
        public person: Person;
        public user: User;
        public settings: Settings;

        constructor({
            birthdate,
            email,
            gender,
            lastOpenFolder,
            name,
            role,
            workingDirectory,
        }: UserSettingProps) {
            this.person = new Person({ name, gender, birthdate });
            this.user = new User({ email, role });
            this.settings = new Settings({ lastOpenFolder, workingDirectory });
        }
    }

})();
```

### Estructura Recomendada de una Clase

Seguir una estructura estándar para las clases es crucial para mantener un código organizado y fácil de entender. La estructura recomendada para una clase es la siguiente:

1. **Propiedades estáticas**: Define las propiedades que pertenecen a la clase en lugar de a una instancia específica.
2. **Propiedades públicas**: Incluye las propiedades accesibles desde fuera de la clase.
3. **Método constructor estático**: (Si es necesario) Define la lógica de inicialización estática.
4. **Método constructor**: Define cómo se inicializan las instancias de la clase.
5. **Métodos estáticos**: Incluye métodos que se pueden llamar sin necesidad de crear una instancia de la clase.
6. **Métodos privados**: Define métodos que solo deben ser utilizados dentro de la clase.
7. **Métodos de instancia**: Ordena los métodos de instancia de mayor a menor importancia.
8. **Getters y Setters**: Proporciona métodos para acceder y modificar las propiedades privadas.

### Comentarios en el Código

Los comentarios son útiles para aclarar partes del código que no son inmediatamente obvias. Sin embargo, un buen código debe ser autoexplicativo siempre que sea posible. Los comentarios deben ser utilizados principalmente para:

- **Explicar lógica compleja**: Cuando el código realiza operaciones no triviales o utiliza servicios externos, como APIs.
- **Documentar decisiones de diseño**: Cuando la lógica o estructura del código puede no ser evidente a simple vista.

> **No comentes el código mal escrito; reescríbelo.** Un buen código debería ser claro y legible por sí mismo, y los comentarios deben complementar, no reemplazar, una buena práctica de codificación.

### Uniformidad en el Proyecto

Mantener la uniformidad en un proyecto es esencial para facilitar la colaboración y el mantenimiento del código. La uniformidad incluye:

- **Estructura del proyecto**: Sigue una organización coherente en la estructura de archivos y carpetas.
- **Nombres de variables y funciones**: Utiliza convenciones de nombres consistentes y descriptivos.
- **Estilo de código**: Adopta un estilo de codificación uniforme en todo el proyecto, incluyendo la indentación, el espaciado y el formato.

La uniformidad ayuda a que el código sea más fácil de leer y entender, tanto para el autor original como para otros desarrolladores que colaboren en el proyecto. Un código bien organizado y consistente demuestra profesionalismo y facilita el trabajo en equipo.

## Acrónimo STUPID

El acrónimo **STUPID** representa un conjunto de antipatrones que deben evitarse para prevenir problemas comunes en el código, conocidos como **Code Smells**. Estos problemas indican que el código está mal implementado y necesita revisión y refactorización.

### CodeSmells STUPID

El acrónimo **STUPID** abarca seis **Code Smells** que son:

- **Singleton**: Patrón Singleton
- **Tight**: Alto Acoplamiento
- **Untestability**: Código no testeable
- **Premature Optimization**: Optimización prematura
- **Indescriptive Naming**: Nombres poco descriptivos
- **Duplication**: Duplicidad de código (viola el principio DRY)

#### Singleton

El patrón **Singleton** asegura que una clase tenga solo una instancia a lo largo de la aplicación. Aunque puede ser útil, puede llevar a varios problemas:

- **Contexto Global**: La instancia es accesible globalmente, lo que puede provocar efectos secundarios inesperados.
- **Modificabilidad**: La instancia global puede ser modificada desde cualquier parte del código, dificultando el control.
- **Dificultad para Rastreo**: La instancia global hace que sea difícil rastrear dónde y cómo se usa.
- **Dificultad para Testear**: Las pruebas unitarias pueden ser complicadas debido a la dependencia de una única instancia global.

#### Acoplamiento y Cohesión

**Acoplamiento** se refiere a la dependencia entre componentes o clases. Un alto acoplamiento significa que un cambio en una clase puede afectar a todas las clases relacionadas, creando un efecto dominó.

**Cohesión** se refiere a la medida en que una clase, componente o módulo realiza tareas relacionadas entre sí.

- **Baja Cohesión**: Significa que una clase realiza una variedad de tareas no relacionadas. Esto hace que la clase sea amplia y difícil de mantener.
- **Alta Cohesión**: Indica que una clase está enfocada en una única responsabilidad o propósito, haciendo que sea más manejable y fácil de entender.

El objetivo es lograr un **bajo acoplamiento** y **alta cohesión**. Esto significa diseñar componentes que sean auto-suficientes e independientes, con responsabilidades claramente definidas. Un alto acoplamiento y baja cohesión complican el mantenimiento y la evolución del código, ya que los cambios pueden requerir ajustes extensos en múltiples partes del sistema.

#### Código No Probable

El **código no probable** se refiere a aquel que es difícil de probar con pruebas unitarias. La capacidad de realizar pruebas unitarias es crucial para garantizar la integridad del código y detectar errores de manera temprana. Un código que no es testeable puede ocultar defectos y hacer que el mantenimiento sea mucho más complicado.

#### Optimización Prematura

La **optimización prematura** ocurre cuando se implementan mejoras y abstracciones innecesarias antes de que sean necesarias. Esto puede añadir complejidad accidental al código, en lugar de mejorar su rendimiento o estructura.

**Consejos para evitar la optimización prematura:**

- **Enfócate en los requisitos**: Desarrolla primero una solución funcional y clara antes de optimizar.
- **Mide el rendimiento**: Realiza pruebas de rendimiento y perfilado para identificar verdaderos cuellos de botella.
- **Evita la complejidad innecesaria**: Implementa abstracciones solo cuando sean necesarias y justifiquen su complejidad.

#### Nombres Poco Descriptivos

Los **nombres poco descriptivos** dificultan la comprensión del código y pueden llevar a errores y malentendidos. Asegúrate de que los nombres en tu código sean claros y representativos de su propósito.

**Errores comunes:**

- **Nombres de variables mal nombradas**: Utiliza nombres significativos y evita abreviaturas crípticas.
- **Nombres de clases genéricas**: Las clases deben tener nombres que reflejen claramente su propósito.
- **Nombres de funciones mal nombradas**: Los nombres de las funciones deben describir claramente la acción que realizan.
- **Ser demasiado específico o genérico**: Encuentra un equilibrio entre nombres demasiado específicos y demasiado generales.

#### Duplicidad de Código

La **duplicidad de código** ocurre cuando el mismo código se repite en múltiples lugares, lo que puede llevar a errores y mantenimiento complicado. Hay dos tipos principales de duplicidad:

**Duplicidad Real:**

- **Código idéntico**: Fragmentos de código que realizan exactamente la misma función y tienen la misma implementación.
- **Actualización propensa a errores**: Modificar el código en un lugar requiere actualizar todas las copias duplicadas, aumentando el riesgo de errores humanos.
- **Pruebas redundantes**: Las pruebas deben ser repetidas para cada instancia del código duplicado.

**Duplicidad Accidental:**

- **Código similar con funciones distintas**: Fragmentos de código que se parecen pero tienen diferencias en su propósito o comportamiento.
- **Cambios centralizados**: A pesar de que el código es similar, solo se necesita modificar una copia para reflejar el cambio.

**Estrategias para reducir la duplicidad:**

- **Aplicar el principio DRY (Don't Repeat Yourself)**: Refactoriza el código para eliminar duplicaciones y reutiliza funciones y clases comunes.
- **Crear funciones y clases reutilizables**: Extrae el código repetido en funciones o clases que puedan ser utilizadas en lugar de duplicar la lógica.

### Code Smells Honoríficos

#### Inflación de Código

La **inflación de código** se refiere a la tendencia a acumular demasiado código en una sola unidad (función o clase), lo que puede llevar a un diseño desorganizado y difícil de mantener.

- **Funciones Inflacionadas**: Funciones que realizan demasiadas tareas o contienen lógica excesiva. Deben ser refactorizadas en funciones más pequeñas y enfocadas.
  
  **Ejemplo:**

  ```typescript
  function processOrder(order) {
      // Validaciones, cálculos, actualización de base de datos, notificaciones, etc.
  }
  ```

- **Clases Inflacionadas**: Clases que manejan demasiadas responsabilidades o tienen una gran cantidad de métodos. Se deben dividir en clases más especializadas con responsabilidades claramente definidas.
  
  **Ejemplo:**

  ```typescript
  class OrderProcessor {
      processOrder(order) { /* ... */ }
      generateInvoice(order) { /* ... */ }
      sendNotification(order) { /* ... */ }
      updateDatabase(order) { /* ... */ }
      // Muchos más métodos...
  }
  ```

#### Obsesión Primitiva

La **obsesión primitiva** ocurre cuando se utilizan tipos primitivos (como `int`, `string`, `boolean`) en lugar de crear tipos de datos más específicos que encapsulen mejor la información.

- **Ejemplo**: Usar números para representar tipos de datos complejos como `Money` o `Address`.

  **Antes:**

  ```typescript
  function setAddress(street: string, city: string, zipCode: string) { /* ... */ }
  ```

  **Después:**

  ```typescript
  class Address {
      constructor(public street: string, public city: string, public zipCode: string) { /* ... */ }
  }
  ```

#### Lista Larga de Parámetros

Una **lista larga de parámetros** en una función o método puede ser difícil de manejar y leer. Generalmente indica que la función está haciendo demasiado o que los parámetros deberían ser encapsulados en un objeto.

- **Ejemplo:**

  ```typescript
  function createUser(name: string, age: number, email: string, address: string, phoneNumber: string) { /* ... */ }
  ```

  **Mejorado:**

  ```typescript
  interface UserDetails {
      name: string;
      age: number;
      email: string;
      address: string;
      phoneNumber: string;
  }

  function createUser(details: UserDetails) { /* ... */ }
  ```

#### Feature Envy

El **Feature Envy** ocurre cuando un método en una clase realiza muchas operaciones sobre otra clase, en lugar de operar sobre su propia clase. Esto indica que la lógica debería ser movida a la clase que posee los datos.

- **Ejemplo:**

  ```typescript
  class Order {
      calculateTotal() { /* ... */ }
  }

  class Invoice {
      printInvoice(order: Order) {
          const total = order.calculateTotal();
          // Genera el invoice usando el total
      }
  }
  ```

  **Mejorado:**

  ```typescript
  class Order {
      calculateTotal() { /* ... */ }
      generateInvoice() {
          const total = this.calculateTotal();
          // Genera el invoice usando el total
      }
  }
  ```

#### Intimidad Inapropiada

La **intimidad inapropiada** ocurre cuando una clase o módulo conoce demasiado sobre la implementación interna de otro. Esto puede violar el encapsulamiento y hacer que el código sea frágil y difícil de mantener.

- **Ejemplo:**

  ```typescript
  class Order {
      private items: Item[];
      public addItem(item: Item) { this.items.push(item); }
  }

  class Invoice {
      printInvoice(order: Order) {
          const items = order['items']; // Acceso inapropiado a detalles privados
          // Genera el invoice usando los items
      }
  }
  ```

  **Mejorado:**

  ```typescript
  class Order {
      private items: Item[] = [];
      public getItems() { return this.items; }
      public addItem(item: Item) { this.items.push(item); }
  }

  class Invoice {
      printInvoice(order: Order) {
          const items = order.getItems();
          // Genera el invoice usando los items
      }
  }
  ```

#### Cadena de Mensajes

La **cadena de mensajes** ocurre cuando un objeto pasa un mensaje a otro objeto, que a su vez pasa el mensaje a un tercer objeto, y así sucesivamente. Esto puede hacer que el código sea difícil de seguir y mantener.

- **Ejemplo:**

  ```typescript
  class A {
      getB() { return new B(); }
  }

  class B {
      getC() { return new C(); }
  }

  class C {
      doSomething() { /* ... */ }
  }

  const a = new A();
  a.getB().getC().doSomething();
  ```

  **Mejorado:**

  ```typescript
  class A {
      private b: B;
      constructor() { this.b = new B(); }
      performAction() { this.b.doSomething(); }
  }

  class B {
      private c: C;
      constructor() { this.c = new C(); }
      doSomething() { this.c.doSomething(); }
  }

  class C {
      doSomething() { /* ... */ }
  }

  const a = new A();
  a.performAction();
  ```

#### The Middleman

**The Middleman** ocurre cuando una clase actúa como intermediario que simplemente pasa mensajes entre otras clases, sin agregar valor propio. Esto puede hacer que la arquitectura sea más compleja de lo necesario.

- **Ejemplo:**

  ```typescript
  class A {
      private b: B;
      constructor() { this.b = new B(); }
      performAction() { this.b.doSomething(); }
  }

  class B {
      doSomething() { /* ... */ }
  }

  const a = new A();
  a.performAction();
  ```

  **Mejorado:**

  ```typescript
  class B {
      doSomething() { /* ... */ }
  }

  const b = new B();
  b.doSomething();
  ```

## Principios S.O.L.I.D

Los principios **S.O.L.I.D** son fundamentales para diseñar software que sea fácil de mantener y extender. Estos principios ayudan a organizar funciones y estructuras de datos en componentes modulares y bien definidos.

- **S**: Single Responsibility Principle (SRP)
- **O**: Open/Closed Principle (OCP)
- **L**: Liskov Substitution Principle (LSP)
- **I**: Interface Segregation Principle (ISP)
- **D**: Dependency Inversion Principle (DIP)

### Single Responsibility Principle (SRP)

El **Principio de Responsabilidad Única** establece que una clase o módulo debe tener solo una razón para cambiar, es decir, debe tener una única responsabilidad o tarea.

**Objetivo:**

- **Modularidad**: Cada módulo o clase debería encargarse de una sola parte del comportamiento del programa.
- **Mantenibilidad**: Si una clase tiene solo una responsabilidad, es más fácil de entender, mantener y modificar.

**Ejemplo:**

**Incorrecto:**

```typescript
class Report {
    public generateReport(data: any) { /* Genera el reporte */ }
    public saveToFile(fileName: string) { /* Guarda el archivo */ }
    public print() { /* Imprime el reporte */ }
}
```

**Mejorado:**

```typescript
class ReportGenerator {
    public generateReport(data: any) { /* Genera el reporte */ }
}

class ReportSaver {
    public saveToFile(report: any, fileName: string) { /* Guarda el archivo */ }
}

class ReportPrinter {
    public print(report: any) { /* Imprime el reporte */ }
}
```

### Open/Closed Principle (OCP)

El **Principio de Abierto/Cerrado** establece que las entidades de software (clases, módulos, métodos, etc.) deben estar abiertas para la extensión pero cerradas para la modificación.

**Objetivo:**

- **Extensibilidad**: Permite añadir nuevas funcionalidades sin modificar el código existente.
- **Estabilidad**: El código existente sigue funcionando mientras se añaden nuevas funcionalidades.

**Ejemplo:**

**Incorrecto:**

```typescript
class AreaCalculator {
    public calculateArea(shape: Shape): number {
        if (shape instanceof Rectangle) {
            return shape.width * shape.height;
        } else if (shape instanceof Circle) {
            return Math.PI * shape.radius * shape.radius;
        }
    }
}
```

**Mejorado:**

```typescript
interface Shape {
    calculateArea(): number;
}

class Rectangle implements Shape {
    constructor(public width: number, public height: number) {}
    public calculateArea(): number {
        return this.width * this.height;
    }
}

class Circle implements Shape {
    constructor(public radius: number) {}
    public calculateArea(): number {
        return Math.PI * this.radius * this.radius;
    }
}

class AreaCalculator {
    public calculateArea(shape: Shape): number {
        return shape.calculateArea();
    }
}
```

### Liskov Substitution Principle (LSP)

El **Principio de Sustitución de Liskov** establece que los objetos de una clase derivada deben ser capaces de reemplazar a objetos de la clase base sin que el comportamiento del programa se vea afectado negativamente. Es decir, las clases derivadas deben comportarse de manera coherente con las expectativas establecidas por la clase base.

**Objetivo:**

- **Sustitución sin efectos secundarios**: Una instancia de una subclase debe poder sustituir a una instancia de la clase base sin alterar la correcta funcionalidad del programa.
- **Consistencia de comportamiento**: Las clases derivadas deben adherirse al contrato de la clase base y no introducir comportamientos inesperados.

**Ejemplo Incorrecto:**

```typescript
class Bird {
    public fly() { /* Implementación de vuelo */ }
}

class Penguin extends Bird {
    public fly() { throw new Error('Penguins cannot fly'); }
}

function makeItFly(bird: Bird) {
    bird.fly(); // Esto fallará si el pájaro es un pingüino
}
```

En este ejemplo, `Penguin` extiende `Bird` y redefine el método `fly` para lanzar una excepción, lo que viola el contrato establecido por la clase base `Bird`. Esto hace que `Penguin` no pueda ser utilizado de manera intercambiable con `Bird` en la función `makeItFly`, causando un problema.

**Ejemplo Mejorado:**

```typescript
abstract class Bird {
    abstract move(): void;
}

class Sparrow extends Bird {
    public move() { /* Implementación de vuelo */ }
}

class Penguin extends Bird {
    public move() { /* Implementación de caminar */ }
}

function makeItMove(bird: Bird) {
    bird.move(); // Ahora funciona correctamente con cualquier tipo de Bird
}
```

En este ejemplo, hemos cambiado el método `fly` por `move`, que es más general y puede ser implementado de diferentes maneras por distintas clases derivadas (`Sparrow` y `Penguin`). Así, `Penguin` y `Sparrow` pueden ser utilizados intercambiablemente sin romper el contrato del método `move`, cumpliendo con el Principio de Sustitución de Liskov.

### Interface Segregation Principle (ISP)

El **Principio de Segregación de Interfaces** establece que los clientes no deben verse obligados a depender de interfaces que no utilizan. Las interfaces deben ser específicas para el cliente.

**Objetivo:**

- **Especialización**: Interfaces más pequeñas y específicas para clientes que las utilizan.
- **Reducción de acoplamiento**: Evita que las clases dependan de métodos que no necesitan.

**Ejemplo:**

**Incorrecto:**

```typescript
interface Worker {
    work(): void;
    eat(): void;
}

class Human implements Worker {
    public work() { /* Trabaja */ }
    public eat() { /* Come */ }
}

class Robot implements Worker {
    public work() { /* Trabaja */ }
    public eat() { /* Robots no comen */ }
}
```

**Mejorado:**

```typescript
interface Workable {
    work(): void;
}

interface Eatable {
    eat(): void;
}

class Human implements Workable, Eatable {
    public work() { /* Trabaja */ }
    public eat() { /* Come */ }
}

class Robot implements Workable {
    public work() { /* Trabaja */ }
}
```

### Dependency Inversion Principle (DIP)

El **Principio de Inversión de Dependencias** establece que las clases de alto nivel no deben depender de clases de bajo nivel, sino de abstracciones. Las abstracciones no deben depender de detalles; los detalles deben depender de las abstracciones.

**Objetivo:**

- **Desacoplamiento**: Las clases de alto nivel no deben estar directamente acopladas a las clases de bajo nivel.
- **Flexibilidad**: Facilita el cambio de implementaciones sin afectar a las clases que dependen de las abstracciones.

**Ejemplo:**

**Incorrecto:**

```typescript
class FileManager {
    public saveToFile(data: string) { /* Guarda en un archivo */ }
}

class ReportGenerator {
    private fileManager: FileManager;

    constructor() {
        this.fileManager = new FileManager();
    }

    public generateReport(data: string) {
        // Genera el reporte y lo guarda
        this.fileManager.saveToFile(data);
    }
}
```

**Mejorado:**

```typescript
interface Storage {
    save(data: string): void;
}

class FileManager implements Storage {
    public save(data: string) { /* Guarda en un archivo */ }
}

class ReportGenerator {
    private storage: Storage;

    constructor(storage: Storage) {
        this.storage = storage;
    }

    public generateReport(data: string) {
        // Genera el reporte y lo guarda
        this.storage.save(data);
    }
}
```
