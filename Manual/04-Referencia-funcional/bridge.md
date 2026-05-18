# Referencia funcional — Bridge (uso, sin protocolo interno)

Algunas integraciones (por ejemplo con **Zotero** u otras fuentes) usan un **file bridge**: jobs entrantes y recibos de aplicación en carpetas bajo el vault.

### Qué necesita saber el usuario

1. Activación en **Settings → Emic‑QDA** (sección *Bridge*): `enabled`, raíz `storageRoot`, intervalo de sondeo, modo de sync.
2. No edites archivos de cola a mano salvo guía de soporte: usá la app emisora (Zotero connector / script) según documentación de tu paquete EMIC.
3. Si algo falla, revisá la carpeta de **failed** (si tu build la muestra) y reenviá el job corregido.

Para detalle contrato técnico ver documentación de desarrollador del repo `emic-qda` — **no** forma parte del manual de usuario final.
