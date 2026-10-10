# Ríos Vivos — Épica: Plataforma de investigación documental asistida por IA

**Clave:** RV-INV-EPIC-01
**Versión:** 1.0 · 10 de octubre de 2026
**Estado:** Propuesta técnica lista para desglosar en tickets
**Producto:** Panel de administración de Ríos Vivos
**Prioridad:** Implementación incremental, costos acotados, evidencia verificable.

> **Decisión de producto:** conservar las vistas existentes de **biblioteca documental** (`/dashboard/management/rag/`) y **consulta** (`/dashboard/rag/`) y agregar el concepto central de **Investigación**, más **Hallazgos**, **Evidencias** y **Administración de IA**. El RAG es una capacidad interna, no una sección que los científicos deban configurar.

## 1. Resultado esperado

Como integrante del equipo científico, quiero crear una investigación, vincular documentos previamente cargados, buscar y comparar información, preguntar en lenguaje natural y guardar hallazgos con evidencias exactas, para producir conclusiones auditables sin tener que configurar herramientas de IA.

**Condición de entrada de este proyecto:** se da por completada la descarga inicial de los CSV, Excel, gacetas y PDF del caso ASEA al equipo local. **No** volver a implementar un crawler para resolver el caso histórico; sí implementar la **ingesta reusable** de los archivos desde la biblioteca de Ríos Vivos, su procesamiento e indexación, porque esas son capacidades de la plataforma.

**Caso de referencia (solo fixture, no resultados verificados):** solicitud ASEA/PNT folio 341002500102426; municipios Poncitlán, Zapotlán del Rey, Ocotlán, Juanacatlán, Ixtlahuacán de los Membrillos y Chapala; periodo 2025–2026; dos CSV de 2026 que totalizan 538 registros y 38 enlaces a ERA. Estos números sirven para validar importaciones; ningún proyecto se marca como aprobado sin su oficio o fuente equivalente.

### Principios no negociables

1. **Evidence-first:** toda afirmación factual del asistente debe citar documento, versión, página o fila y fragmento consultable. Una respuesta sin prueba se presenta como hipótesis o insuficiencia de datos.
2. **Search-first:** filtros SQL y full-text antes de cualquier llamada a LLM. La semántica se añade después, no reemplaza filtros exhaustivos.
3. **Local-first en procesamiento:** parseo, OCR, hashes, deduplicación, indexación y consultas deterministas no generan tokens comerciales.
4. **Control de costo obligatorio en servidor:** cuotas por usuario, investigación, proveedor, modelo y trabajo; reservas antes de ejecutar y reconciliación al terminar. El cliente no determina permisos ni topes.
5. **Reproducibilidad:** cada análisis almacena conjunto de documentos/versions, filtros, algoritmo, prompts/versiones, modelo, fecha y resultado.
6. **Seguridad:** claves nunca en navegador o logs; documentos no enviados a proveedor externo sin política de salida aprobada.
7. **Incrementalidad:** cada ticket produce migración, API, tests, UI y/o documentación que pueden integrarse por separado bajo feature flags.

## 2. Alcance funcional y experiencia de usuario

### 2.1 Pantallas finales y rutas propuestas

| Pantalla | Ruta sugerida | Acceso | Función |
|---|---|---|---|
| Investigaciones | `/dashboard/investigations` | Miembros autorizados | Lista, estado, búsqueda y creación |
| Detalle de investigación | `/dashboard/investigations/:id` | Miembros de esa investigación | Objetivos, fechas, municipios, fuentes, progreso |
| Biblioteca existente | `/dashboard/management/rag/` | `staff` + `scientist` para administrar | Crear carpetas, subir, clasificar, asociar y ver estado |
| Documentos en una investigación | `/dashboard/investigations/:id/documents` | Miembros | Adjuntar archivos sin duplicarlos, filtrar, inspeccionar texto |
| Asistente de investigación | `/dashboard/investigations/:id/chat` | Miembros con permiso de consulta | Buscar/consultar en contexto, citas, historial y costo |
| Hallazgos y evidencias | `/dashboard/investigations/:id/findings` | Miembros / revisores | Guardar hipótesis, confirmar, descartar y exportar |
| Modelos y proveedores | `/dashboard/management/ai/models` | `staff` + `scientist` + `ai.manage_models` | Configurar proveedores, modelos, destinos y claves |
| Límites y uso | `/dashboard/management/ai/usage` | `staff` + `scientist` + `ai.manage_limits` | Cuotas, reservas, métricas, costos y bloqueo |
| Nodos y trabajos | `/dashboard/management/ai/workers` | `staff` + `scientist` + `ai.manage_workers` | Estado del nodo, cola, reintentos, errores |

