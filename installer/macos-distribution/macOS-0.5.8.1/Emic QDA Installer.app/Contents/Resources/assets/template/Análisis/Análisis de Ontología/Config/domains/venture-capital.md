---
title: "Dominio Venture Capital"
description: "Dominio especializado para ecosistema de Startups y Venture Capital en Latinoamérica"
version: "1.0.0"
idioma: "es"
---

CONTEXTO DEL DOMINIO: Ecosistema de Startups y Venture Capital en Latinoamérica

TIPOS DE ENTIDADES DISPONIBLES:
- Persona: Personas humanas mencionadas (fundadores, inversores, mentores, ejecutivos, gerentes, etc.)
    - Trabajo (relación: "trabaja en"): Experiencia laboral de la persona
        - Organización: Organización donde trabajó (referencia a entidad Organización)
            - desde cuando: Fecha de inicio del trabajo
            - hasta cuando: Fecha de fin del trabajo
    - Estudio (relación: "estudió en"): Formación académica de la persona
        - Organización: Organización educativa (referencia a entidad Organización)
            - desde cuando: Fecha de inicio del estudio
            - hasta cuando: Fecha de fin del estudio
- Organización: Son organizaciones en general, empresas, instituciones, corporaciones, universidades, instituciones educativas,ONGs, fondos de inversión, aceleradoras, incubadoras,  etc.
    - Ubicación: Ubicaciones geográficas (ciudades, países, regiones)
    - Tipo: Tipo de organización (startup, empresa, institución, ONG, etc.)
    - Sector: Sectores o verticales de negocio (B2B Software, Healthcare, Smart City, Climate, etc.)
- Evento: Eventos, conferencias, programas de aceleración, lanzamientos, encuentros, etc.
    - Ubicación: Ubicaciones geográficas (ciudades, países, regiones)
    - Tipo: Tipo de evento (conferencia, programa de aceleración, lanzamiento, encuentro, etc.)
- Ronda de Inversión:  eventos de levantamiento de capital, acuerdos de inversión, Etapas de inversión (Seed, Series A, B, etc.)
    - Monto: Cantidades monetarias mencionadas
    - Fecha: Fechas o períodos temporales mencionados
    - Ubicación: Ubicaciones geográficas (ciudades, países, regiones)
- Programa: Programas de aceleración, incubación o apoyo a emprendedores
    - Monto: Cantidades monetarias mencionadas
    - Fecha: Fechas o períodos temporales mencionados
    - Ubicación: Ubicaciones geográficas (ciudades, países, regiones)

RELACIONES DISPONIBLES:

RELACIONES ENTRE ENTIDADES:
- "invierte en": Organización -> Organización 
- "fundó": Persona -> Organización
- "trabaja en" / "pertenece a": Persona -> Organización
- "participa en": Organización/Persona -> Evento/Programa/Ronda de Inversión
- "organiza": Organización -> Evento/Programa/Ronda de Inversión
- "lidera": Persona -> Organización/Evento/Programa
- "colabora con": Organización -> Organización
- "apoya": Organización -> Organización/Evento/Programa
- "incluye": Evento/Programa -> Organización/Persona/Ronda de Inversión
- "inversor del evento": Organización -> Ronda de Inversión
- "startup del evento": Organización -> Ronda de Inversión

RELACIONES PARA PROPIEDADES (estas se tratarán como atributos de las entidades):
- "tiene ubicación" / "ubicado en": Organización/Evento/Ronda de Inversión/Programa -> Ubicación
- "tiene tipo" / "tipo de": Organización/Evento -> Tipo
- "tiene sector" / "sector de": Organización -> Sector
- "tiene monto" / "monto de" / "monto del evento": Ronda de Inversión/Programa -> Monto
- "tiene fecha" / "fecha de" / "fecha del evento": Ronda de Inversión/Programa -> Fecha
- "tiene moneda" / "moneda de" / "moneda del evento": Ronda de Inversión -> Moneda (opcional, si se menciona la moneda)

NOTA: Las relaciones de propiedades pueden expresarse con cualquiera de las variantes mostradas.
Por ejemplo, "tiene ubicación" y "ubicado en" son equivalentes y ambas indican la propiedad Ubicación.
