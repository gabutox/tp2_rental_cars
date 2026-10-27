-- =====================================================================
-- TP N° 2 SQL — RENTAL_CARS
-- 07_triggers.sql: SECCIÓN 5 — Triggers
-- DELIMITER // evita que los ";" del BEGIN ... END corten la sentencia.
-- =====================================================================
USE RENTAL_CARS;

-- 1. Auditoría de alquileres -----------------------------------------

CREATE TABLE IF NOT EXISTS AUDITORIA_ALQUILERES (
    id_auditoria   INT AUTO_INCREMENT PRIMARY KEY,
    id_alquiler    INT,
    id_cliente     INT,
    id_vehiculo    INT,
    fecha_registro DATETIME,
    accion         VARCHAR(50)
);

DROP TRIGGER IF EXISTS TR_AUDITAR_ALQUILER;
DROP TRIGGER IF EXISTS TR_ACTUALIZAR_ESTADO_VEHICULO;

DELIMITER //
-- AFTER INSERT: el alquiler ya está guardado, así que NEW.id_alquiler ya
-- tiene el valor que le asignó el AUTO_INCREMENT.
CREATE TRIGGER TR_AUDITAR_ALQUILER
AFTER INSERT ON ALQUILERES
FOR EACH ROW
BEGIN
    INSERT INTO AUDITORIA_ALQUILERES (id_alquiler, id_cliente, id_vehiculo, fecha_registro, accion)
    VALUES (NEW.id_alquiler, NEW.id_cliente, NEW.id_vehiculo, NOW(), 'NUEVO ALQUILER');
END //

-- 2. Si el alquiler entra como 'activo', el vehículo deja de estar disponible.
--    Un trigger puede modificar OTRA tabla (VEHICULOS), no la suya propia.
CREATE TRIGGER TR_ACTUALIZAR_ESTADO_VEHICULO
AFTER INSERT ON ALQUILERES
FOR EACH ROW
BEGIN
    IF NEW.estado = 'activo' THEN
        UPDATE VEHICULOS
        SET estado = FALSE
        WHERE id = NEW.id_vehiculo;
    END IF;
END //
DELIMITER ;

-- Pruebas (descomentar para probar):
-- INSERT INTO ALQUILERES (id_cliente, id_vehiculo, fecha_inicio, fecha_fin, total, id_empleado, id_sucursal_retiro, id_sucursal_devolucion, estado)
-- VALUES (5, 7, CURDATE(), CURDATE() + INTERVAL 2 DAY, 104000, 4, 3, 3, 'activo');
-- SELECT * FROM AUDITORIA_ALQUILERES;              -- aparece 'NUEVO ALQUILER'
-- SELECT id, marca, modelo, estado FROM VEHICULOS WHERE id = 7;   -- estado = 0
