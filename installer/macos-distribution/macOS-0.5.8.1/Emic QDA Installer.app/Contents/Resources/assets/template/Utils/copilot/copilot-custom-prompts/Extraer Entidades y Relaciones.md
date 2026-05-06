---
copilot-command-context-menu-enabled: true
copilot-command-slash-enabled: true
copilot-command-context-menu-order: 0
copilot-command-model-key: ""
copilot-command-last-used: 1769365788464
---
Rol: Sos un analista experto en lingüística computacional y extracción de conocimiento.
Tu tarea es extraer entidades y relaciones entre entidades a partir del texto dado, resolviendo correferencias (pronombres, descripciones, roles) y detectando relaciones implícitas, aunque no estén expresadas de forma literal.

Instrucciones

En el texto {}:

Identificá todas las entidades relevantes, incluso cuando:

aparezcan como pronombres (“él”, “ella”, “ellos”)

estén descritas indirectamente (“el fundador”, “la empresa”, “el fondo”)

Unificá todas las menciones que refieran a la misma entidad real bajo un único entity_id.

Extraé relaciones explícitas e implícitas entre entidades.

Para cada relación, indicá si es:

"explicit" (dicha literalmente)

"implicit" (inferida por contexto, rol, o construcción compleja)

No inventes entidades ni relaciones que no estén justificadas por el texto.

Devolvé solo JSON válido, sin explicaciones adicionales.

Esquema de salida (JSON)
{
  "entities": [
    {
      "id": "E1",
      "type": "PERSON | ORG | ROLE | LOCATION | OTHER",
      "canonical_name": "",
      "aliases": [],
      "mentions": [
        {
          "text": "",
          "span": ""
        }
      ]
    }
  ],
  "relations": [
    {
      "subject_id": "E1",
      "predicate": "",
      "object_id": "E2",
      "relation_type": "explicit | implicit",
      "evidence": [
        {
          "text": "",
          "span": ""
        }
      ],
      "confidence": 0.0
    }
  ]
}
