Opciones de feature
La implementación de este módulo puede realizarse en diferentes etapas y en paralelo, priorizando mecanismos de captación de intención y escalando hacia procesamiento de pago y facturación cuando existan condiciones administrativas y bancarias.

Formulario de Colaboraciones (Implementado en esta etapa)
Mecanismo de captación de información de interesados en apoyar a Ríos Vivos bajo tres vías:

Donativos

En especie

Monetario (intención de monto)

Voluntariado

Alianzas y proyectos

Formulario para datos de contacto a donadores o benefactores
Puede considerarse como parte del formulario de colaboraciones o como flujo independiente en etapas futuras.

Flujo de Donación automatizado
Integración con pasarela externa para donaciones en línea.

Uso de plataformas de donación o depósito

Stripe

PayPal

GoFundMe (opcional según estrategia institucional)

Generación de facturas de donación
Flujo ligado a requisitos fiscales formales y validación de donantes.

Rules
Los datos de contacto capturados desde el sitio público:

Inician un flujo de comunicación manual para seguimiento institucional.

Podrán disparar una primera comunicación automatizada solicitando información adicional (opcional, sujeto a validación institucional).

Usar correo institucional de Ríos Vivos para notificaciones relacionadas con donación y/o emisión de recibos.

Los features Formulario de Colaboraciones y Donación automatizada deberán ser XOR (Exclusive OR) mediante Feature Flags, de modo que en producción se habilite uno u otro según la disponibilidad operativa.

La captura y consulta de datos de colaboraciones requiere autenticación en el sistema de administración.

Requerimientos para iniciar proyecto
Para Formulario de Colaboraciones (Etapa actual):

Backend para almacenamiento y consulta de registros.

Base de datos para colaboradores/donadores potenciales.

Panel administrativo para seguimiento.

Para Donación automatizada (Etapa futura):

Cuenta bancaria institucional habilitada.

Cuentas verificadas en plataformas de donación.

Diseño del flujo automatizado.

Cumplimiento fiscal aplicable.

Para Facturación (Etapa futura):

Cuentas registradas ante el SAT (Servicio de Administración Tributaria).

Proceso institucional formal para emisión de recibos de donación.

Entregables
Implementados en esta etapa:

Flujo de Formulario para contactos mediante Sección “Colaboraciones”, con rutas diferenciadas para:

Donativo en especie.

Donativo monetario (captación de intención y rangos).

Voluntariado.

Alianzas y proyectos.

Integración del flujo con el sistema administrativo para consulta y seguimiento institucional.

Planificados para etapas posteriores:

Botón de Donación automatizado (pasarela externa).

Integración de plataformas de donación:

Stripe como primera opción.

PayPal como respaldo.

Generación de facturas/recibos de donación.

Opciones de plataformas de donación (Referencia técnica)
Se mantienen las opciones evaluadas en el SRS original:

PayPal

Stripe

GoFundMe

Elección Final (Actualizada)
Se había definido Stripe como primera opción por su simplicidad de integración mediante una pasarela externa basada en URL, agregando posteriormente PayPal como plataforma de respaldo. Sin embargo, este flujo no pudo implementarse en esta etapa debido a la restricción institucional de no contar con una cuenta bancaria habilitada para la asociación.

Decisión de implementación en esta etapa
Dado el bloqueo operativo para habilitar pagos electrónicos, se implementó como alternativa funcional el Formulario de Colaboraciones, con el objetivo de:

Mantener activo un canal de captación de apoyo.

Obtener datos de contacto para seguimiento institucional.

Clasificar la intención de ayuda por tipo de colaboración.

Preparar la base operativa para la activación de donaciones automatizadas en una etapa posterior.

Plan de Implementación (Actualizado)
Etapa actual:

Implementación del formulario de colaboraciones y registro en base de datos.

Habilitación del acceso administrativo para consulta y seguimiento.

Etapa futura (condicionada):

Creación y verificación de cuentas en:

Stripe

PayPal

Habilitación de cuenta bancaria institucional.

Activación del feature flag para donación automatizada.

Implementación del flujo de recibos/facturación si aplica.

 

Opciones de plataformas de donación:
Paypal
El botón Donar de PayPal es una solución cómoda y económica para recaudar donativos en línea. 

Las organizaciones benéficas pueden utilizar PayPal a fin de recaudar donativos y pueden recibir una comisión con descuento. Para ello, necesitamos confirmar tu cuenta de organización benéfica.

Puedes comenzar el proceso de confirmación en https://www.paypal.com/charities. Tendrás que proporcionar información para validar lo siguiente:

Tu organización está legalmente registrada en la entidad reguladora correspondiente.

Eres representante de dicha organización.

Cuando los donantes hacen clic en el botón Donar, realizan el donativo en el sitio web de PayPal. No hay comisiones mensuales ni por configuración para recibir pagos mediante el botón de donativos. Tu organización solo paga las comisiones por procesamiento cuando recibe un donativo.

Otras funciones:

