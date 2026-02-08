Feature: Load S3 images
Scenario: Open Landing Page
  When the visitante open the Landing Page
  Then the page request images to the images provider
 

Opciones de modulo de carga de imagenes

S3

Amazon Simple Storage Service (Amazon S3) es un servicio de almacenamiento de objetos que ofrece escalabilidad, disponibilidad de datos, seguridad y rendimiento líderes en el sector. Millones de clientes de todos los tamaños y sectores pueden almacenar, administrar, analizar y proteger cualquier cantidad de datos para prácticamente cualquier caso de uso, como los lagos de datos, las aplicaciones nativas en la nube y las aplicaciones móviles. Gracias a las clases de almacenamiento rentables y a las características de administración fáciles de usar, es posible optimizar los costos, organizar y analizar los datos y configurar controles de acceso detallados para cumplir con requisitos empresariales y de conformidad específicos.

Costos

image-20250302-232418.png
Referencias

Precios de S3 

 

Cloudflare R2 Storage

It allows developers to store large amounts of unstructured data without the costly egress bandwidth fees associated with typical cloud storage services.

You can use R2 for multiple scenarios, including but not limited to:

Storage for cloud-native applications

Cloud storage for web content

Storage for podcast episodes

Data lakes (analytics and big data)

Cloud storage output for large batch processes, such as machine learning model artifacts or datasets

Costos

image-20250302-231830.png
image-20250302-231902.png
Referencias

Pricing 

 

Elección Final

Se selecciono al servicio de S3 en AWS ya que gran parte de la infraestructura se encuentra en AWS y ademas por la facilidad con la que se pueden encontrar herramientas que accedan a S3.

 

Plan de Implementación

El frontend deberá ser cargado con un componente que permita consumir imagenes desde un s3 de manera segura (hay casos como en next.js donde esto se hace automatico con un .env). Puede que sea necesario algun token de seguridad para desbloquear la imagen.

Tambien se modificara la provision de las imagenes que ya se encuentran en la pagina con el nuevo componente