**Compatibilidad:** mantener inicialmente `/dashboard/rag/` como redirección al selector de investigación o modo biblioteca global; conservar rutas existentes con controles de acceso actuales hasta una migración explícita. No eliminar componentes, endpoints ni permisos en un solo PR.

### 2.2 Flujo visible para una persona no técnica

1. Entrar a **Investigaciones** y crear una a partir de una plantilla o en blanco.
2. Escribir nombre, objetivo, rango de fechas, municipios, palabras clave y participantes (opcionales).
3. Añadir archivos ya cargados en **Biblioteca**; la misma fuente puede participar en varias investigaciones.
4. El sistema muestra los estados **Pendiente → Procesando → Indexado → Error / Revisión requerida** y cobertura exacta (`N/M` archivos y páginas).
5. Buscar directamente o abrir el **Asistente**. Se mostrarán resultados SQL/FTS sin IA si resuelven la pregunta.
6. Para preguntas interpretativas, el asistente solo recibe fragmentos autorizados y devuelve referencias clicables.
7. **Guardar como hallazgo**, asignar revisor y estado: `propuesto`, `por_verificar`, `confirmado`, `descartado`, `evidencia_insuficiente`.
8. Exportar informe y relación de evidencias (CSV inicialmente; PDF/DOCX posteriormente).

### 2.3 Cambios concretos de UI respecto a capturas actuales

- **Biblioteca:** conservar diseño oscuro, barra lateral y tarjetas. Reducir el dropzone dominante a un bloque compacto/collapsible. Agregar chips de estado, selección múltiple y acción **Agregar a investigación**.
- **Chat:** reemplazar concepto de destinatarios/contactos por investigación seleccionada, historial de sesiones y panel lateral de **Evidencia** con documento, página/fila y citas. Mostrar respuesta **No hay evidencia suficiente** cuando corresponda.
- **Nuevas vistas:** lista + detalle de investigaciones, hallazgos, y configuración de IA. Usar español consistente, estados legibles y no exponer terminología técnica al científico.
- **Móvil/responsivo:** panel de evidencia como cajón; navegación izquierda colapsable. Botones con estados vacíos, carga y error.

## 3. Arquitectura técnica propuesta

```text
Admin frontend EXISTENTE (verificar framework/routing actual antes de modificar)
       |
       v
Sails.js (Node.js 20) — JWT + RBAC + API + control de costo y orquestación
       |                |                    |
       v                v                    v
PostgreSQL/RDS       S3 existentes       AI Gateway (adaptadores OpenAI / Anthropic)
metadata, ACL,       originales +         |          ^
FTS, jobs, usage     derivados             |          |
+ pgvector opcional                       Ollama/nodo local (optativo)
       ^                ^                    ^
       |                |                    |
Python 3.12 workers --+-- cola PostgreSQL lease/heartbeat
(PyMuPDF, pandas, openpyxl, OCRmyPDF/Tesseract; Docling opcional)
```

**No asumir tecnología del frontend administrativo a partir de una captura.** Validar repo real, componentes y estilos y reutilizarlos; el proyecto Ríos Vivos utiliza Sails.js/Node 20, PostgreSQL, AWS, y también Next.js/React en sus interfaces, pero la tecnología precisa del admin debe confirmarse.

### 3.1 Paquetes y servicios obligatorios vs optativos

