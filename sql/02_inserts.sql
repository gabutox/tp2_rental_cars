-- =====================================================================
-- TP N° 2 SQL — RENTAL_CARS
-- 02_inserts.sql: datos de prueba
-- Mismo orden que el CREATE. Los datos están pensados para que cada
-- consulta del TP devuelva al menos un resultado.
-- =====================================================================
USE RENTAL_CARS;

INSERT INTO SUCURSALES (id, nombre, direccion, ciudad, telefono) VALUES
(1, 'Sucursal Centro',     'Av. Libertador 1200', 'San Juan', '2644201010'),
(2, 'Sucursal Aeropuerto', 'Ruta 20 km 12',       'San Juan', '2644202020'),
(3, 'Sucursal Mendoza',    'Av. San Martín 850',  'Mendoza',  '2614303030'),
(4, 'Sucursal Córdoba',    'Bv. San Juan 400',    'Córdoba',  '3514404040');

INSERT INTO CATEGORIAS (id, nombre, descripcion) VALUES
(1, 'Económico',  'Autos chicos de bajo consumo'),
(2, 'SUV',        'Camionetas utilitarias deportivas'),
(3, 'Sedán',      'Autos medianos de 4 puertas'),
(4, 'Utilitario', 'Furgones y pick-ups de carga');

INSERT INTO CLIENTES (id, nombre, email, telefono, ciudad, fecha_registro, licencia_conducir) VALUES
(1, 'Gabriel Alaniz',  'gabriel.alaniz@mail.com', '2644140309', 'San Juan',     '2024-03-10', 'LIC-SJ-10001'),
(2, 'Juan Pérez',      'juan.perez@mail.com',     '3514123456', 'Córdoba',      '2024-05-22', 'LIC-CB-20002'),
(3, 'María Gómez',     'maria.gomez@mail.com',    '2615551234', 'Mendoza',      '2026-09-05', 'LIC-MZ-30003'),
(4, 'Lucía Fernández', 'lucia.fdez@mail.com',     '2644987654', 'San Juan',     '2026-09-18', 'LIC-SJ-40004'),
(5, 'Carlos Ruiz',     'carlos.ruiz@mail.com',    '3515557788', 'Córdoba',      '2025-11-02', 'LIC-CB-50005'),
(6, 'Sofía Martínez',  'sofia.mtz@mail.com',      '1145678901', 'Buenos Aires', '2026-10-03', 'LIC-BA-60006');

INSERT INTO EMPLEADOS (id, nombre, cargo, id_sucursal, fecha_ingreso, salario) VALUES
(1, 'Laura Sánchez', 'Vendedora', 1, '2019-04-01', 180000.00),
(2, 'Luis Moreno',   'Vendedor',  2, '2020-08-15', 175000.00),
(3, 'Pedro Díaz',    'Gerente',   1, '2018-02-01', 350000.00),
(4, 'Ana Torres',    'Vendedora', 3, '2022-06-10', 180000.00),
(5, 'Marcos Vega',   'Mecánico',  4, '2021-03-20', 210000.00);

-- Los vehículos 2 y 3 tienen alquileres 'activo', por eso están en estado 0.
INSERT INTO VEHICULOS (id, marca, modelo, anio, precio_dia, estado, id_categoria, id_sucursal, patente, km_actual) VALUES
(1, 'Toyota',     'Etios',     2018,  45000.00, 1, 1, 1, 'AC123BD',  85000),
(2, 'Ford',       'Territory', 2023,  95000.00, 0, 2, 1, 'AF456GH',  22000),
(3, 'Jeep',       'Renegade',  2021,  90000.00, 0, 2, 2, 'AE789JK',  41000),
(4, 'Volkswagen', 'Vento',     2020,  70000.00, 1, 3, 3, 'AD321LM',  60000),
(5, 'Fiat',       'Cronos',    2022,  50000.00, 1, 1, 4, 'AE654NP',  30000),
(6, 'Renault',    'Kangoo',    2017,  55000.00, 1, 4, 2, 'AB987QR', 120000),
(7, 'Chevrolet',  'Onix',      2024,  52000.00, 1, 1, 3, 'AG111ST',   8000),
(8, 'Toyota',     'Hilux',     2015, 110000.00, 1, 4, 4, 'AA222UV', 180000);

