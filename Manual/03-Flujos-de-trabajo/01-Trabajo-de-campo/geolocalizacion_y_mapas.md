# Trabajo de campo — Geolocalización y mapas

## ¿Para qué sirve?
Asociar **coordenadas** a notas o archivos fuente y navegarlos en una **vista de mapa** (Obsidian **Maps**, **Maps View**, u otro que tengas instalado en EMIC Plus QDA).

## Resultado (qué obtenés)
- Notas con **propiedad de ubicación** que el mapa puede leer.
- Una pestaña o vista de mapa que muestra puntos y permite abrir la nota asociada.

## Enfoque general (sin depender de un solo plugin)

La mayoría de plugins de mapa en Obsidian esperan **frontmatter YAML** con campos de latitud/longitud o un bloque de metadata equivalente. Consultá la documentación del plugin **instalado** para el nombre exacto de la clave; patrones frecuentes incluyen:

```yaml
location: [ -34.60, -58.38 ]
```

o pares:

```yaml
latitude: -34.60
longitude: -58.38
```

## Pasos típicos

### 1) Añadir ubicación a una nota de campo

1. Abrí la nota (por ejemplo bajo *Notas de Campo* o *Datos/Documentos*).
2. En el **frontmatter** (bloque `---` al inicio), agregá las propiedades que exija tu plugin de mapas.
3. Guardá la nota.

Si tu suite incluye acción “**Add current location**” o “**Import geolocations from file**” (aparece en el material de [[00-Resumen]]), usala desde el **menú contextual** del archivo o carpeta según corresponda.

### 2) Abrir la vista de mapa

1. En la barra lateral o command palette, buscá el comando del plugin **Maps** / **Maps View** (nombre exacto según instalación).
2. Abrí la vista; deberían mostrarse los puntos de notas con coordenadas válidas.
3. Navegación: click en pin → abre nota; zoom/pan según UI del mapa.

### 3) Filtrar por carpeta o tag (si el plugin lo permite)

Muchas vistas permiten limitar a una carpeta (ej. `Notas de Campo/`) o a un tag de campo. Revisá el panel de opciones de la vista de mapa.

## Consejos para QDA
- Geolocalizá **eventos** o **sitios** de observación, no sólo “la oficina del investigador”.
- Si no tenés GPS exacto, podés fijar un punto aproximado y anotar en el cuerpo de la nota la incertidumbre.

## Problemas comunes

- **No aparece el pin**: frontmatter mal formateado o claves que el plugin no reconoce.
- **Mapa vacío**: la vista está filtrada a otra carpeta; limpiá filtros.
- **Coordenadas invertidas**: verificá orden lat/lon según documentación del plugin.

Siguiente fase analítica: [[03-Flujos-de-trabajo/02-Codificacion-y-codebooks/codificar_parrafos_asignar_y_quitar]].