| Capa | Requerido MVP | Optativo / posterior | Integración |
|---|---|---|---|
| Backend | Sails.js Node 20, servicio `investigations` | — | REST y validaciones server-side; reaprovechar JWT/RBAC |
| Metadatos y búsqueda | PostgreSQL (RDS), `tsvector`/GIN, `pg_trgm`/`unaccent` cuando estén habilitados | `pgvector` | Migraciones versionadas, búsquedas parametrizadas y restricción por ACL |
| Objetos | S3 actual | — | Hash SHA-256, versionado lógico, URL firmada de corta vida; original inmutable |
| Parseo | Python 3.12, pandas, openpyxl, PyMuPDF | Docling (tablas complejas) | Worker idempotente y salida JSON normalizada |
| OCR | OCRmyPDF, Tesseract + idioma `spa`/`eng` | OCR avanzado si las pruebas lo exigen | Generar derivado OCR; no reemplazar original |
| Cola | PostgreSQL con leases y `FOR UPDATE SKIP LOCKED` | pg-boss u otro job manager tras benchmark | Estados, reintentos, expiración, DLQ y cancelación |
| LLM nube | Adaptadores OpenAI y Anthropic con API separada de ChatGPT/Codex | LiteLLM Proxy para ruteo y contabilidad multi-proveedor | Secretos en servidor, timeout y reintentos acotados |
| LLM local | Ollama, endpoint restringido | vLLM si crece el throughput | Nodo de cómputo registrado; no exponer 11434 a Internet |
| Embeddings | No requeridos para FTS MVP | Embeddings locales + pgvector; HNSW tras medir recall | Versionar `model_id`, dimensión y pipeline de chunking |
| Despliegue | Infra existente EC2, RDS, S3; Terraform cuando proceda | AWS KMS/Secrets Manager, SQS para escalamiento | Secretos fuera de git, jobs aislados, observabilidad |

**Importante:** probar si la versión de RDS permite `CREATE EXTENSION vector`; si no, continuar solo con FTS. No imponer un servicio nuevo para resolverlo. Una implementación de LiteLLM Proxy debe añadir límites de presupuesto de negocio en Sails.js; no delegar toda la seguridad financiera al proxy.

### 3.2 Procesamiento indexado y citas

- `document`: metadatos y objeto lógico; `document_version`: SHA-256, key S3, MIME, tamaño, origen y fecha.
- `document_segment`: `document_version_id`, tipo (`page`, `sheet_row`, `table`, `paragraph`), número de página/hoja/fila, texto, offsets, bounding boxes opcionales, `parse_version`, idioma y estado OCR.
- Para CSV/XLSX: preservar **nombre de hoja, fila, encabezados, valor de celda e hipervínculo**. No reducir a un CSV plano que elimine relaciones.
- Para PDF: texto por página. OCR solo en páginas sin texto utilizable, con avisos de confianza cuando aplique.
- Indexar por ACL: el usuario jamás recupera segmentos de investigaciones a las que no tiene acceso, incluso cuando pregunte desde chat.
- Registro de cobertura: bytes, documentos, páginas/filas procesadas, errores, descartados, versiones y tiempo.
- El `finding_evidence` apunta a una versión/segmento estable; un reproceso crea segmentos nuevos y preserva la traza anterior.

### 3.3 Chat y motor de consulta

Flujo: `autorización → clasificación determinista de intención → consulta estructurada / FTS → opcional búsqueda semántica → selección de snippets con ACL → presupuesto + política de privacidad → llamada al modelo si se requiere → respuesta citada → uso/costo/auditoría`.

- Preguntas cuantitativas sobre entidades confirmadas: SQL, **cero LLM**.
- Búsqueda textual y palabras clave: Postgres FTS + trigramas, **cero LLM**.
- Comparación/explicación: un LLM seleccionado por política, nunca documentos completos sin filtro.
- Si no hay resultados: devolver alcance buscado y grado de cobertura, no una afirmación de inexistencia.
- Para expedientes aprobados: exigir documento que exprese resolución, fecha, oficio y órgano emisor, o mantener `no_determinado`.
- Seguridad RAG: fuentes externas son datos no confiables; no obedecer instrucciones dentro de PDF, HTML o CSV. Limitar herramientas/acciones a búsquedas aprobadas.
- No usar historial completo indiscriminadamente: resúmenes compactos y referencias a citas; tokens máximos explícitos.

### 3.4 Gobierno de modelos y secretos

