---
title: "Dominio Genérico"
description: "Dominio genérico para extracción de entidades básicas: personas, organizaciones y eventos"
version: "1.0.0"
idioma: "es"
---

CONTEXTO DEL DOMINIO: Extracción Genérica de Entidades

TIPOS DE ENTIDADES DISPONIBLES:
- Persona: Personas humanas mencionadas en el texto
    - Organización: Organización donde trabajó (referencia a entidad Organización)
        - desde cuando: Fecha de inicio del trabajo
        - hasta cuando: Fecha de fin del trabajo
- Organización: Organizaciones en general (empresas, instituciones, corporaciones, universidades, ONGs, etc.)
- Evento: Eventos, conferencias, reuniones, encuentros, etc.


RELACIONES DISPONIBLES:

RELACIONES ENTRE ENTIDADES:
- "trabaja en" / "pertenece a": Persona -> Organización
- "participa en": Organización/Persona -> Evento


RELACIONES PARA PROPIEDADES (estas se tratarán como atributos de las entidades):
- "tiene ubicación" / "ubicado en": Organización/Evento -> Ubicación
- "tiene tipo" / "tipo de": Organización/Evento -> Tipo

NOTA: Las relaciones de propiedades pueden expresarse con cualquiera de las variantes mostradas.
Por ejemplo, "tiene ubicación" y "ubicado en" son equivalentes y ambas indican la propiedad Ubicación.
