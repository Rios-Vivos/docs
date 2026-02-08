Este feature habilita la administración y actualización dinámica del contenido público de Justicia hídrica desde la ciencia comunitaria | Ríos Vivos  mediante un panel de administración en el subdominio Sign in | Jwt - Rios Vivos Admin . El objetivo es permitir que personal autorizado de Ríos Vivos publique, edite y organice información institucional, recursos y elementos multimedia sin requerir cambios de código ni nuevos despliegues del frontend.

La implementación contempla un sistema de gestión de contenido (CMS) de alcance controlado, orientado a contenidos estructurados del sitio y a integraciones externas necesarias para enriquecer secciones específicas.

Alcance funcional
1) Páginas y elementos que se vuelven dinámicos
El panel permitirá gestionar contenido para:

Landing Page

Activities

Resources

Communities

Aliados

News

Logos

Datos de contacto

Políticas de Privacidad

Políticas de Cookies

Políticas de uso de datos

Cada sección deberá contar con:

CRUD (Create, Read, Update, Delete) básico según aplique.

Versionado mínimo o historial de cambios.

Validación de campos y previsualización cuando sea posible.

2) Herramientas dinámicas externas
Se considera integrar o administrar:

Localización/multilenguaje del contenido público y del panel.

Calendario de eventos, con dos modalidades:

Propio.

Conectado con Google o Microsoft.

Multimedia (videos) mediante listados de embeds de YouTube u otras fuentes compatibles.

Archivos mediante almacenamiento en S3 (Amazon Simple Storage Service).

Mapas y materiales de comunidades servidos desde S3.

Reglas y restricciones
Toda modificación dinámica deberá realizarse exclusivamente desde Sign in | Jwt - Rios Vivos Admin .

Todo endpoint de la API (Application Programming Interface) requerirá autenticación y autorización.

Las cuentas utilizadas para administración e integraciones deberán estar ligadas a correos institucionales de Ríos Vivos.

El sistema deberá registrar auditoría de cambios: qué se modificó, quién lo modificó y cuándo.

El sitio público no deberá tardar más de 1 segundo en cargar elementos dinámicos en condiciones normales de operación.

Requerimientos técnicos mínimos para iniciar
Panel de administración para Justicia hídrica desde la ciencia comunitaria | Ríos Vivos .

Backend para servicios de contenido, usuarios, roles y auditoría.

Accesos y credenciales institucionales para integraciones con:

YouTube

Drive

Google

Microsoft

Criterios de calidad asociados
Rendimiento: carga rápida de contenido dinámico; uso de caché cuando aplique.

Seguridad: control de acceso por roles con trazabilidad completa.

Mantenibilidad: estructura de contenidos reutilizable por secciones y preparada para nuevas páginas.

Usabilidad: interfaz clara para personal no técnico con validaciones y ayudas de edición.

Entregables del feature
Traducción multilenguaje del contenido del sitio público y del panel de administración.

Gestión de imágenes y recursos gráficos en infraestructura propia (S3).

Gestión de actividades calendarizadas.

Gestión de información sobre comunidades.

Gestión de contenido de Activities en la página web.

Gestión de Resources en la página web y conexión con Google Drive.

Gestión de banners en la página web.

Gestión de contenido multimedia en la página web.

Capacitación para modificación de contenido.

Video de capacitación.

Resultado esperado
Con este feature, Ríos Vivos podrá mantener actualizado el sitio institucional, publicar noticias y actividades, organizar recursos académicos y mejorar la comunicación con comunidades y donadores, todo mediante un flujo controlado, seguro y auditable, sin depender directamente del equipo técnico para cambios cotidianos.