Configuración de **proveedores** (OpenAI / Anthropic / Ollama) y **modelos** como registros independientes:

- Proveedor: nombre, tipo, URL base validada, secreto por referencia, estado y pruebas de conectividad.
- Modelo: `model_id` proveedor, alias visible, context limit configurable/verificado, costo entrada/salida publicado/configurable, capacidad (`chat`, `embedding`, `vision`), estado y clasificación de privacidad.
- Políticas: `simple`, `analisis`, `lote`, `sensible`; orden de proveedores, fallback permitido, máxima entrada/salida, timeouts, costo estimado y límite concurrente.
- Las API keys se almacenan **cifradas** en servidor: preferentemente AWS Secrets Manager + KMS y solo referencia en DB; alternativa cifrado de aplicación con clave maestra en secreto/env protegida. Guardar último 4 dígitos; API nunca devuelve clave en claro. Rotación y revocación; no loggear `Authorization` ni prompts con datos sensibles.
- Política de salida de datos: `LOCAL_ONLY`, `EXTERNAL_ALLOWED` y `REDACT_BEFORE_EXTERNAL` por investigación; el fallback a proveedor externo **nunca** evade `LOCAL_ONLY`.
- La cuenta de ChatGPT/Codex del desarrollador **no proporciona automáticamente crédito API** para el backend. Registrar credenciales API de cada proveedor por separado.

### 3.5 Control de tokens, presupuestos y abuso

Aplicar en API **y en cola**, no únicamente en la interfaz:

1. Autenticación + membresía + capacidad. Rate limits por usuario/IP (no confiar en IP como identidad).
2. Máximo de peticiones por periodo, tokens máximos de entrada/salida por petición, límite de trabajo/archivos y concurrencia.
3. Presupuesto monetario/periodo a nivel global, usuario, investigación y proveedor; cifra configurable por administrador, sin asumir precios fijos.
4. Estimación conservadora de costo y **reserva atómica** en base de datos antes de lanzar un trabajo; denegar si rebasa presupuesto.
5. Conciliación según uso devuelto por proveedor; si hay fallo/timeout registrar estimación y desbloquear o ajustar de forma consistente. Idempotencia evita facturación doble en reintentos.
6. Registro inmutable de `ai_usage_ledger` con `request_id`, `user_id`, `investigation_id`, proveedor/modelo, estimación, entrada/salida, costo, cache, estado, hora, código de respuesta (sin el secreto).
7. Circuit breaker frente a errores 429/5xx y fallback **solo** a proveedores permitidos con presupuesto restante; mostrar al usuario si hubo cambio de modelo.
8. Caché por hash de `pregunta_normalizada + documentos/versiones + alcance + política + modelo/prompt_version`, con TTL e invalidación al cambiar un documento.
9. Jobs grandes con **estimación previa** en pantalla; inicio exige confirmación y permiso.

### 3.6 Nodo local con PC RTX 4070 SUPER

Equipo informado: RTX 4070 SUPER (normalmente 12 GB VRAM), Intel Core Ultra 7 256K (identificación por confirmar), 63 GB DDR5, SSD Crucial T700 1 TB. Suficiente para probar extracción/OCR, embeddings locales y modelos pequeños/medianos cuantizados. Para 14B/contextos largos probablemente sea necesario optimizar cuantización, buffers u offload a RAM; medir en lugar de prometer rendimiento.

**Topología recomendada:** Sails.js/EC2 mantiene cola central y balance de políticas; la PC abre una conexión **saliente autenticada** sobre WireGuard/Tailscale o mTLS con el servidor, registra un `worker_id`, capacidades, heartbeat, disponibilidad y concurrencia. Reclama **trabajos autorizados** y recibe objetos cifrados o URLs S3 firmadas de lectura mínima. Ollama atiende solo en `127.0.0.1`/interfaz privada. No hay port-forward público al hogar.

**Política de ruteo:** `consulta simple → SQL/FTS`; `análisis de lotes elegibles + nodo activo → cola local`; `pregunta interpretativa → proveedor cloud barato permitido`; `local-only + nodo offline → trabajo en espera o error explícito`, **nunca enviarlo silenciosamente a nube**. Definir per-investigation si está permitida la computación en nodo personal. Al completar una tarea, borrar temporales según retención y registrar versión del modelo.

