-- =====================================================================
-- TP N° 2 SQL — RENTAL_CARS
-- 03_queries.sql: SECCIÓN 2 (consultas SELECT) y SECCIÓN 3 (DML)
-- =====================================================================
USE RENTAL_CARS;

-- ---------------------------------------------------------------------
-- SECCIÓN 2 — Consultas SELECT
-- ---------------------------------------------------------------------

-- 1. Marca, modelo y año de los vehículos, del más antiguo al más nuevo.
SELECT marca, modelo, anio
FROM VEHICULOS
ORDER BY anio ASC;

-- 2. Nombre, email y ciudad de los clientes registrados el mes anterior.
--    Mes y año iguales a los de "hoy menos un mes".
SELECT nombre, email, ciudad
FROM CLIENTES
WHERE YEAR(fecha_registro)  = YEAR(CURDATE() - INTERVAL 1 MONTH)
  AND MONTH(fecha_registro) = MONTH(CURDATE() - INTERVAL 1 MONTH);

-- 3. Marca, modelo y precio por día de los vehículos de la categoría 2.
SELECT marca, modelo, precio_dia
FROM VEHICULOS
WHERE id_categoria = 2;

-- 4. Todos los datos de los empleados cuyo nombre empieza con "L".
SELECT *
FROM EMPLEADOS
WHERE nombre LIKE 'L%';

-- 5. Nombre y cargo de los empleados con salario distinto a 180000.00.
SELECT nombre, cargo
FROM EMPLEADOS
WHERE salario <> 180000.00;

-- 6. Marca y modelo del vehículo con el nombre de su categoría.
SELECT v.marca, v.modelo, c.nombre AS categoria
FROM VEHICULOS v
JOIN CATEGORIAS c ON v.id_categoria = c.id;

-- 7. Fecha de inicio, cliente, vehículo (marca + modelo) y empleado que atendió.
SELECT a.fecha_inicio,
       cl.nombre                         AS cliente,
       CONCAT_WS(' ', v.marca, v.modelo) AS vehiculo,
       e.nombre                          AS empleado
FROM ALQUILERES a
JOIN CLIENTES  cl ON a.id_cliente  = cl.id
JOIN VEHICULOS v  ON a.id_vehiculo = v.id
JOIN EMPLEADOS e  ON a.id_empleado = e.id;

-- 8. Nombre del cliente, su ciudad y la fecha de registro.
--    (Todos los datos están en CLIENTES: no hace falta JOIN.)
SELECT nombre, ciudad, fecha_registro
FROM CLIENTES;

-- 9. Marca y modelo del vehículo con el nombre y la ciudad de su sucursal.
SELECT v.marca, v.modelo, s.nombre AS sucursal, s.ciudad
FROM VEHICULOS v
JOIN SUCURSALES s ON v.id_sucursal = s.id;

-- 10. Alquiler con la sucursal de retiro y la de devolución.
--     ALQUILERES no tiene un campo "nombre": se identifica con su id y el
--     nombre del cliente. Se une DOS veces con SUCURSALES, con dos alias
--     distintos (sr = retiro, sd = devolución).
SELECT a.id_alquiler,
       cl.nombre AS cliente,
       sr.nombre AS sucursal_retiro,
       sd.nombre AS sucursal_devolucion
FROM ALQUILERES a
JOIN CLIENTES   cl ON a.id_cliente             = cl.id
JOIN SUCURSALES sr ON a.id_sucursal_retiro     = sr.id
JOIN SUCURSALES sd ON a.id_sucursal_devolucion = sd.id;

-- 11. Cantidad de vehículos por categoría.
SELECT c.nombre AS categoria, COUNT(*) AS cantidad
FROM VEHICULOS v
JOIN CATEGORIAS c ON v.id_categoria = c.id
GROUP BY c.id, c.nombre;

-- 12. Precio promedio por día de los vehículos, por categoría.
SELECT c.nombre AS categoria, AVG(v.precio_dia) AS precio_promedio
FROM VEHICULOS v
JOIN CATEGORIAS c ON v.id_categoria = c.id
GROUP BY c.id, c.nombre;

