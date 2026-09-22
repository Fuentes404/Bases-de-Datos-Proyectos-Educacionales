-- 1 - Eliminacion de tablas
DROP TABLE dosis CASCADE CONSTRAINTS PURGE;
DROP TABLE pago CASCADE CONSTRAINTS PURGE;
DROP TABLE receta CASCADE CONSTRAINTS PURGE;
DROP TABLE medicamento CASCADE CONSTRAINTS PURGE;
DROP TABLE paciente CASCADE CONSTRAINTS PURGE;
DROP TABLE medico CASCADE CONSTRAINTS PURGE;
DROP TABLE digitador CASCADE CONSTRAINTS PURGE;
DROP TABLE banco CASCADE CONSTRAINTS PURGE;
DROP TABLE diagnostico CASCADE CONSTRAINTS PURGE;
DROP TABLE tipo_receta CASCADE CONSTRAINTS PURGE;
DROP TABLE via_administracion CASCADE CONSTRAINTS PURGE;
DROP TABLE tipo_medicamento CASCADE CONSTRAINTS PURGE;
DROP TABLE especialidad CASCADE CONSTRAINTS PURGE;
DROP TABLE comuna CASCADE CONSTRAINTS PURGE;
DROP TABLE ciudad CASCADE CONSTRAINTS PURGE;
DROP TABLE region CASCADE CONSTRAINTS PURGE;


-- 2 - Creacion de tablas
CREATE TABLE region (
    id_region NUMBER(5)    NOT NULL,
    nombre    VARCHAR2(50) NOT NULL
);

CREATE TABLE ciudad (
    id_ciudad NUMBER(5)    NOT NULL,
    nombre    VARCHAR2(50) NOT NULL,
    id_region NUMBER(5)    NOT NULL
);

CREATE TABLE comuna (
    id_comuna NUMBER(5) GENERATED ALWAYS AS IDENTITY (START WITH 1101 INCREMENT BY 1) NOT NULL,
    nombre    VARCHAR2(50) NOT NULL,
    id_ciudad NUMBER(5)    NOT NULL
);

CREATE TABLE especialidad (
    id_especialidad NUMBER(3) GENERATED ALWAYS AS IDENTITY NOT NULL,
    nombre          VARCHAR2(50) NOT NULL
);

CREATE TABLE tipo_receta (
    id_tipo_receta NUMBER(3)    NOT NULL,
    nombre         VARCHAR2(25) NOT NULL
);

CREATE TABLE tipo_medicamento (
    id_tipo_medicamento NUMBER(3)    NOT NULL,
    nombre              VARCHAR2(25) NOT NULL
);

CREATE TABLE via_administracion (
    id_via_administracion NUMBER(3)    NOT NULL,
    nombre                VARCHAR2(25) NOT NULL
);

CREATE TABLE diagnostico (
    cod_diagnostico NUMBER(3)    NOT NULL,
    nombre          VARCHAR2(25) NOT NULL
);

CREATE TABLE banco (
    cod_banco NUMBER(2)    NOT NULL,
    nombre    VARCHAR2(25) NOT NULL
);

CREATE TABLE digitador (
    id_digitador NUMBER(20)   NOT NULL,
    dv_digitador CHAR(1)      NOT NULL,
    pnombre      VARCHAR2(25) NOT NULL,
    papellido    VARCHAR2(25) NOT NULL,
    CONSTRAINT digitador_dv_ck CHECK (dv_digitador IN ('0','1','2','3','4','5','6','7','8','9','K'))
);

CREATE TABLE medico (
    rut_med         NUMBER(8)    NOT NULL,
    dv_med          CHAR(1)      NOT NULL,
    pnombre         VARCHAR2(25) NOT NULL,
    snombre         VARCHAR2(25),
    papellido       VARCHAR2(25) NOT NULL,
    sapellido       VARCHAR2(25),
    telefono        NUMBER(11)   NOT NULL,
    id_especialidad NUMBER(3)    NOT NULL,
    CONSTRAINT medico_dv_ck CHECK (dv_med IN ('0','1','2','3','4','5','6','7','8','9','K')),
    CONSTRAINT medico_telefono_uk UNIQUE (telefono)
);