## 4. Modelo de datos mínimo

```text
investigations(id, title, objective, state, created_by, privacy_policy, created_at)
investigation_members(investigation_id, user_id, role)
investigation_scope(investigation_id, from_date, to_date, municipalities_json, keywords_json)
documents(id, owner_id, name, mime, created_at)
document_versions(id, document_id, sha256, s3_key, size, version, created_at)
investigation_documents(investigation_id, document_id, attached_by, attached_at)
document_segments(id, version_id, page_no, sheet_name, row_no, kind, text, locator_json, parse_version)
processing_jobs(id, kind, state, payload_json, attempts, lease_until, worker_id, progress_json, last_error)
findings(id, investigation_id, title, claim, kind, state, created_by, reviewed_by, reviewed_at)
finding_evidence(id, finding_id, segment_id, quote, stance, notes)
chat_sessions(id, investigation_id, user_id, title)
chat_messages(id, session_id, role, content, citations_json, usage_id, created_at)
ai_providers(id, type, base_url, secret_ref, enabled)
ai_models(id, provider_id, model_identifier, capabilities_json, price_config_json, enabled)
ai_policies(id, name, route_json, constraints_json, privacy_level)
ai_budgets(id, scope_type, scope_id, period, max_requests, max_tokens, max_cost_usd)
ai_usage_ledger(id, request_id, user_id, investigation_id, model_id, estimated_tokens,
                actual_input_tokens, actual_output_tokens, estimated_cost_usd, actual_cost_usd, status)
ai_workers(id, node_name, capability_json, last_heartbeat, enabled, status)
analysis_runs(id, investigation_id, document_manifest_sha256, pipeline_version,
              prompt_version, policy_id, state, started_at, completed_at)
```

**Índices:** GIN full-text en `document_segments`; B-tree en `investigation_documents`, `finding_evidence`, `ai_usage_ledger`; unicidad `document_versions(document_id, sha256)` y `ai_usage_ledger(request_id)`; `pgvector` opcional en `document_embeddings` separados por `embedding_model_id` para evitar incompatibilidad dimensional.

## 5. API REST mínima (versionar en namespace existente)

| Método | Endpoint lógico | Función |
|---|---|---|
| GET/POST | `/api/investigations` | Listar/crear investigaciones |
| GET/PATCH | `/api/investigations/:id` | Detalle, edición, filtros |
| GET/POST/DELETE | `/api/investigations/:id/documents` | Asociar/desasociar sin eliminar fuente |
| GET | `/api/investigations/:id/search?q=...` | SQL/FTS, filtros y fragmentos |
| GET | `/api/document-versions/:id/segments/:segmentId` | Texto y localizador autorizado |
| POST | `/api/investigations/:id/findings` | Crear hallazgo |
| POST | `/api/findings/:id/evidence` | Vincular evidencia |
| PATCH | `/api/findings/:id/review` | Confirmar/descartar con auditoría |
| POST | `/api/investigations/:id/chat` | Chat contextual con citas y límites |
| GET/POST | `/api/management/ai/providers` | Administración de proveedor + secret-ref |
| GET/POST | `/api/management/ai/models` | Modelos/ruteo |
| GET/PUT | `/api/management/ai/budgets` | Cuotas |
| GET | `/api/management/ai/usage` | Uso agregado y registro |
| GET | `/api/management/ai/workers` | Estado nodos y jobs |
| POST | `/api/management/ai/estimate` | Estimación/cotización previa de trabajo |

Respuestas error consistentes (`403`, `409`, `413`, `422`, `429`, `503`), paginación cursor para documentos y búsqueda, autorización a nivel registro y pruebas de aislamiento entre investigaciones. El diseño de endpoints es una **propuesta**, no evidencia de rutas actuales.

## 6. Backlog de historias independientes por entregable

Cada historia es un PR/release pequeño, cerrado cuando pasan CI, pruebas y documentación. La columna **Dep.** representa historias previas; **T** es esfuerzo aproximado S/M/L, no estimación de horas.

