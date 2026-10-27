-- =====================================================================
-- TP N° 2 SQL — RENTAL_CARS
-- 09_users_grants.sql: SECCIÓN 7 — Usuarios y permisos
-- =====================================================================

-- 1. Usuario vendedor con contraseña segura.
CREATE USER IF NOT EXISTS 'vendedor_user'@'localhost' IDENTIFIED BY 'Vend#2026_Seguro';

-- 2. Solo lectura sobre VEHICULOS, CATEGORIAS y SUCURSALES.
GRANT SELECT ON RENTAL_CARS.VEHICULOS  TO 'vendedor_user'@'localhost';
GRANT SELECT ON RENTAL_CARS.CATEGORIAS TO 'vendedor_user'@'localhost';
GRANT SELECT ON RENTAL_CARS.SUCURSALES TO 'vendedor_user'@'localhost';

-- 3. Lectura y escritura sobre ALQUILERES y PAGOS.
GRANT SELECT, INSERT, UPDATE, DELETE ON RENTAL_CARS.ALQUILERES TO 'vendedor_user'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON RENTAL_CARS.PAGOS      TO 'vendedor_user'@'localhost';

-- 4. Administrador con todos los privilegios sobre la base completa.
CREATE USER IF NOT EXISTS 'admin_user'@'localhost' IDENTIFIED BY 'Admin#2026_Seguro';
GRANT ALL PRIVILEGES ON RENTAL_CARS.* TO 'admin_user'@'localhost';

-- 5. Quitarle al vendedor el DELETE sobre ALQUILERES.
REVOKE DELETE ON RENTAL_CARS.ALQUILERES FROM 'vendedor_user'@'localhost';

-- Verificación:
SHOW GRANTS FOR 'vendedor_user'@'localhost';
SHOW GRANTS FOR 'admin_user'@'localhost';
