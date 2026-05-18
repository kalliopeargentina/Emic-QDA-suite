# Núcleo QDA — Dominios: crear, abrir y cambiar dominio activo

## ¿Para qué sirve?
Gestionar el **espacio conceptual** dentro del cual declarás tipos de entidad y de relación, y dentro del cual tus **extracciones de entidad** son válidas contra la ontología.

## Resultado (qué obtenés)
- Un **dominio** con su archivo `Domain Definition` accesible.
- Un **Active Domain** establecido antes de crear entidades nuevas desde texto.

## Dónde en la interfaz

Según [[01-Interfase-de-usuario]] y [[00-Resumen]], sobre el documento aparece una barra de íconos: uno abre el **menú de dominios** con opciones entre otras para:

- crear definición / eliminar dominio
- cambiar dominio activo
- abrir *Domain Definition*
- crear/editar tipos de entidad y relación

Comandos equivalentes existen en **Command palette** (nombres en inglés tipo *Create Domain Definition*, *Open Domain Definition*, *Switch active domain* — traducibles según idioma del núcleo).

## Crear dominio nuevo

1. Menú contextual de dominios activo desde la barra de íconos (o comando **Create Domain Definition**).
2. Completá el identificador/nombre solicitado por el modal.
3. Confirmá creación → el sistema debería fijarlo como dominio actual y registrar `Domain Definition` bajo árbol *Entidades*.

## Cambiar dominio activo

1. Menú de dominios → **Switch active domain** / cambiar dominio.
2. Elegí otro dominio listado → verificá en status bar/indicadores inferiores (donde muestra dominio/codebook conforme proyecto demo).

## Abrir definición (`Domain Definition`)

1. Menú → **Open Domain Definition** (*Abrir definición…* si tu UI está traducida).
2. Editá sólo mediante flujos soportados (mejor siempre vía comandos del menú que edición manual brusca del archivo si no sabés el contrato interno visual).

## Eliminar dominio

1. Menú → **Delete Domain** (con precaución).
2. Backup previo del vault.

## Problemas comunes

- **No puedo extraer entidad**: confirmá **dominio activo** alineado con tipos que definiste.
- **Domain Definition no abre**: verificá que la carpeta *Entidades* exista y que el plugin esté habilitado.

Siguiente: [[ontologia_definir_tipos_entidad]].
