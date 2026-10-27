-- =====================================================================
-- TP N° 2 SQL — RENTAL_CARS (alquiler de autos)
-- 01_create.sql: creación de la base de datos y de las tablas
-- =====================================================================

-- SECCIÓN 1.1 — Crear la base de datos solo si no existe.
CREATE DATABASE IF NOT EXISTS RENTAL_CARS;
USE RENTAL_CARS;

-- SECCIÓN 1.2 — Tablas, en orden de dependencias:
--   1) Sin FK:            SUCURSALES, CATEGORIAS, CLIENTES
--   2) Dependen de 1):    EMPLEADOS, VEHICULOS
--   3) Dependen de 2):    ALQUILERES, RESERVAS, MANTENIMIENTOS
--   4) Dependen de 3):    PAGOS, SEGUROS, MULTAS, CHECK_ALQUILER

CREATE TABLE SUCURSALES (
    id        INT AUTO_INCREMENT PRIMARY KEY,
    nombre    VARCHAR(80) NOT NULL,
    direccion VARCHAR(120),
    ciudad    VARCHAR(50),
    telefono  VARCHAR(30)
);

CREATE TABLE CATEGORIAS (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    nombre      VARCHAR(50) NOT NULL,
    descripcion VARCHAR(120)
);

CREATE TABLE CLIENTES (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    nombre            VARCHAR(50) NOT NULL,
    email             VARCHAR(50),
    telefono          VARCHAR(50),
    ciudad            VARCHAR(50),
    fecha_registro    DATE,
    licencia_conducir VARCHAR(30) UNIQUE
);

CREATE TABLE EMPLEADOS (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    nombre        VARCHAR(80) NOT NULL,
    cargo         VARCHAR(50),
    id_sucursal   INT NOT NULL,
    fecha_ingreso DATE,
    salario       DECIMAL(10,2),
    FOREIGN KEY (id_sucursal) REFERENCES SUCURSALES(id)
);

-- estado: TRUE (1) = disponible, FALSE (0) = no disponible.
CREATE TABLE VEHICULOS (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    marca        VARCHAR(50) NOT NULL,
    modelo       VARCHAR(50) NOT NULL,
    anio         INT,
    precio_dia   DECIMAL(9,2) NOT NULL,
    estado       TINYINT(1) DEFAULT 1,
    id_categoria INT NOT NULL,
    id_sucursal  INT NOT NULL,
    patente      VARCHAR(15) UNIQUE,
    km_actual    INT,
    FOREIGN KEY (id_categoria) REFERENCES CATEGORIAS(id),
    FOREIGN KEY (id_sucursal)  REFERENCES SUCURSALES(id)
);

-- Dos FK hacia SUCURSALES: una para dónde se retira el auto y otra para
-- dónde se devuelve (ver doc/questions.md, pregunta 1).
-- estado: 'activo', 'finalizado' o 'cancelado'.
CREATE TABLE ALQUILERES (
    id_alquiler            INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente             INT NOT NULL,
    id_vehiculo            INT NOT NULL,
    fecha_inicio           DATE NOT NULL,
    fecha_fin              DATE,
    total                  DECIMAL(9,2),
    id_empleado            INT NOT NULL,
    id_sucursal_retiro     INT NOT NULL,
    id_sucursal_devolucion INT,
    estado                 VARCHAR(20),
    FOREIGN KEY (id_cliente)             REFERENCES CLIENTES(id),
    FOREIGN KEY (id_vehiculo)            REFERENCES VEHICULOS(id),
    FOREIGN KEY (id_empleado)            REFERENCES EMPLEADOS(id),
    FOREIGN KEY (id_sucursal_retiro)     REFERENCES SUCURSALES(id),
    FOREIGN KEY (id_sucursal_devolucion) REFERENCES SUCURSALES(id)
);

CREATE TABLE RESERVAS (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente    INT NOT NULL,
    id_vehiculo   INT NOT NULL,
    fecha_reserva DATE,
    fecha_inicio  DATE,
    fecha_fin     DATE,
    estado        VARCHAR(20),
    FOREIGN KEY (id_cliente)  REFERENCES CLIENTES(id),
    FOREIGN KEY (id_vehiculo) REFERENCES VEHICULOS(id)
);

CREATE TABLE MANTENIMIENTOS (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    id_vehiculo   INT NOT NULL,
    fecha         DATE,
    tipo          VARCHAR(50),
    costo         DECIMAL(9,2),
    observaciones VARCHAR(200),
    FOREIGN KEY (id_vehiculo) REFERENCES VEHICULOS(id)
);

CREATE TABLE PAGOS (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    id_alquiler INT NOT NULL,
    fecha_pago  DATE,
    monto       DECIMAL(9,2),
    FOREIGN KEY (id_alquiler) REFERENCES ALQUILERES(id_alquiler)
);

CREATE TABLE SEGUROS (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    id_alquiler   INT NOT NULL,
    compania      VARCHAR(80),
    numero_poliza VARCHAR(50),
    cobertura     VARCHAR(100),
    costo         DECIMAL(9,2),
    FOREIGN KEY (id_alquiler) REFERENCES ALQUILERES(id_alquiler)
);

-- pagada: TRUE (1) = pagada, FALSE (0) = pendiente.
CREATE TABLE MULTAS (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    id_alquiler INT NOT NULL,
    fecha       DATE,
    motivo      VARCHAR(120),
    monto       DECIMAL(9,2),
    pagada      TINYINT(1) DEFAULT 0,
    FOREIGN KEY (id_alquiler) REFERENCES ALQUILERES(id_alquiler)
);

-- tipo: 'salida' (cuando se entrega el auto) o 'entrada' (cuando vuelve).
CREATE TABLE CHECK_ALQUILER (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    id_alquiler       INT NOT NULL,
    tipo              VARCHAR(10),
    fecha             DATETIME,
    km                INT,
    nivel_combustible INT,
    FOREIGN KEY (id_alquiler) REFERENCES ALQUILERES(id_alquiler)
);