Los clientes pueden elegir hacer donativos mensuales de forma automática a tu organización. Tanto la organización como el cliente pueden controlar los pagos automáticos en sus respectivas configuraciones de perfil si desean cancelar o cambiar el importe.

El botón Donar está optimizado automáticamente para celulares, de tal forma que hacer pagos desde dispositivos pequeños sea más fácil.

Comision

image-20250302-215917.png
image-20250302-215939.png
image-20250302-220007.png
Referencia:

¿Cómo hago para aceptar donativos con PayPal? | PayPal MX 

Charity Confirmation 

 

Stripe
Stripe permite que los usuarios acepten donaciones electrónicas únicas o recurrentes a través de una página de pago segura alojada en Stripe llamada Payment Links. Los usuarios pueden crear una donación de importe fijo o permitir que los donantes elijan el importe configurando un enlace de pago en el Dashboard de Stripe. Payment Links se puede compartir por correo electrónico y redes sociales, o se puede agregar al sitio web y personalizar con marca y métodos de pago adicionales.

Entender las condiciones mínimas para aceptar propinas o donaciones por medio de Stripe

Debes cumplir con los siguientes requisitos para aceptar propinas o donaciones con Stripe Payments.

Propinas: la propina debe darse por un bien o servicio que se haya prestado (por ejemplo, contenido).

Donaciones: una donación debe estar vinculada a un fin benéfico concreto que te comprometes a cumplir. No puedes aceptar donaciones en nombre de otra persona que no seas tú mismo (pero puedes hacer que otra persona cumpla el fin benéfico en tu nombre) y las donaciones deben utilizarse para el fin benéfico descrito al donante.

Stripe no admite la transmisión de dinero personal o entre particulares (por ejemplo, el envío de dinero entre amigos). Para obtener más información sobre las empresas restringidas por Stripe Payments, consulta Empresas restringidas y prohibidas y el Contrato de servicios de Stripe

Al utilizar Stripe para aceptar propinas o donaciones, reconoces que estás al tanto de las leyes locales sobre transmisión de dinero y de las restricciones pertinentes relativas a donaciones a entidades no registradas, y que actúas de conformidad con ellas.

Inicia sesión en el Dashboard de Stripe para crear un enlace de pago nuevo.

Desde aquí, puedes optar por crear un enlace para una donación de importe fijo (ya sea recurrente o única) o permitir que los donantes elijan el importe que desean aportar (solo única):

Donación de importe fijo:

Selecciona productos o suscripciones en Seleccionar el tipo.

Selecciona + Agregar un producto nuevo.

Agrega el nombre o la descripción de tu causa, indica el precio deseado y selecciona si deseas que sea Recurrente o Única.

Permitir que los donantes elijan el importe:

Elige permitir que los clientes elijan qué pagar en Seleccionar el tipo.

Completa el título y la descripción de tu causa.

De forma opcional, puedes definir un importe preestablecido o los importes mínimo y máximo para el pago.

En Opciones avanzadas, puedes cambiar la llamada a la acción en la página de pagar a donar si esto se ajusta mejor a tu caso de uso.

Haz clic en Crear enlace.

Ahora puedes copiar la URL del enlace o convertir el enlace en un código QR que puedes compartir con los donantes para aceptar pagos.

Comision 

image-20250302-220218.png
Referencias

Cómo aceptar donaciones mediante Stripe : Stripe: ayuda y soporte 

Requisitos para aceptar propinas o donaciones : Stripe: ayuda y soporte 

 

GoFundMe

Aquí tienes todo lo necesario para que tu recaudación de fondos sea un éxito. Comienza a recaudar fondos en la principal plataforma de crowdfunding hoy mismo

Step 1

Nuestras herramientas te ayudan a crear una recaudación de fondos
Haz clic en el botón “Iniciar una recaudación de fondos de GoFundMe” para comenzar. Recibirás indicaciones para agregar detalles de la recaudación de fondos y establecer tu objetivo, que se puede cambiar en cualquier momento.

Step 2

Comparte el enlace de tu recaudación de fondos para llegar a los donantes
Una vez que la recaudación de fondos esté activa, comparte el enlace con amigos y familiares para comenzar a ganar impulso. También encontrarás recursos útiles para llevar a cabo tu recaudación de fondos en tu panel de GoFundMe.

Step 3

Recibe de forma segura los fondos que recaudes
Agrega tu información bancaria o invita a tu destinatario previsto a agregar la suya para comenzar a recibir fondos de forma segura. No es necesario que alcances tu objetivo de recaudación de fondos para comenzar a recibir fondos.

Comision

No hay ninguna comisión por comenzar a recaudar fondos en GoFundMe. Se deducirá automáticamente una comisión por transacción estándar (2.9 % + USD 0.30) de cada donación. ¡Y eso es todo! El resto del dinero va directamente a tu causa. Para obtener más información y calcular lo que recibirás, consulta la calculadora de precios de GoFundMe.

Referencias

Inicia un GoFundMe de fondos en GoFundMe - Crea una recaudación de fondos de crowdfunding 