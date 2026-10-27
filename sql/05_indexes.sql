-- =====================================================================
-- TP N° 2 SQL — RENTAL_CARS
-- 05_indexes.sql: índices para las búsquedas más usadas en las consultas
-- (las PK, FK y UNIQUE ya tienen índice automático en MySQL).
-- =====================================================================
USE RENTAL_CARS;

-- Consulta 18 y vista de ingresos: filtro por estado y fecha de inicio.
CREATE INDEX IDX_ALQ_ESTADO_FECHA ON ALQUILERES (estado, fecha_inicio);

-- Consulta 2: clientes por fecha de registro.
CREATE INDEX IDX_CLI_FECHA_REGISTRO ON CLIENTES (fecha_registro);

-- Consultas 1 y 16: orden por año del vehículo.
CREATE INDEX IDX_VEH_ANIO ON VEHICULOS (anio);