| ID | Historia / entrega demostrable | Dep. | T |
|---|---|---|---|
| **RV-INV-001** | Auditar rutas reales, RBAC existente, S3/RDS, jobs; feature flags `investigations.enabled` y `ai.enabled`; ADR y checklist de compatibilidad. | — | S |
| **RV-INV-002** | Incorporar capacidad `scientist` a usuarios existentes con migración; políticas `staff && scientist` para gestión y `ai.manage_*` para secretos, presupuesto y workers; tests de 401/403. | 001 | M |
| **RV-INV-003** | Crear esquema de investigaciones, miembros y ámbito; API CRUD con validaciones, membresía y tests de aislamiento. | 002 | M |
| **RV-INV-004** | Listado, formulario y detalle/resumen de investigaciones en panel existente (dark theme); estados vacíos/loading/error. | 003 | M |
| **RV-INV-005** | Adaptar biblioteca actual sin regresiones: adjuntar/detachar documentos a investigación, selección múltiple, estado por archivo; preservar carpetas/S3. | 003 | M |
| **RV-INV-006** | DocumentVersion+SHA256, detector MIME, estado de indexación y manifiesto. No borrar/alterar objetos originales; tests deduplicación. | 005 | M |
| **RV-INV-007** | Job runner DB con `SKIP LOCKED`, lease/heartbeat, reintentos, progreso y cancelación; carga y tests de concurrencia. | 006 | L |
| **RV-INV-008** | Worker Python de extracción PDF/CSV/XLSX que preserve páginas, sheets, filas, URLs; OCR de fallback; fixtures y pruebas. | 007 | L |
| **RV-INV-009** | Full-text search PostgreSQL, índices GIN/ACL, filtros municipio/fecha/término; lista de citas directas por página/fila. | 008 | M |
| **RV-INV-010** | Lector de evidencia: enlace autorizado y vista de original + fragmento/page locator; manejo de documento faltante y OCR dudoso. | 009 | M |
| **RV-INV-011** | Hallazgos y evidencias vinculadas, estados y revisión humana con historial; sin IA. | 010 | M |
| **RV-INV-012** | UI de hallazgos y panel de progreso/cobertura, filtros y export CSV de hallazgos/citas. **Primer MVP usable sin gastar tokens.** | 011 | M |
| **RV-INV-013** | Registro de proveedores/modelos (OpenAI, Anthropic) y secretos cifrados; prueba de conexión server-side, masked keys; sin exponer APIs externas al navegador. | 002 | L |
| **RV-INV-014** | Presupuestos, ledger, reservas atómicas, límites por request/día/mes, rate limiting, métricas y hard-stop; tests 429, concurrencia y reintentos. | 013 | L |
| **RV-INV-015** | Gateway server-side con adaptadores OpenAI/Anthropic, ruteo por política, timeout, fallback compatible y mock provider para tests. | 014 | M |
| **RV-INV-016** | Chat contextual por investigación con recuperación FTS, citations, guardrails, mensaje de insuficiencia y registro de costo; UI basada en chat existente. | 009,015 | L |
| **RV-INV-017** | Salvar respuesta como hallazgo, comparaciones multi-documento y evaluación reproducible con casos ASEA + negativos. | 011,016 | M |
| **RV-INV-018** | Embeddings locales + `pgvector` opcional y búsqueda híbrida con RRF; benchmark precision/recall vs FTS antes de activar feature flag. | 009 | L |
| **RV-INV-019** | Registro seguro de nodo PC, heartbeat, capability report, VPN/mTLS y servicio Ollama privado; tests nodo offline. | 007,014 | L |
| **RV-INV-020** | Scheduler de lotes con estimate, confirmación, cola, reanudación, capacidad local y prohibición de fallback externo en `LOCAL_ONLY`. | 019,015 | L |
| **RV-INV-021** | Pantallas modelos/keys, límites/uso, nodos/trabajos, auditoría de cambios, rotación de claves y alertas. | 013,014,019 | M |
| **RV-INV-022** | Export final (PDF/DOCX) y plantillas reutilizables para investigaciones recurrentes; reportes con manifiesto de cobertura. | 012,017 | M |
| **RV-INV-023** | Observabilidad/seguridad/end-to-end: métricas latencia/costo, aislamiento, inyección de prompts, OCR adversarial, recuperación ante fallos y playbook de despliegue. | 016,020 | L |