-- total = días (DATEDIFF) x precio_dia del vehículo.
INSERT INTO ALQUILERES (id_alquiler, id_cliente, id_vehiculo, fecha_inicio, fecha_fin, total, id_empleado, id_sucursal_retiro, id_sucursal_devolucion, estado) VALUES
(1, 1, 1, '2024-08-01', '2024-08-05', 180000.00, 1, 1, 1, 'finalizado'),
(2, 2, 5, '2024-09-10', '2024-09-14', 200000.00, 2, 4, 4, 'finalizado'),
(3, 1, 2, '2024-10-05', '2024-10-12', 665000.00, 1, 1, 2, 'activo'),
(4, 3, 3, '2024-10-20', '2024-10-25', 450000.00, 2, 2, 1, 'activo'),
(5, 5, 8, '2025-01-10', '2025-01-15', 550000.00, 4, 4, 3, 'finalizado'),
(6, 2, 4, '2025-03-01', '2025-03-04', 210000.00, 4, 3, 3, 'finalizado'),
(7, 4, 1, '2026-09-20', '2026-09-23', 135000.00, 1, 1, 1, 'finalizado'),
(8, 1, 4, '2026-06-02', '2026-06-06', 280000.00, 3, 1, 3, 'finalizado');

INSERT INTO RESERVAS (id, id_cliente, id_vehiculo, fecha_reserva, fecha_inicio, fecha_fin, estado) VALUES
(1, 6, 7, '2026-10-01', '2026-11-05', '2026-11-08', 'pendiente'),
(2, 3, 4, '2025-02-20', '2025-03-01', '2025-03-04', 'confirmada');

INSERT INTO MANTENIMIENTOS (id, id_vehiculo, fecha, tipo, costo, observaciones) VALUES
(1, 1, '2025-05-10', 'Service',   120000.00, 'Service de los 80.000 km'),
(2, 8, '2025-02-01', 'Neumáticos', 400000.00, 'Cambio de las 4 cubiertas'),
(3, 3, '2026-08-15', 'Frenos',     90000.00, 'Pastillas delanteras');

INSERT INTO PAGOS (id, id_alquiler, fecha_pago, monto) VALUES
(1, 1, '2024-08-05', 180000.00),
(2, 2, '2024-09-14', 200000.00),
(3, 3, '2024-10-05', 300000.00),
(4, 5, '2025-01-15', 550000.00),
(5, 6, '2025-03-04', 210000.00),
(6, 7, '2026-09-23', 135000.00),
(7, 8, '2026-06-06', 280000.00);

INSERT INTO SEGUROS (id, id_alquiler, compania, numero_poliza, cobertura, costo) VALUES
(1, 3, 'La Segunda',          'POL-2024-1001', 'Todo riesgo',                35000.00),
(2, 5, 'Sancor Seguros',      'POL-2025-2001', 'Terceros completo',          20000.00),
(3, 7, 'Federación Patronal', 'POL-2026-3001', 'Todo riesgo con franquicia', 15000.00);

INSERT INTO MULTAS (id, id_alquiler, fecha, motivo, monto, pagada) VALUES
(1, 1, '2024-08-03', 'Exceso de velocidad',         45000.00, 1),
(2, 5, '2025-01-12', 'Estacionamiento indebido',    15000.00, 1),
(3, 3, '2024-10-08', 'Devolución con tanque vacío', 20000.00, 0);

-- nivel_combustible en porcentaje (0 a 100).
INSERT INTO CHECK_ALQUILER (id, id_alquiler, tipo, fecha, km, nivel_combustible) VALUES
(1, 1, 'salida',  '2024-08-01 09:00:00', 84200, 100),
(2, 1, 'entrada', '2024-08-05 18:30:00', 84950,  60),
(3, 7, 'salida',  '2026-09-20 10:00:00', 84990, 100),
(4, 7, 'entrada', '2026-09-23 17:45:00', 85000,  80),
(5, 3, 'salida',  '2024-10-05 08:15:00', 21500, 100);