CREATE TABLE paciente (
    rut_pac    VARCHAR2(25) NOT NULL,
    dv_pac     CHAR(1)      NOT NULL,
    pnombre    VARCHAR2(25) NOT NULL,
    snombre    VARCHAR2(25),
    papellido  VARCHAR2(25) NOT NULL,
    sapellido  VARCHAR2(25),
    edad       NUMBER(3)    NOT NULL,
    telefono   NUMBER(11)   NOT NULL,
    calle      VARCHAR2(25) NOT NULL,
    numeracion NUMBER(5)    NOT NULL,
    id_comuna  NUMBER(5)    NOT NULL,
    CONSTRAINT paciente_dv_ck CHECK (dv_pac IN ('0','1','2','3','4','5','6','7','8','9','K'))
);

CREATE TABLE medicamento (
    cod_medicamento       NUMBER(7)    NOT NULL,
    nombre                VARCHAR2(25) NOT NULL,
    dosis_recomendada     VARCHAR2(50) NOT NULL,
    stock                 NUMBER(6)    NOT NULL,
    id_tipo_medicamento   NUMBER(3)    NOT NULL,
    id_via_administracion NUMBER(3)    NOT NULL
);

CREATE TABLE receta (
    cod_receta        NUMBER(7)     NOT NULL,
    observaciones     VARCHAR2(500),
    fecha_emision     DATE          NOT NULL,
    fecha_vencimiento DATE,
    id_digitador      NUMBER(20)    NOT NULL,
    pac_rut           VARCHAR2(25)  NOT NULL,
    id_diagnostico    NUMBER(3)     NOT NULL,
    med_rut           NUMBER(8)     NOT NULL,
    id_tipo_receta    NUMBER(3)     NOT NULL
);

CREATE TABLE dosis (
    id_medicamento       NUMBER(7)    NOT NULL,
    id_receta            NUMBER(7)    NOT NULL,
    descripcion_dosis    VARCHAR2(25) NOT NULL,
    unidades_medicamento NUMBER(4)    NOT NULL,
    dias_tratamiento     NUMBER(3)    NOT NULL
);

CREATE TABLE pago (
    cod_boleta  NUMBER(6)    NOT NULL,
    id_receta   NUMBER(7)    NOT NULL,
    fecha_pago  DATE         NOT NULL,
    monto_total NUMBER(8)    NOT NULL,
    metodo_pago VARCHAR2(15) NOT NULL,
    id_banco    NUMBER(2)
);


-- 3 - Llaves primarias
ALTER TABLE region             ADD CONSTRAINT region_pk             PRIMARY KEY (id_region);
ALTER TABLE ciudad             ADD CONSTRAINT ciudad_pk             PRIMARY KEY (id_ciudad);
ALTER TABLE comuna             ADD CONSTRAINT comuna_pk             PRIMARY KEY (id_comuna);
ALTER TABLE especialidad       ADD CONSTRAINT especialidad_pk       PRIMARY KEY (id_especialidad);
ALTER TABLE tipo_receta        ADD CONSTRAINT tipo_receta_pk        PRIMARY KEY (id_tipo_receta);
ALTER TABLE tipo_medicamento   ADD CONSTRAINT tipo_medicamento_pk   PRIMARY KEY (id_tipo_medicamento);
ALTER TABLE via_administracion ADD CONSTRAINT via_administracion_pk PRIMARY KEY (id_via_administracion);
ALTER TABLE diagnostico        ADD CONSTRAINT diagnostico_pk        PRIMARY KEY (cod_diagnostico);
ALTER TABLE banco              ADD CONSTRAINT banco_pk              PRIMARY KEY (cod_banco);
ALTER TABLE digitador          ADD CONSTRAINT digitador_pk          PRIMARY KEY (id_digitador);
ALTER TABLE medico             ADD CONSTRAINT medico_pk             PRIMARY KEY (rut_med);
ALTER TABLE paciente           ADD CONSTRAINT paciente_pk           PRIMARY KEY (rut_pac);
ALTER TABLE medicamento        ADD CONSTRAINT medicamento_pk        PRIMARY KEY (cod_medicamento);
ALTER TABLE receta             ADD CONSTRAINT receta_pk             PRIMARY KEY (cod_receta);
ALTER TABLE dosis              ADD CONSTRAINT dosis_pk              PRIMARY KEY (id_medicamento, id_receta);
ALTER TABLE pago               ADD CONSTRAINT boleta_pk             PRIMARY KEY (cod_boleta);


