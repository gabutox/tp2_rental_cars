# TP N° 2 — Preguntas teóricas

## 1. ¿Por qué ALQUILERES tiene dos claves foráneas hacia SUCURSALES? ¿Qué tipo de relación representa?

Porque un alquiler se relaciona con **dos sucursales que cumplen roles distintos**: la sucursal donde el cliente **retira** el auto (`id_sucursal_retiro`) y la sucursal donde lo **devuelve** (`id_sucursal_devolucion`). Pueden ser la misma o distintas; por ejemplo, retira en el Centro y devuelve en el Aeropuerto. Con una sola FK no se podría guardar las dos.

Son **dos relaciones uno a muchos (1:N) independientes** entre SUCURSALES y ALQUILERES:

- una sucursal es punto de retiro de muchos alquileres, y cada alquiler tiene una sola sucursal de retiro;
- una sucursal es punto de devolución de muchos alquileres, y cada alquiler tiene una sola sucursal de devolución.

Se las llama **relaciones múltiples** (o con roles) entre las mismas dos entidades. En las consultas se nota porque hay que unir SUCURSALES dos veces con alias distintos (consulta 10 y vista `VW_ALQUILERES_DETALLE`).

## 2. Si intentamos borrar una CATEGORIA que tiene vehículos asociados, ¿qué debería hacer la base de datos?

Las opciones de la clave foránea `VEHICULOS.id_categoria` son:

- **RESTRICT / NO ACTION** (valor por defecto): **rechaza** el borrado mientras existan vehículos de esa categoría.
- **CASCADE**: borra la categoría **y todos sus vehículos**. Además, como los vehículos tienen alquileres, reservas y mantenimientos, el borrado fallaría o arrastraría muchísimos datos.
- **SET NULL**: borra la categoría y deja `id_categoria` en NULL en esos vehículos. Requiere que la columna admita NULL, y los autos quedarían sin categoría.

**Lo más adecuado para este modelo es RESTRICT.** Un vehículo siempre debería tener categoría, porque de ella depende cómo se ofrece y se cobra. Además, borrar una categoría no debería eliminar autos de la flota con todo su historial.

Lo correcto es reasignar primero los vehículos a otra categoría y recién después borrarla. RESTRICT obliga a hacerlo así y protege la integridad referencial.

## 3. ¿Por qué la categoría está en una tabla separada y no como un campo de texto en VEHICULOS?

Por **normalización** y consistencia de datos:

- **Sin errores de tipeo:** con texto libre se podría escribir "SUV", "Suv" o "S.U.V." para lo mismo, y las consultas por categoría (11, 12 y la vista de ingresos) darían resultados incorrectos. Con una FK solo se pueden usar categorías que existen.
- **Datos propios de la categoría:** como la `descripcion`, que se guarda una sola vez y no se repite en cada auto.
- **Cambios en un solo lugar:** si se renombra una categoría, se cambia una fila y no todos los vehículos (se evita la anomalía de actualización).
- **Categorías sin autos:** se pueden crear categorías aunque todavía no tengan vehículos cargados.

## 4. ¿Qué tipo de relación existe entre SUCURSALES y EMPLEADOS?

Es una relación **uno a muchos (1:N)**: una sucursal tiene muchos empleados y cada empleado trabaja en una sola sucursal.

Se ve en el modelo porque la clave foránea `id_sucursal` está en EMPLEADOS, del lado "muchos". Cada empleado guarda un único `id_sucursal`, mientras que el mismo id de sucursal se repite en varios empleados. En los datos de prueba, la Sucursal Centro tiene a Laura Sánchez y a Pedro Díaz.

## 5. ¿Por qué CHECK_ALQUILER tiene un campo `tipo` ('salida' / 'entrada') en lugar de dos tablas separadas?

Porque la salida y la entrada del vehículo registran **exactamente los mismos datos**: fecha y hora, kilometraje y nivel de combustible. Lo único que cambia es el momento. Con dos tablas, la estructura quedaría duplicada.

Ventajas de este diseño:

- **Una sola estructura para mantener:** si se agrega un dato (por ejemplo, "daños observados"), se agrega una vez.
- **Comparaciones fáciles:** sale de una sola tabla cuánto se recorrió y cuánto combustible se gastó (km de entrada menos km de salida del mismo `id_alquiler`).
- **Extensible:** se pueden sumar otros tipos de control, como un "control intermedio", sin crear tablas nuevas.
- **Consultas más simples:** no hacen falta `UNION` ni dos JOIN para ver todos los controles de un alquiler.
