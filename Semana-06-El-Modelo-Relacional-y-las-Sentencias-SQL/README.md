# Implementando un Modelo Relacional con Sentencias SQL — Consultorio Médico Santa Gema

Este proyecto corresponde a la actividad formativa **"Implementando un Modelo Relacional con Sentencias SQL"** de
la asignatura **Modelamiento de Bases de Datos**. Consiste en tomar un Modelo Entidad-Relación (MER) conceptual,
entregado incompleto respecto a las reglas de negocio, completarlo, y luego **implementarlo físicamente en Oracle
Database** mediante un script **DDL**: creación de tablas, claves primarias, claves foráneas, restricciones y
modificaciones posteriores con `ALTER TABLE`.

## 📋 Descripción

- Análisis del caso de negocio del **Consultorio Médico de la Municipalidad de Santa Gema**.
- Revisión del modelo relacional entregado (Figura 1 del enunciado) contra las reglas de negocio, identificando
  tablas, columnas y relaciones faltantes.
- Completado del modelo con las entidades de catálogo necesarias (ubicación geográfica, especialidad médica, tipo
  de receta, tipo de medicamento, vía de administración).
- Implementación del **Caso 1**: creación de tablas, llaves primarias, llaves foráneas y restricciones (`CHECK`,
  `UNIQUE`, `IDENTITY`) mediante script DDL en Oracle SQL.
- Implementación del **Caso 2**: modificaciones sobre el modelo ya creado mediante sentencias `ALTER TABLE`
  (nueva columna con restricción de rango, restricción de valores permitidos, reemplazo de columna).
- Validación del script ejecutándolo en una base **Oracle Database XE** local, sin errores.
- Modelado y diagrama relacional generados con **Oracle SQL Developer Data Modeler**.

## 🏥 Contexto del caso: Consultorio Médico Santa Gema

La Municipalidad de Santa Gema requiere una base de datos para digitalizar el registro de recetas médicas emitidas
en su consultorio: pacientes, médicos, medicamentos, diagnósticos, digitadores encargados de ingresar las recetas
al sistema, y los pagos asociados a cada receta.

Se entregó un modelo relacional de partida (ver Figura 1 del enunciado), pero incompleto: no representaba todas
las reglas de negocio del caso, por lo que el primer paso del trabajo fue completarlo antes de generar el script.

### Reglas de negocio

- Cada receta tiene un solo diagnóstico, uno o más medicamentos asociados, y un tipo (digital, magistral,
  retenida, general o veterinaria).
- Las recetas son ingresadas al sistema por un digitador.
- La receta registra fecha de emisión, observaciones y, cuando corresponde, fecha de vencimiento o duración del
  tratamiento.
- Del paciente se registra su domicilio completo: calle, comuna, ciudad y región.
- Los medicamentos tienen un identificador único, nombre, dosis recomendada, stock y tipo (genérico o de marca).
- Una receta puede tener uno o más pagos asociados, cada uno con su monto y fecha.
- La tabla `ESPECIALIDAD` usa un identificador autoincremental (`IDENTITY`).
- La tabla `COMUNA` usa un identificador autoincremental que parte en **1101** e incrementa de 1 en 1.
- El teléfono del médico es único (`UNIQUE`).
- El dígito verificador de pacientes, médicos y digitadores solo admite los valores 0-9 o K (`CHECK`).

## 🧩 Modelo y notación utilizada

| Modelo | Notación | Herramienta |
|--------|----------|-------------|
| Modelo Relacional (MR) completado | Bachman / Ingeniería de la Información (tablas físicas, PK y FK nombradas) | Oracle SQL Developer Data Modeler |
| Script de creación y modificación de tablas | DDL Oracle SQL | Oracle Database XE (local) |

## 🔗 Modelo Relacional (MR) — Notación Bachman / Ingeniería de la Información

Diagrama generado por ingeniería inversa en **Oracle SQL Developer Data Modeler**, a partir de las 16 tablas ya
creadas en la base de datos, con sus claves primarias, foráneas y restricciones.

<img width="1887" height="1004" alt="modelo-relacional-consultorio-santa-gema png" src="https://github.com/user-attachments/assets/a8cf89a9-3410-4484-ac9d-9ac3801264af" />


