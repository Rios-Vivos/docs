# Ríos Vivos — materiales de investigación documental

**Objetivo:** implementar incrementalmente una plataforma de investigación documental, evidencia y consultas asistidas por IA sobre el panel ya existente de Ríos Vivos.

## Archivos

- [`../Features/Review_Documental_Investigation_Hub.md`](../Features/Review_Documental_Investigation_Hub.md): **fuente de verdad de la épica**. Contiene 23 historias, arquitectura, permisos, esquema, endpoints, tests y deployment.
- `EPICA_Investigacion_Documental_Rios_Vivos.md`: copia de referencia recibida; mantener sincronizada con la ficha de `Features/`.
- `mockups.html`: **prototipo navegable local**. Abrir en un navegador. Cambiar de sección usando el menú izquierdo.
- Pantallas de referencia: [`mockup_budgets.png`](../img/mockup_budgets.png), [`mockup_chat.png`](../img/mockup_chat.png), [`mockup_detail.png`](../img/mockup_detail.png), [`mockup_findings.png`](../img/mockup_findings.png), [`mockup_investigations.png`](../img/mockup_investigations.png), [`mockup_library.png`](../img/mockup_library.png), [`mockup_models.png`](../img/mockup_models.png) y [`mockup_workers.png`](../img/mockup_workers.png). El [resumen visual](../img/RESUMEN_mockups.png) reúne las pantallas.
- `IMPLEMENTATION_STATUS.md`: checklist para registrar avance y retomar sesiones de Codex.
- `PROMPT_PARA_CODEX.md`: prompt inicial para implementar tickets, uno por sesión.

## Alcance de los mockups

Los mockups son estáticos e ilustrativos. Simulan navegación, filtros, chat, formularios y estados; **no** se conectan a Ríos Vivos, no almacenan claves, no consultan IA y **no** certifican hallazgos ni autorizaciones. Mantienen la idea visual del panel oscuro que ya existe. El implementador debe reutilizar su layout, componentes, autenticación y rutas reales.

## Historias agrupadas

- **M0:** `RV-INV-001`…`004` — descubrimiento del stack, permisos, investigaciones.
- **M1:** `RV-INV-005`…`012` — biblioteca reutilizable, indexación, búsqueda, evidencia, hallazgos: MVP sin LLM.
- **M2:** `RV-INV-013`…`017` — credenciales API, límites, gateway, chat y persistencia.
- **M3:** `RV-INV-018`…`021` — búsqueda vectorial opcional, Ollama, nodo local y ajustes.
- **M4:** `RV-INV-022`…`023` — reportes, seguridad y operaciones.

## Uso

1. Consultar la épica en `Features/Review_Documental_Investigation_Hub.md` y los mockups en `Files/` y `img/`.
2. Pedir a Codex **primero** RV-INV-001 para auditar la tecnología real del admin, permisos y estructura.
3. Implementar **un ticket por PR**, registrar cambios en `IMPLEMENTATION_STATUS.md` y continuar con el siguiente.
4. No introducir API keys reales ni conectar proveedores a partir de este mockup.

**Prioridad de producto:** evidencia verificable, gasto nulo para búsquedas deterministas, créditos comerciales solo bajo política y revisión humana para conclusiones.
