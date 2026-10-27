-- =====================================================================
-- TP N° 2 SQL — RENTAL_CARS
-- 06_views.sql: SECCIÓN 4 — Vistas
-- =====================================================================
USE RENTAL_CARS;

-- 1. Alquileres en forma "amigable": nombres en lugar de ids.
--    SUCURSALES se une dos veces (retiro y devolución) con alias distintos.
--    LEFT JOIN en devolución porque puede ser NULL si el auto no volvió.
CREATE OR REPLACE VIEW VW_ALQUILERES_DETALLE AS
SELECT a.fecha_inicio,
       a.fecha_fin,
       cl.nombre                         AS cliente,
       CONCAT_WS(' ', v.marca, v.modelo) AS vehiculo,
       e.nombre                          AS empleado,
       sr.nombre                         AS sucursal_retiro,
       sd.nombre                         AS sucursal_devolucion,
       a.total
FROM ALQUILERES a
JOIN CLIENTES        cl ON a.id_cliente             = cl.id
JOIN VEHICULOS       v  ON a.id_vehiculo            = v.id
JOIN EMPLEADOS       e  ON a.id_empleado            = e.id
JOIN SUCURSALES      sr ON a.id_sucursal_retiro     = sr.id
LEFT JOIN SUCURSALES sd ON a.id_sucursal_devolucion = sd.id;

-- 2. Cantidad de vehículos por sucursal, con su ciudad.
--    LEFT JOIN + COUNT(v.id) para que una sucursal sin autos muestre 0.
CREATE OR REPLACE VIEW VW_VEHICULOS_POR_SUCURSAL AS
SELECT s.nombre      AS sucursal,
       s.ciudad,
       COUNT(v.id)   AS total_vehiculos
FROM SUCURSALES s
LEFT JOIN VEHICULOS v ON v.id_sucursal = s.id
GROUP BY s.id, s.nombre, s.ciudad;

-- 3. Por categoría: cantidad de alquileres finalizados y monto facturado.
--    Camino: CATEGORIAS -> VEHICULOS -> ALQUILERES (solo 'finalizado').
CREATE OR REPLACE VIEW VW_INGRESOS_POR_CATEGORIA AS
SELECT c.nombre              AS categoria,
       COUNT(a.id_alquiler)  AS alquileres_finalizados,
       SUM(a.total)          AS total_facturado
FROM CATEGORIAS c
JOIN VEHICULOS  v ON v.id_categoria = c.id
JOIN ALQUILERES a ON a.id_vehiculo  = v.id
WHERE a.estado = 'finalizado'
GROUP BY c.id, c.nombre;

-- Uso:
SELECT * FROM VW_ALQUILERES_DETALLE;
SELECT * FROM VW_VEHICULOS_POR_SUCURSAL ORDER BY total_vehiculos DESC;
SELECT * FROM VW_INGRESOS_POR_CATEGORIA;
