# Construyendo una base de datos a partir de un Modelo Relacional — Taller Mecánico Mikes Ltda.

Este proyecto corresponde a la actividad sumativa de la **Semana 8** de la asignatura **Modelamiento de Bases de Datos**
(PRY2204). Consiste en implementar en **Oracle Database** un modelo relacional normalizado, poblarlo con datos y
consultarlo mediante informes con `SELECT`.

## 🔧 Contexto del caso: Taller Mecánico Mikes Ltda.

Mikes Ltda. es un taller de mecánica multimarca con sucursales en distintas ciudades. Cada sucursal ofrece servicios
como cambio de aceite, revisión de frenos, desabolladura, diagnóstico de motores y mecánica general. Cada mantención
es atendida por un mecánico y se desglosa en uno o más servicios. Los clientes se clasifican en **estándar** y
**premium**.

La empresa tenía un modelo relacional entregado por una consultora, pero la base de datos nunca se implementó. Este
trabajo consiste en construirla a partir de ese modelo y generar reportes para el análisis de datos.

## 📋 Descripción

- **Caso 1:** creación de las 14 tablas con sus claves primarias, foráneas y columnas `IDENTITY`.
- **Caso 2:** modificación del modelo con `ALTER TABLE` (nueva clave primaria, restricciones `CHECK` y `UNIQUE`).
- **Caso 3:** creación de secuencias y poblamiento de las tablas con `INSERT`.
- **Caso 4:** generación de dos informes sobre los mecánicos usando `WHERE`, `ORDER BY` y la función `ROUND`.

## 🧩 Tablas del modelo

`PAIS`, `CIUDAD`, `SUCURSAL`, `MECANICO`, `SERVICIO`, `MANTENCION`, `DETALLE_SERVICIO`, `CLIENTE`, `ESTANDAR`,
`PREMIUM`, `TIPO_AUTOMOVIL`, `MARCA`, `MODELO` y `AUTOMOVIL` (14 tablas en total).

## 🛠️ Detalle por caso

### Caso 1 — Implementación del modelo
- Las tablas se crean desde las más fuertes a las más débiles, según la jerarquía de dependencia.
- Todas las restricciones tienen nombre representativo (PK, FK, CK, UN).
- `PAIS` usa `IDENTITY` que parte en 9 y avanza de 3 en 3.
- `MECANICO` usa `IDENTITY` que parte en 460 y avanza de 7 en 7, con relación recursiva (`cod_supervisor`).
- `CLIENTE` se especializa en `ESTANDAR` y `PREMIUM`.

### Caso 2 — Modificación del modelo
- Se elimina la columna derivada `costo_total` de `MANTENCION`.
- La PK de `MANTENCION` pasa a ser compuesta: `(num_mantencion, cod_sucursal)`, y se ajusta la FK en `DETALLE_SERVICIO`.
- `email` único en `CLIENTE` (opcional, pero no repetible).
- Dígito verificador (`dv`) solo 0-9 o K.
- Sueldo mínimo de $510.000 en `MECANICO`.
- Estados de mantención permitidos: Reserva, Ingresado, Entregado, Anulado.

### Caso 3 — Poblamiento
- `seq_servicio`: parte en 400 e incrementa de 2 en 2.
- `seq_ciudad`: parte en 165 e incrementa de 5 en 5.
- Se insertan datos en las tablas respetando el orden de dependencia y se confirma con `COMMIT`.

### Caso 4 — Recuperación de datos
- **Informe 1:** mecánicos con bono de jefatura nulo e impuesto menor a $40.000, mostrando el impuesto con una rebaja
  del 20% y el sueldo resultante. Orden: impuesto actual descendente y apellido paterno ascendente.
- **Informe 2:** mecánicos con sueldo entre $600.000 y $900.000, o sin supervisor, con un reajuste del 5% al sueldo.
  Orden: sueldo ascendente y nombre completo descendente.

## 📂 Modelo Relacional

<img width="1034" height="620" alt="Modelo Relacional" src="https://github.com/user-attachments/assets/8f20cd6c-01ba-4e71-bfcc-b6d3af24dc55" />


## 📂 Estructura del proyecto

```
proyecto/
├── README.md
├── PRY2204_Exp3_S8_Instrucciones_especificas.docx          # Enunciado de la actividad
├── images/
│   └── modelo-relacional.png                               # Diagrama del Modelo Relacional
└── sql/
    └── Semana_8_consulta_de_datos_a_traves_de_un_MR.sql    # Script: Casos 1 al 4
```

1. Ejecutar como `SYS` o `SYSTEM` el script que crea el usuario `PRY2204_S8`.
2. Crear la conexión `PRY2204_SEMANA8` en **Oracle SQL Developer** con ese usuario.
3. Abrir el script y ejecutarlo completo (F5), en el orden en que está escrito.
4. Si se necesita volver a empezar, descomentar la lista de `DROP` del inicio del script.
5. Revisar los resultados con los `SELECT` del final.

## 🧰 Herramientas utilizadas

- **Oracle SQL Developer** — escritura y ejecución del script.
- **Oracle Database** — motor de base de datos donde se validó el script.
- **GitHub** — repositorio de entrega del script.
