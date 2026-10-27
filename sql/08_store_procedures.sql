-- =====================================================================
-- TP N° 2 SQL — RENTAL_CARS
-- 08_store_procedures.sql: SECCIÓN 6 — Procedimientos almacenados
-- =====================================================================
USE RENTAL_CARS;

DROP PROCEDURE IF EXISTS SP_REGISTRAR_ALQUILER;
DROP PROCEDURE IF EXISTS SP_CALCULAR_MULTA;

DELIMITER //

-- 1. Registrar un alquiler -------------------------------------------
CREATE PROCEDURE SP_REGISTRAR_ALQUILER (
    IN p_id_cliente   INT,
    IN p_id_vehiculo  INT,
    IN p_id_empleado  INT,
    IN p_fecha_inicio DATE,
    IN p_fecha_fin    DATE
)
BEGIN
    -- Variables locales: se declaran al principio del BEGIN.
    DECLARE v_estado     TINYINT;
    DECLARE v_precio_dia DECIMAL(9,2);
    DECLARE v_sucursal   INT;
    DECLARE v_dias       INT;

    -- SELECT ... INTO guarda el resultado de la consulta en las variables.
    SELECT estado, precio_dia, id_sucursal
    INTO v_estado, v_precio_dia, v_sucursal
    FROM VEHICULOS
    WHERE id = p_id_vehiculo;

    -- a. El vehículo tiene que existir y estar disponible (estado = TRUE).
    IF v_estado IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: el vehículo no existe';
    END IF;

    IF v_estado = FALSE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: el vehículo no está disponible';
    END IF;

    -- b. Total = días de alquiler x precio por día.
    --    DATEDIFF(fin, inicio) devuelve la cantidad de días entre las fechas.
    SET v_dias = DATEDIFF(p_fecha_fin, p_fecha_inicio);

    IF v_dias <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: la fecha de fin debe ser posterior a la de inicio';
    END IF;

    -- c. Insertar el alquiler como 'activo'. Se retira y devuelve en la
    --    sucursal donde está el vehículo.
    --    (Los triggers TR_AUDITAR_ALQUILER y TR_ACTUALIZAR_ESTADO_VEHICULO se
    --    disparan solos con este INSERT.)
    INSERT INTO ALQUILERES (id_cliente, id_vehiculo, fecha_inicio, fecha_fin, total,
                            id_empleado, id_sucursal_retiro, id_sucursal_devolucion, estado)
    VALUES (p_id_cliente, p_id_vehiculo, p_fecha_inicio, p_fecha_fin, v_dias * v_precio_dia,
            p_id_empleado, v_sucursal, v_sucursal, 'activo');

    -- d. Mensaje de éxito.
    SELECT 'Alquiler registrado correctamente' AS mensaje;
END //

-- 2. Registrar una multa ---------------------------------------------
CREATE PROCEDURE SP_CALCULAR_MULTA (
    IN p_id_alquiler INT,
    IN p_motivo      VARCHAR(120),
    IN p_monto       DECIMAL(9,2)
)
BEGIN
    -- a. El alquiler tiene que existir.
    IF NOT EXISTS (SELECT 1 FROM ALQUILERES WHERE id_alquiler = p_id_alquiler) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: el alquiler no existe';
    END IF;

    -- b. Multa con la fecha actual y sin pagar.
    INSERT INTO MULTAS (id_alquiler, fecha, motivo, monto, pagada)
    VALUES (p_id_alquiler, CURDATE(), p_motivo, p_monto, FALSE);

    -- c. Mensaje de éxito.
    SELECT 'Multa registrada correctamente' AS mensaje;
END //

DELIMITER ;

-- Pruebas (descomentar para probar):
-- CALL SP_REGISTRAR_ALQUILER(6, 1, 1, '2026-11-01', '2026-11-04');   -- OK: total 3 x 45000
-- CALL SP_REGISTRAR_ALQUILER(6, 2, 1, '2026-11-01', '2026-11-04');   -- error: no disponible
-- CALL SP_CALCULAR_MULTA(7, 'Lavado interior', 12000);               -- OK
-- CALL SP_CALCULAR_MULTA(999, 'Prueba', 1000);                       -- error: no existe
