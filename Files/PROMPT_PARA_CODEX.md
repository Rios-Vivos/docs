# Instrucción para cada sesión de Codex

Vas a implementar la historia `RV-INV-001` de [`Features/Review_Documental_Investigation_Hub.md`](../Features/Review_Documental_Investigation_Hub.md), la fuente de verdad de la épica en el repositorio `docs`.

Antes de escribir código:
1. Lee la historia y sus dependencias, y revisa `IMPLEMENTATION_STATUS.md`.
2. Inspecciona el repositorio real: identifica si el frontend administrativo usa React/Next.js/u otra tecnología, así como los patrones de Sails.js, rutas, autenticación JWT, roles/capabilities, manejo actual de S3, migraciones DB, tests y CI.
3. Reporta supuestos que el repositorio contradiga; no modifiques arquitectura global sin justificación.

Implementa **solo** esta historia (máximo un PR por sesión). Reutiliza el sistema visual oscuro, componentes y autenticación existente. Escribe el código y tests necesarios, migraciones reversibles, y actualiza documentación. No invoques servicios API pagos en pruebas. No introduzcas secretos o datos sensibles en git.

Verifica casos negativos (403, fuga de información entre investigaciones, límites y fallos de workers cuando apliquen). Ejecuta tests/linters existentes y documenta las restricciones que no puedes probar.

Al finalizar, actualiza `IMPLEMENTATION_STATUS.md` con ID de historia, checklist, archivos modificados, comandos/tests, hash de commit si existe, bloqueos y la siguiente historia sugerida. No declares historia completada si tests fallan.

**Importante:** No implementar múltiples historias en una sola petición de Codex aunque parezca sencillo. La prioridad es un avance retomable incluso si termina la cuota del modelo.
