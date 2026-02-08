Opciones de feature
La implementación del módulo se mantiene escalable, priorizando en esta etapa la operación funcional de registro, administración, integración y visualización de datos ambientales desde el sistema administrativo.

Datos a almacenar
Implementado:

Mediciones vinculadas a estaciones y unidades ambientales.

Parámetros de medición configurables.

Metadatos operativos de estaciones y unidades.

Visualizaciones asociadas a paneles (Grafana).

Registros de carga y trazabilidad de entradas.

Planificado / parcial:

Curvas de calibración como estructura formal dentro del modelo de datos (si aún no están completamente estandarizadas).

Resultados derivados como entidad normalizada de análisis (si se requiere separar “resultado” de “medición”).

Conservación y exposición estructurada de archivos fuente tipo Excel como repositorio documental formal (si se decide ampliar la capa documental).

Entrada de Datos
Implementado (etapa actual):

Captura de datos a través de interfaz y CSV (Comma-Separated Values):

Ingreso manual vía formulario para usuarios individuales.

Ingreso automatizado vía CSV para usuarios y unidades de monitoreo.

Validaciones y registro de actividad.

Captura de datos a través de API (Application Programming Interface) para integraciones externas controladas.

Integración automática vía MQTT (Message Queuing Telemetry Transport) desde Unidades Ambientales.

Salida de Datos
Implementado:

Visualización mediante paneles dinámicos configurados en Grafana.

Herramienta de consulta de información ambiental desde administración.

Visualización del estado operativo de estaciones.

Exportación de datos por CSV desde el panel administrativo.

Planificado:

Índices de protección y métricas derivadas normalizadas (si se definen como modelo formal).

Validación adicional de construcción de gráficos nativos fuera de Grafana (solo si se decide duplicar visualización).

Exposición de Documentos
Implementado / parcial:

Trazabilidad de cargas y fuentes asociadas a registros administrativos.

Planificado:

Exposición estructurada de archivos tipo Excel como repositorio documental consultable (si se formaliza la capa documental).

Revisión de Resultados
Implementado / parcial:

Verificación operativa mediante consistencia entre:

Entradas registradas por CSV, formulario y API.

Datos recibidos por MQTT.

Paneles y visualizaciones configuradas.

Planificado:

Flujo formal de validación de “resultados” como entidad separada (si se requiere auditoría analítica más estricta).

Rules
Actualizadas según implementación:

Los datos deben almacenarse de manera granular, con trazabilidad asociada a estación, parámetro y fuente de ingreso (CSV/interfaz/API/MQTT).

Deben existir bitácoras de carga y modificaciones para auditoría operativa.

Se requiere monitoreo del estado de estaciones y mecanismos de alerta ante desconexión de fuentes.

El sistema debe soportar crecimiento dinámico del volumen de datos y de la configuración de estaciones/parámetros.

La conservación y exposición formal de archivos Excel se mantiene como requisito ampliable según la evolución del repositorio documental.

Requerimientos para iniciar proyecto
Cumplidos en esta etapa:

Prototipo operativo de estación/unidad de muestreo.

Página de administración para Justicia hídrica desde la ciencia comunitaria | Ríos Vivos .

Backend funcional.

Definición inicial del modelo de datos para estaciones, parámetros, visualizaciones e integraciones.

Entregables
Implementados:

Página para subida de datos con validaciones, usuarios y logs.

API para subida de datos para integraciones externas.

Gráficos dinámicos en la página mediante paneles configurados.

Visualización del estado de estaciones de monitoreo.

Registro y administración de estaciones físicas de monitoreo ambiental.

Registro y administración de parámetros de medición.

Registro y administración de visualizaciones en Grafana.

Herramienta de consulta de información ambiental.

Ingreso manual vía formulario.

Ingreso automatizado vía CSV.

Integración vía MQTT para datos automáticos desde Unidades Ambientales.

Exportación formal por CSV desde el panel.