-- 4 - Llaves foraneas
ALTER TABLE ciudad      ADD CONSTRAINT ciudad_region_fk
    FOREIGN KEY (id_region) REFERENCES region (id_region);

ALTER TABLE comuna      ADD CONSTRAINT comuna_ciudad_fk
    FOREIGN KEY (id_ciudad) REFERENCES ciudad (id_ciudad);

ALTER TABLE medico      ADD CONSTRAINT medico_especialidad_fk
    FOREIGN KEY (id_especialidad) REFERENCES especialidad (id_especialidad);

ALTER TABLE paciente    ADD CONSTRAINT paciente_comuna_fk
    FOREIGN KEY (id_comuna) REFERENCES comuna (id_comuna);

ALTER TABLE medicamento ADD CONSTRAINT medicamento_tipo_fk
    FOREIGN KEY (id_tipo_medicamento) REFERENCES tipo_medicamento (id_tipo_medicamento);

ALTER TABLE medicamento ADD CONSTRAINT medicamento_via_fk
    FOREIGN KEY (id_via_administracion) REFERENCES via_administracion (id_via_administracion);

ALTER TABLE receta      ADD CONSTRAINT receta_digitador_fk
    FOREIGN KEY (id_digitador) REFERENCES digitador (id_digitador);

ALTER TABLE receta      ADD CONSTRAINT receta_paciente_fk
    FOREIGN KEY (pac_rut) REFERENCES paciente (rut_pac);

ALTER TABLE receta      ADD CONSTRAINT receta_diagnostico_fk
    FOREIGN KEY (id_diagnostico) REFERENCES diagnostico (cod_diagnostico);

ALTER TABLE receta      ADD CONSTRAINT receta_medico_fk
    FOREIGN KEY (med_rut) REFERENCES medico (rut_med);

ALTER TABLE receta      ADD CONSTRAINT receta_tipo_receta_fk
    FOREIGN KEY (id_tipo_receta) REFERENCES tipo_receta (id_tipo_receta);

ALTER TABLE dosis       ADD CONSTRAINT dosis_medicamento_fk
    FOREIGN KEY (id_medicamento) REFERENCES medicamento (cod_medicamento);

ALTER TABLE dosis       ADD CONSTRAINT dosis_receta_fk
    FOREIGN KEY (id_receta) REFERENCES receta (cod_receta);

ALTER TABLE pago        ADD CONSTRAINT pago_receta_fk
    FOREIGN KEY (id_receta) REFERENCES receta (cod_receta);

ALTER TABLE pago        ADD CONSTRAINT pago_banco_fk
    FOREIGN KEY (id_banco) REFERENCES banco (cod_banco);


-- 5 - Modificaciones con ALTER TABLE
ALTER TABLE medicamento ADD precio_unitario NUMBER(7) NOT NULL;

ALTER TABLE medicamento ADD CONSTRAINT medicamento_precio_ck
    CHECK (precio_unitario BETWEEN 1000 AND 2000000);

ALTER TABLE pago ADD CONSTRAINT pago_metodo_pago_ck
    CHECK (metodo_pago IN ('EFECTIVO', 'TARJETA', 'TRANSFERENCIA'));

ALTER TABLE paciente DROP COLUMN edad;

ALTER TABLE paciente ADD fecha_nacimiento DATE NOT NULL;