*Tablas generadas:* `REGION`, `CIUDAD`, `COMUNA`, `ESPECIALIDAD`, `TIPO_RECETA`, `TIPO_MEDICAMENTO`,
`VIA_ADMINISTRACION`, `DIAGNOSTICO`, `BANCO`, `DIGITADOR`, `MEDICO`, `PACIENTE`, `MEDICAMENTO`, `RECETA`, `DOSIS`
y `PAGO` (16 tablas en total).

## 🛠️ Script DDL (extracto)

El script completo se encuentra en `sql/PRY2204_EXP3_S6_DDL.sql`. Ejemplo de la creación de una tabla, su clave
primaria y una modificación posterior con `ALTER TABLE`:

```sql
CREATE TABLE medico (
    rut_med         NUMBER(8)    NOT NULL,
    dv_med          CHAR(1)      NOT NULL,
    pnombre         VARCHAR2(25) NOT NULL,
    papellido       VARCHAR2(25) NOT NULL,
    telefono        NUMBER(11)   NOT NULL,
    id_especialidad NUMBER(3)    NOT NULL,
    CONSTRAINT medico_dv_ck CHECK (dv_med IN ('0','1','2','3','4','5','6','7','8','9','K')),
    CONSTRAINT medico_telefono_uk UNIQUE (telefono)
);

ALTER TABLE medico ADD CONSTRAINT medico_pk PRIMARY KEY (rut_med);

ALTER TABLE medico ADD CONSTRAINT medico_especialidad_fk
    FOREIGN KEY (id_especialidad) REFERENCES especialidad (id_especialidad);

-- Caso 2: restricción de precio agregada sobre medicamento
ALTER TABLE medicamento ADD precio_unitario NUMBER(7) NOT NULL;
ALTER TABLE medicamento ADD CONSTRAINT medicamento_precio_ck
    CHECK (precio_unitario BETWEEN 1000 AND 2000000);
```

> Script ejecutado sin errores en Oracle XE: **16 CREATE TABLE**, **16 PRIMARY KEY**, **15 FOREIGN KEY**,
> **5 modificaciones `ALTER TABLE`** del Caso 2.

## 📂 Estructura del proyecto

```
proyecto/
├── README.md
├── images/
│   └── modelo-relacional-consultorio-santa-gema.png   # Diagrama MR exportado desde Data Modeler
└── sql/
    ├── PRY2204_EXP3_S6_DDL.sql                         # Script DDL: Caso 1 y Caso 2
    └── PRY2204_EXP3_S6_Instrucciones_especificas.docx  # Enunciado de la actividad de la semana
```

## ▶️ Flujo de trabajo

1. Se revisa el modelo relacional entregado (Figura 1 del enunciado) contra las reglas de negocio del caso,
   detectando tablas, columnas y relaciones que faltaban.
2. Se completa el modelo agregando las tablas de catálogo (`REGION`, `CIUDAD`, `COMUNA`, `ESPECIALIDAD`,
   `TIPO_RECETA`, `TIPO_MEDICAMENTO`, `VIA_ADMINISTRACION`) y las columnas y llaves foráneas faltantes.
3. Se escribe el script DDL del **Caso 1**: eliminación de objetos, creación de tablas, llaves primarias, llaves
   foráneas y restricciones (`CHECK`, `UNIQUE`, `IDENTITY`).
4. Se agregan al mismo script las modificaciones del **Caso 2** mediante `ALTER TABLE`.
5. Se ejecuta el script completo en una conexión a **Oracle Database XE** local, verificando que las 16 tablas y
   las restricciones queden creadas sin errores.
6. Se genera el **diagrama del Modelo Relacional** en Oracle SQL Developer Data Modeler mediante ingeniería
   inversa sobre el esquema ya creado, y se exporta como imagen.
7. Se sube el script `.sql` sin comprimir al repositorio de GitHub, junto con el documento de instrucciones de la
   semana, y se entrega el `.sql` junto con el enlace del repositorio en el aula virtual.

## 🧰 Herramientas utilizadas

- **Oracle SQL Developer** — escritura y ejecución del script DDL.
- **Oracle SQL Developer Data Modeler** — generación del diagrama del Modelo Relacional por ingeniería inversa.
- **Oracle Database XE** — motor de base de datos local donde se validó el script.
- **GitHub** — repositorio de entrega del script y la evidencia del trabajo.

