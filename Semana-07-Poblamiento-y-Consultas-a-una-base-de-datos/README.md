# Poblamiento y consultas en una base de datos con SQL

Actividad formativa de la **Semana 7** de la asignatura **Modelamiento de Bases de Datos** (PRY2204).
Consiste en crear una base de datos en **Oracle**, poblarla con datos usando secuencias y consultarla con informes
básicos mediante `SELECT`.

**Integrantes:** Giovanni Mena y Claudio Fuentes

## 📋 ¿Qué se hizo?

- **Caso 1:** creación de las 10 tablas con sus claves primarias y foráneas (incluidas las claves compuestas) y columnas `IDENTITY`.
- **Caso 2:** modificación del modelo con `ALTER TABLE` (restricciones `UNIQUE` y `CHECK`).
- **Caso 3:** creación de secuencias y poblamiento de las tablas con `INSERT`, confirmado con `COMMIT`.
- **Caso 4:** generación de dos informes sobre las compañías usando `ORDER BY` y expresiones matemáticas.

## 🧩 Tablas del modelo

`ESTADO_CIVIL`, `GENERO`, `TITULO`, `IDIOMA`, `REGION`, `COMUNA`, `COMPANIA`, `PERSONAL`, `TITULACION` y `DOMINIO`
(10 tablas en total).

## 🛠️ Detalle por caso

### Caso 1: Creación de tablas
- Las tablas se crean desde las más independientes a las más dependientes.
- `IDIOMA` usa `IDENTITY` que parte en 25 y avanza de 3 en 3.
- `REGION` usa `IDENTITY` que parte en 7 y avanza de 2 en 2.
- `COMUNA` tiene clave primaria compuesta `(id_comuna, cod_region)`.
- `PERSONAL` tiene una relación recursiva (`encargado_rut`) y se relaciona con compañía, comuna, género y estado civil.
- `TITULACION` y `DOMINIO` son tablas intermedias con clave primaria compuesta.

### Caso 2: Modificación del modelo
- `email` único en `PERSONAL`.
- Dígito verificador (`dv_persona`) solo de 0 a 9 o K.
- Sueldo mínimo de $450.000 en `PERSONAL`.

### Caso 3: Poblamiento
- `seq_comuna`: parte en 1101 e incrementa de 6 en 6.
- `seq_compania`: parte en 10 e incrementa de 5 en 5.
- Se pueblan `REGION`, `IDIOMA`, `COMUNA` y `COMPANIA` respetando el orden de dependencia.
- Los datos se confirman con `COMMIT` al final de los inserts.

### Caso 4: Recuperación de datos
- **Informe 1:** nombre, dirección y renta promedio de cada compañía, junto con una simulación de renta aplicando su
  porcentaje de aumento. Orden: renta promedio descendente y nombre ascendente.
- **Informe 2:** código, nombre y renta actual de cada compañía, con el porcentaje de aumento incrementado en 15% y la
  renta resultante. Orden: renta promedio ascendente y nombre descendente.
- Las compañías sin porcentaje de aumento (`NULL`) muestran valores vacíos en las columnas calculadas.

## 📂 Estructura del proyecto

```
proyecto/
├── README.md                                                                                # Presentación del proyecto en repositorio 
├── PRY2204_Exp3_S7_Guía_aprendizaje_El_Modelo_Relacional_y_Sentencias_SQL.docx              # Archivo correspondiente a la actividad de la semana 7
└── sql/
    └── script_semana_7.sql                                                                  # Script: Casos 1 al 4
```

## ▶️ Cómo ejecutar

1. Abrir una conexión en **Oracle SQL Developer**.
2. Abrir el script y ejecutarlo completo (F5), en el orden en que está escrito.
3. Revisar los resultados de los dos informes al final del script.

## 🧰 Herramientas utilizadas

- **Oracle SQL Developer** — escritura y ejecución del script.
- **Oracle Database** — motor de base de datos.
- **GitHub** — repositorio de entrega.
