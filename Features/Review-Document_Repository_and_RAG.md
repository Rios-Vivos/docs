# Base técnica: repositorio documental y chat

**Estado:** referencia técnica. La definición de producto, arquitectura y
backlog vigentes están en la [épica del hub de investigación documental](Review_Documental_Investigation_Hub.md).

Esta nota conserva hallazgos verificados que deben guiar `RV-INV-001`; no
define un stack alterno ni modifica las decisiones de la épica.

## Hallazgos comprobados

- El alcance de la propuesta vive en `docs`. La futura implementación de API
  pertenece principalmente a `system-api`.
- `system-admin` ya contiene la pantalla de biblioteca
  `/dashboard/management/rag/` (`MediaFileManagerView`) y el chat
  `/dashboard/rag/` (`ChatView`). Son puntos de integración, no prueba de que
  exista un backend RAG.
- La rama `main` revisada de `system-api` no contiene aún backend de búsqueda
  documental, modelo local ni RAG.
- Los archivos originales deben permanecer privados. La API entrega al worker
  una URL S3 firmada y de corta duración para una versión concreta del archivo.
- Un nodo local reclama trabajos aprobados por la API mediante una conexión
  privada saliente. No recibe conexiones públicas ni acceso directo a Redis,
  MQTT, Grafana, almacenamiento ni a tablas de aplicación.
- El acceso a datos de monitoreo requiere vistas revisadas y versionadas en
  `rag_reporting`, con una cuenta `SELECT` exclusiva para esas vistas. El
  modelo no redacta SQL libre.
- El estado guardado de trabajos es el registro confiable. WebSocket informa
  progreso en vivo y la interfaz puede consultar el estado después de recargar.

## Compatibilidad que debe preservar la épica

La implementación conserva las rutas existentes hasta que una migración
explícita las redirija al contexto de una investigación. Cada respuesta debe
mostrar la fuente autorizada: documento, versión y página, fila u otro
localizador; las respuestas basadas en monitoreo también citan la vista,
parámetros y hora de generación.

Los dos nodos locales descritos en la épica se registran y se enrutan según sus
capacidades. El nodo legado con Core i7 de cuarta generación y GTX 680 se
mantiene como capacidad CPU y GPU opcional validada; el nodo RTX 4070 SUPER
atiende las cargas locales que declaren esa capacidad. Ningún nodo sustituye a
`system-api`, PostgreSQL, MQTT ni Grafana.

## Validación inicial

Antes de importar un corpus amplio, validar con documentos autorizados y un
conjunto de preguntas revisadas que cada respuesta lleve a la versión y
fragmento correctos. Medir tiempos de cola, extracción, OCR, búsqueda y
respuesta; uso de disco, temperatura, energía, restauración de respaldos y
aislamiento entre investigaciones. Los resultados deciden qué capacidades se
habilitan para cada nodo.
