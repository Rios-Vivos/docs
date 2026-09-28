# [Done] Feature: Monitoreo

## Resumen
Módulo de registro, administración, integración y visualización de datos ambientales desde el sistema administrativo, diseñado para operar de forma escalable.

## Datos a almacenar
### Implementado
- Mediciones vinculadas a estaciones y unidades ambientales.
- Parámetros de medición configurables.
- Metadatos operativos de estaciones y unidades.
- Visualizaciones asociadas a paneles (Grafana).
- Registros de carga y trazabilidad de entradas.

### Planificado/parcial
- Curvas de calibración como estructura formal dentro del modelo de datos (si no están estandarizadas).
- Resultados derivados como entidad normalizada de análisis (separar “resultado” de “medición” si aplica).
- Conservación y exposición estructurada de archivos fuente tipo Excel como repositorio documental formal.

## Entrada de datos
### Implementado
- Captura vía interfaz y CSV:
  - Ingreso manual vía formulario para usuarios individuales.
  - Ingreso automatizado vía CSV para usuarios y unidades de monitoreo.
  - Validaciones y registro de actividad.
- Captura vía API para integraciones externas controladas.
- Integración automática vía MQTT desde unidades ambientales.

## Salida de datos
### Implementado
- Visualización mediante paneles dinámicos en Grafana.
- Herramienta de consulta de información ambiental desde administración.
- Visualización del estado operativo de estaciones.
- Exportación de datos por CSV desde el panel administrativo.

### Planificado
- Índices de protección y métricas derivadas normalizadas (si se definen como modelo formal).
- Validación adicional para gráficos nativos fuera de Grafana (solo si se decide duplicar visualización).

## Exposición de documentos
### Implementado/parcial
- Trazabilidad de cargas y fuentes asociadas a registros administrativos.

### Planificado
- Exposición estructurada de archivos Excel como repositorio documental consultable (si se formaliza la capa documental).

## Revisión de resultados
### Implementado/parcial
- Verificación operativa comparando:
  - Entradas registradas por CSV, formulario y API.
  - Datos recibidos por MQTT.
  - Paneles y visualizaciones configuradas.

### Planificado
- Flujo formal de validación de “resultados” como entidad separada (si se requiere auditoría analítica más estricta).

## Rules
- Los datos se almacenan de forma granular con trazabilidad a estación, parámetro y fuente de ingreso (CSV/interfaz/API/MQTT).
- Una etiqueta de estación representa una membresía de proyecto cuando se usa como filtro en Operaciones. Las etiquetas son texto libre, se comparan sin distinguir mayúsculas/minúsculas y no requieren prefijo; el selector muestra las etiquetas que ya existen en estaciones. Los grupos semilla usan nombres como `ITESO`, `calidad-aire` y `ZMG-aire`, no nombres de cuerpos de agua. Una estación sin etiqueta no pertenece a ningún proyecto y la vista sin selección conserva el alcance global.
- Mantener bitácoras de carga y modificaciones para auditoría operativa.
- Monitorear estado de estaciones y configurar alertas ante desconexión de fuentes.
- El sistema debe soportar crecimiento dinámico de volumen de datos y configuración de estaciones/parámetros.
- La conservación y exposición formal de archivos Excel se mantiene como requisito ampliable según evolucione el repositorio documental.

## Requerimientos para iniciar proyecto (cumplidos)
- Prototipo operativo de estación/unidad de muestreo.
- Página de administración para “Justicia hídrica desde la ciencia comunitaria | Ríos Vivos”.
- Backend funcional.
- Definición inicial del modelo de datos para estaciones, parámetros, visualizaciones e integraciones.

## Entregables
- Página para subida de datos con validaciones, usuarios y logs.
- API para subida de datos para integraciones externas.
- Gráficos dinámicos en la página mediante paneles configurados.
- Visualización del estado de estaciones de monitoreo.
- Registro y administración de estaciones físicas de monitoreo ambiental.
- Registro y administración de parámetros de medición.
- Registro y administración de visualizaciones en Grafana.
- Herramienta de consulta de información ambiental.
- Ingreso manual vía formulario.
- Ingreso automatizado vía CSV.
- Integración vía MQTT para datos automáticos desde unidades ambientales.
- Exportación formal por CSV desde el panel.