-- 13. Empleado y cantidad de alquileres gestionados, de mayor a menor.
SELECT e.nombre, COUNT(*) AS total_alquileres
FROM ALQUILERES a
JOIN EMPLEADOS e ON a.id_empleado = e.id
GROUP BY e.id, e.nombre
ORDER BY total_alquileres DESC;

-- 14. Clientes con más de 1 alquiler (condición sobre COUNT -> HAVING).
SELECT cl.nombre, COUNT(*) AS cantidad_alquileres
FROM ALQUILERES a
JOIN CLIENTES cl ON a.id_cliente = cl.id
GROUP BY cl.id, cl.nombre
HAVING COUNT(*) > 1;

-- 15. Ciudad y cantidad de sucursales en cada una.
SELECT ciudad, COUNT(*) AS cantidad_sucursales
FROM SUCURSALES
GROUP BY ciudad;

-- 16. Marca, modelo y año del vehículo más antiguo.
--     Opción A: ordenar y quedarse con el primero.
SELECT marca, modelo, anio
FROM VEHICULOS
ORDER BY anio ASC
LIMIT 1;

--     Opción B (subconsulta escalar con MIN).
SELECT marca, modelo, anio
FROM VEHICULOS
WHERE anio = (SELECT MIN(anio) FROM VEHICULOS);

-- 17. Vehículos que nunca fueron alquilados.
--     Opción A: LEFT JOIN ... IS NULL.
SELECT v.marca, v.modelo, v.patente
FROM VEHICULOS v
LEFT JOIN ALQUILERES a ON a.id_vehiculo = v.id
WHERE a.id_alquiler IS NULL;

--     Opción B (subconsulta con NOT EXISTS).
SELECT v.marca, v.modelo, v.patente
FROM VEHICULOS v
WHERE NOT EXISTS (
    SELECT 1 FROM ALQUILERES a
    WHERE a.id_vehiculo = v.id
);

-- 18. Alquileres 'activo' que empezaron en octubre de 2024.
SELECT *
FROM ALQUILERES
WHERE estado = 'activo'
  AND fecha_inicio BETWEEN '2024-10-01' AND '2024-10-31';

-- 19. Los 3 vehículos con el precio por día más alto.
SELECT marca, modelo, precio_dia
FROM VEHICULOS
ORDER BY precio_dia DESC
LIMIT 3;

-- 20. Cantidad de multas pagadas y monto total recaudado por ellas.
SELECT COUNT(*) AS multas_pagadas, SUM(monto) AS total_recaudado
FROM MULTAS
WHERE pagada = TRUE;

-- ---------------------------------------------------------------------
-- SECCIÓN 3 — Operaciones DML
-- ---------------------------------------------------------------------

-- 1. Nuevo cliente con licencia nueva y una ciudad que ya existe (Mendoza).
INSERT INTO CLIENTES (nombre, email, telefono, ciudad, fecha_registro, licencia_conducir)
VALUES ('Diego Torres', 'diego.torres@mail.com', '2616662233', 'Mendoza', CURDATE(), 'LIC-MZ-70007');

-- 2. Salario 200000.00 para vendedores/as que ingresaron antes de 2021.
--    Los paréntesis son necesarios: AND se evalúa antes que OR.
UPDATE EMPLEADOS
SET salario = 200000.00
WHERE (cargo = 'Vendedor' OR cargo = 'Vendedora')
  AND fecha_ingreso < '2021-01-01';

-- 3. Borrar un vehículo sin alquileres, reservas ni mantenimientos
--    (6 = Renault Kangoo). Si tuviera filas asociadas, las FK lo impedirían.
DELETE FROM VEHICULOS
WHERE id = 6;

-- 4. Traslado de un vehículo a otra sucursal (Fiat Cronos pasa a Centro).
UPDATE VEHICULOS
SET id_sucursal = 1
WHERE id = 5;
