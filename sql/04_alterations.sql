-- =====================================================================
-- TP N° 2 SQL — RENTAL_CARS
-- 04_alterations.sql: modificaciones posteriores al esquema
-- El TP no pide alteraciones; se agregan restricciones que protegen los datos.
-- =====================================================================
USE RENTAL_CARS;

-- Estado de un alquiler: solo valores conocidos.
ALTER TABLE ALQUILERES
ADD CONSTRAINT CHK_ALQ_ESTADO CHECK (estado IN ('activo', 'finalizado', 'cancelado'));

-- La fecha de fin no puede ser anterior a la de inicio.
ALTER TABLE ALQUILERES
ADD CONSTRAINT CHK_ALQ_FECHAS CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio);

-- Tipo de check: salida o entrada.
ALTER TABLE CHECK_ALQUILER
ADD CONSTRAINT CHK_CHECK_TIPO CHECK (tipo IN ('salida', 'entrada'));

-- Precio por día positivo.
ALTER TABLE VEHICULOS
ADD CONSTRAINT CHK_VEH_PRECIO CHECK (precio_dia > 0);
