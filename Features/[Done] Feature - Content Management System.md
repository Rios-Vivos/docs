# [Done] Feature: Content Management System

## Resumen
Administración y actualización dinámica del contenido público de “Justicia hídrica desde la ciencia comunitaria | Ríos Vivos” mediante el panel de administración en “Sign in | Jwt - Rios Vivos Admin”. Permite publicar, editar y organizar información institucional sin cambios de código ni nuevos despliegues del frontend.

## Alcance
### Páginas y elementos dinámicos
- Landing Page.
- Activities.
- Resources.
- Communities.
- Aliados.
- News.
- Logos.
- Datos de contacto.
- Políticas (Privacidad, Cookies, Uso de datos).
- Cada sección debe contar con CRUD, historial mínimo de cambios, validación de campos y previsualización cuando sea posible.

### Herramientas dinámicas externas
- Localización/multilenguaje del contenido público y del panel.
- Calendario de eventos (propio o conectado con Google/Microsoft).
- Multimedia mediante embeds de YouTube u otras fuentes.
- Archivos mediante almacenamiento en S3.
- Mapas y materiales de comunidades servidos desde S3.

## Rules y restricciones
- Toda modificación dinámica se realiza únicamente desde “Sign in | Jwt - Rios Vivos Admin”.
- Todo endpoint de la API requiere autenticación y autorización.
- Cuentas de administración e integraciones deben estar ligadas a correos institucionales de Ríos Vivos.
- Registrar auditoría de cambios: qué se modificó, quién y cuándo.
- El sitio público no debe tardar más de 1 segundo en cargar elementos dinámicos en condiciones normales.

## Requerimientos técnicos mínimos para iniciar
- Panel de administración para “Justicia hídrica desde la ciencia comunitaria | Ríos Vivos”.
- Backend para servicios de contenido, usuarios, roles y auditoría.
- Accesos y credenciales institucionales para integraciones con YouTube, Drive, Google y Microsoft.

## Criterios de calidad asociados
- Rendimiento: carga rápida de contenido dinámico; uso de caché cuando aplique.
- Seguridad: control de acceso por roles con trazabilidad completa.
- Mantenibilidad: estructura de contenidos reutilizable y preparada para nuevas páginas.
- Usabilidad: interfaz clara para personal no técnico con validaciones y ayudas de edición.

## Entregables del feature
- Traducción multilenguaje del contenido del sitio público y del panel de administración.
- Gestión de imágenes y recursos gráficos en infraestructura propia (S3).
- Gestión de actividades calendarizadas.
- Gestión de información sobre comunidades.
- Gestión de contenido de Activities en la página web.
- Gestión de Resources en la página web y conexión con Google Drive.
- Gestión de banners y contenido multimedia en la página web.
- Capacitación para modificación de contenido (incluye video).

## Resultado esperado
Ríos Vivos puede mantener actualizado el sitio institucional, publicar noticias y actividades, organizar recursos académicos y mejorar la comunicación con comunidades y donadores mediante un flujo controlado, seguro y auditable, sin depender del equipo técnico para cambios cotidianos.
