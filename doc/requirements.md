# TP N° 2 — Modelo de datos: RENTAL_CARS

## De qué se trata

El modelo representa el **sistema de una empresa de alquiler de autos con varias sucursales**. Registra lo siguiente:

- **Flota de vehículos:** categoría, sucursal donde están, precio por día, estado de disponibilidad y kilometraje.
- **Clientes y empleados:** los clientes con su licencia de conducir y los empleados de cada sucursal.
- **Alquileres:** quién alquila qué auto, qué empleado lo gestiona, dónde se retira y dónde se devuelve, el total y el estado.
- **Datos asociados a un alquiler:** reservas previas, pagos, seguros contratados, multas y los controles de salida y entrada del vehículo.
- **Mantenimientos** de cada vehículo.

Base de datos: `RENTAL_CARS` (MySQL 8).

## Entidades

| Tabla | Representa |
|---|---|
| SUCURSALES | Sedes de la empresa (nombre, dirección, ciudad, teléfono) |
| CATEGORIAS | Tipos de vehículo (Económico, SUV, Sedán, Utilitario) |
| CLIENTES | Personas que alquilan, con su licencia de conducir |
| EMPLEADOS | Personal de cada sucursal, con cargo y salario |
| VEHICULOS | Flota: marca, modelo, año, precio por día, estado, km |
| ALQUILERES | Contrato de alquiler: cliente, vehículo, fechas, total, estado |
| RESERVAS | Reserva anticipada de un vehículo por un cliente |
| PAGOS | Pagos realizados para un alquiler |
| SEGUROS | Póliza contratada para un alquiler |
| MULTAS | Infracciones ocurridas durante un alquiler |
| CHECK_ALQUILER | Control de salida y de entrada (km y combustible) |
| MANTENIMIENTOS | Services y reparaciones de cada vehículo |

## Relaciones y su relación inversa

| Relación | Card. | Lectura directa | Relación inversa |
|---|---|---|---|
| SUCURSALES – EMPLEADOS | 1:N | Un empleado trabaja en una sucursal | Una sucursal tiene muchos empleados |
| SUCURSALES – VEHICULOS | 1:N | Un vehículo está en una sucursal | Una sucursal tiene muchos vehículos |
| CATEGORIAS – VEHICULOS | 1:N | Un vehículo es de una categoría | Una categoría agrupa muchos vehículos |
| CLIENTES – ALQUILERES | 1:N | Un alquiler es de un cliente | Un cliente hace muchos alquileres |
| VEHICULOS – ALQUILERES | 1:N | Un alquiler es de un vehículo | Un vehículo se alquila muchas veces |
| EMPLEADOS – ALQUILERES | 1:N | Un alquiler lo gestiona un empleado | Un empleado gestiona muchos alquileres |
| SUCURSALES – ALQUILERES (retiro) | 1:N | Un alquiler se retira en una sucursal | En una sucursal se retiran muchos alquileres |
| SUCURSALES – ALQUILERES (devolución) | 1:N | Un alquiler se devuelve en una sucursal | En una sucursal se devuelven muchos alquileres |
| CLIENTES – RESERVAS | 1:N | Una reserva es de un cliente | Un cliente hace muchas reservas |
| VEHICULOS – RESERVAS | 1:N | Una reserva es de un vehículo | Un vehículo tiene muchas reservas |
| ALQUILERES – PAGOS | 1:N | Un pago corresponde a un alquiler | Un alquiler puede pagarse en varios pagos |
| ALQUILERES – SEGUROS | 1:N | Un seguro cubre un alquiler | Un alquiler puede tener seguros |
| ALQUILERES – MULTAS | 1:N | Una multa ocurre en un alquiler | Un alquiler puede tener varias multas |
| ALQUILERES – CHECK_ALQUILER | 1:N | Un control es de un alquiler | Un alquiler tiene su control de salida y de entrada |
| VEHICULOS – MANTENIMIENTOS | 1:N | Un mantenimiento es de un vehículo | Un vehículo tiene muchos mantenimientos |

ALQUILERES y RESERVAS resuelven la relación **muchos a muchos entre CLIENTES y VEHICULOS**.

## Requerimientos funcionales

1. Administrar sucursales, categorías, empleados y la flota de vehículos.
2. Registrar clientes con sus datos de contacto y licencia de conducir (única).
3. Registrar reservas anticipadas de vehículos.
4. Registrar alquileres solo si el vehículo está disponible, con el total calculado como días × precio por día (`SP_REGISTRAR_ALQUILER`).
5. Al registrar un alquiler activo, marcar el vehículo como no disponible (`TR_ACTUALIZAR_ESTADO_VEHICULO`).
6. Auditar cada alquiler nuevo con fecha y hora (`TR_AUDITAR_ALQUILER`).
7. Registrar pagos, seguros, multas (`SP_CALCULAR_MULTA`) y los controles de salida y entrada.
8. Registrar los mantenimientos de cada vehículo.
9. Consultar reportes: alquileres detallados, vehículos por sucursal, ingresos por categoría, rankings de empleados y clientes, multas recaudadas.

## Requerimientos no funcionales

1. **Integridad referencial:** todas las relaciones con claves foráneas; no se puede borrar un vehículo, cliente o sucursal con datos asociados.
2. **Consistencia:**
   - restricciones `CHECK` en el estado del alquiler, en el orden de las fechas, en el tipo de control y en un precio positivo;
   - `UNIQUE` en patente y licencia.
3. **Seguridad:** usuarios con permisos mínimos. El vendedor lee el catálogo y gestiona alquileres y pagos, sin poder borrar alquileres; el administrador tiene control total.
4. **Rendimiento:** índices en estado y fecha de alquiler, fecha de registro del cliente y año del vehículo.
5. **Trazabilidad:** auditoría automática de alquileres.
6. **Portabilidad:** el motor corre en Docker (`docker-compose.yml` + `.env`) y los scripts se ejecutan en orden numérico.