### Criterios de aceptación por milestone

**M0 — Base (001–004).** Un usuario autorizado crea, consulta y comparte una investigación. Un usuario sin rol `staff`+`scientist` no accede a configuración. Rutas previas conservan su comportamiento o redirigen de forma documentada.

**M1 — Evidencia sin IA (005–012).** Asociar un conjunto de archivos existentes, extraer con logs y retries, buscar `Ocotlán`, navegar al documento/hoja/página, crear hallazgo y exportarlo. Búsquedas no llaman a ningún modelo externo; se indica cobertura y errores del corpus.

**M2 — IA de nube bajo control (013–017).** Configurar 2 proveedores mediante secretos seguros, simular proveedor, establecer límites bajos en tests y validar que una solicitud rechazada no llama API. El chat cita segmentos autorizados y no inventa aprobaciones.

**M3 — IA local opcional (018–021).** Conectar/desconectar nodo, procesar un lote sin abrir puertos públicos, comprobar continuidad del backend cuando se cae la PC y que `LOCAL_ONLY` no usa proveedores externos. Medir utilidad de la búsqueda híbrida antes de habilitarla.

**M4 — Operación (022–023).** Generar informes con fuentes reproducibles, tablero de costos, pruebas end-to-end y runbook de rotación, respaldo, borrado y restauración.

### Pruebas de aceptación de dominio (ASEA)

- Importar los 2 CSV y validar `277 + 261 = 538` filas con `source_file` y `row_no`, no 538 hallazgos ni 538 proyectos confirmados.
- Conservar los 38 registros con enlace ERA **sin asumir que son los únicos expedientes relevantes**.
- Distinguir titular, actividad, municipio, expediente, MIA, ERA y oficio. No sustituir campos ausentes por inferencias.
- Un filtro `autorizado` devuelve solo proyectos con evidencia explícita de resolución, fecha y oficio, o se marca `revisión pendiente`.
- Comparar 2 fuentes con textos contradictorios y mostrar ambos fragmentos.
- Preguntar por 2025 si el corpus no lo cubre: el sistema informa la falta de cobertura en lugar de afirmar que no hubo proyectos.
- Ningún fragmento de una investigación privada aparece en otra investigación no autorizada.

## 7. Estrategia de commits / Codex para sesiones limitadas

**Regla:** ejecutar **una historia por sesión de Codex** (o subhistoria si es L). No solicitar que implemente toda la épica. Tras cada historia terminar con build, tests, migración reversible, capturas si aplica, documentación, commit y una nota `NEXT_STEPS.md` actualizada.

**Ubicación de referencia:** esta épica vive en `docs/Features/Review_Documental_Investigation_Hub.md`; el seguimiento y los mockups están en `docs/Files/`, y las imágenes en `docs/img/`.

1. Usa esta ficha como fuente de verdad; no la copies a otra ruta.
2. Mantén `docs/Files/IMPLEMENTATION_STATUS.md` con historias `[ ]`, `[~]`, `[x]`, hash de commit, tests ejecutados y bloqueos.
3. Guarda las decisiones de arquitectura en un ADR del repositorio de implementación, distinguiendo decisiones verificadas de suposiciones.
4. Nunca cambies rutas, nombres de modelos o tablas de otra funcionalidad sin tests de regresión.
5. No subas secretos ni corpus sensible al repositorio. Usa fixtures ficticios y `.env.example`.

**Prompt de arranque recomendado para Codex:**

> Implementa solamente la historia `RV-INV-XXX` de `docs/Features/Review_Documental_Investigation_Hub.md`. Antes de editar, inspecciona el stack real y los patrones de autenticación, rutas, migraciones, tests y UI del repositorio. Describe brevemente los cambios necesarios y dependencias; no implementes otras historias. Reutiliza los componentes existentes. Añade migraciones reversibles, tests y documentación. Ejecuta las pruebas pertinentes. Al finalizar, reporta archivos modificados, comandos ejecutados, riesgos pendientes y actualiza `docs/Files/IMPLEMENTATION_STATUS.md`. No hardcodees secretos ni invoques proveedores reales en tests.

