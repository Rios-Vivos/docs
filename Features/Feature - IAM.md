Opciones de feature
La implementación de control de acceso para Sign in | Jwt - Rios Vivos Admin  se compone de los siguientes subfeatures:

Registro de usuarios.

Autenticación (inicio de sesión).

Recuperación de contraseña.

Autorización basada en roles y permisos (RBAC, Role-Based Access Control).

Rules
Todo endpoint del sistema administrativo requiere autenticación.

Las acciones críticas requieren autorización por rol/permisos.

Las cuentas administrativas deben estar asociadas a correo institucional de Ríos Vivos.

Las contraseñas deben cumplir una política mínima de seguridad definida por el proyecto.

Debe existir registro de auditoría de inicios de sesión, intentos fallidos y eventos relevantes de seguridad.

Las sesiones deben expirar bajo una política definida y segura.

Requerimientos para iniciar proyecto
Backend para autenticación y autorización.

Base de datos de usuarios y roles.

Definición de roles iniciales y permisos por módulo.

Configuración del canal de correo para recuperación de cuenta.

Entregables
Flujo de registro de usuarios.

Flujo de inicio de sesión.

Flujo de recuperación de contraseña.

Modelo de roles y permisos aplicado al sistema administrativo.

Logs de seguridad para eventos de acceso.