**Estrategia de tokens de desarrollo:** comenzar con modelos de codificación de costo/cuota menor; reservar modelos de mayor razonamiento para revisar decisiones de seguridad, arquitecturas de cola y bugs difíciles. Los modelos del producto en producción utilizan **API keys propias** y presupuestos de servidor, independientes de los límites de Codex.

## 8. Despliegue, migración y rollback

**Local:** Docker Compose reutilizando PostgreSQL/Sails/administración existente; añadir un contenedor worker Python y otro de OCR; Ollama opcional en host GPU, accesible solo por red privada; S3 real en entorno de pruebas o simulador bajo perfil, sin contaminar producción.

**AWS:** mantener EC2/API y RDS actual, verificar `pg_trgm`, `unaccent` y `vector` disponibles en esa versión. Guardar archivos en bucket S3 existente con rutas segmentadas e IAM de privilegio mínimo. Secretos en KMS/Secrets Manager si disponible; presupuestar costos de almacenamiento, egress, OCR/CPU y llamadas a modelos.

**Despliegue progresivo:** flags off por defecto → migración DB → deploy APIs/workers → piloto con 1 investigación → métricas → habilitar general. Rollback desactiva flags y workers sin eliminar tablas ni originales. Definir backup/recovery de RDS y S3; no hacer migrations destructivas durante MVP.

**Operación:** logs estructurados con `request_id`, `investigation_id`, `job_id` y `model_id` sin secretos ni texto sensible; alertas por DLQ, tasas OCR, costos y backlog; retention y delete por política, auditoría de reviews.

## 9. Riesgos, decisiones pendientes y definición de éxito

| Tema | Riesgo / decisión necesaria |
|---|---|
| Admin UI | Verificar stack real y guardas existentes; no asumir que es Next.js únicamente por el resto del proyecto |
| Conexión al nodo | Determinar si el equipo personal podrá procesar material confidencial; cifrado y política de retención |
| RTX 4070 SUPER | Benchmarks reales por modelo cuantizado, throughput, VRAM, OCR y carga simultánea; no asegurar 14B fluido |
| Precios/API | Precios varían por modelo y proveedor; no fijar precios ni número de tokens como verdad permanente |
| AWS RDS | Compatibilidad real con `pgvector`, extensiones y tamaño del corpus |
| Evaluación | Preparar dataset etiquetado por científicos para medir precisión y falsos negativos |
| Documentos regulatorios | Un estudio ambiental no equivale a autorización; exigir resolución verificable |
| Prompt injection | Documentos y links no confiables; no permitir que contenido externo elija herramientas o cambie permisos |

**Métricas de éxito:** ≥99% de documentos legibles procesados o explícitamente reportados como error; 100% de respuestas factuales con una o más fuentes o con estado insuficiente; 0 consultas de usuario sin permiso que extraigan información; 0 llamadas LLM de pago para filtros deterministas; 100% de gasto externo registrado y bloqueado al superar política; revisión de falsos negativos con corpus etiquetado antes de afirmaciones exhaustivas. Los umbrales de rendimiento y precisión se fijarán tras la línea base.

## 10. Referencias técnicas (para el implementador)

- pgvector y búsqueda híbrida: https://github.com/pgvector/pgvector
- PostgreSQL full-text search: https://www.postgresql.org/docs/current/textsearch.html
- Ollama API: https://docs.ollama.com/api
- LiteLLM Proxy (opcional): https://docs.litellm.ai/docs/proxy/virtual_keys
- AWS Secrets Manager: https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html
- PyMuPDF: https://pymupdf.readthedocs.io/
- openpyxl: https://openpyxl.readthedocs.io/
- OCRmyPDF: https://ocrmypdf.readthedocs.io/

**Entregables asociados:** `docs/Files/mockups.html` (navegable, sin backend), `docs/img/mockup_*.png` (capturas) y esta épica. Las capturas contienen datos de demostración: no constituyen hallazgos reales.
