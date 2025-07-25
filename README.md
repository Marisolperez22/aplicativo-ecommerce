# Aplicación de tienda usando FakeStore API

Aplicación en Flutter que simula una tienda. Permite al usuario hacer login, registrarse, ver los descuentos y productos destacados de la tienda, ver el detalle de un producto (nombre, descripción, precio, calificación), buscar artículos por nombre, agregar productos al carrito, buscar artículos por categoría, buscar soporte y cerrar sesión. 
Se utilizaron como base los siguientes paquetes:

- #### Sitema de diseño: https://github.com/Marisolperez22/atomic_desing_system.git
- #### Consumo de API: https://github.com/Marisolperez22/fake_store_get_request

### Tecnologías usadas
- Flutter SDK 3.29.3
- Dart SDK: 3.7.2
- Modelos inmutables con freezed
- Gestión de estado con Riverpod
- Navegación automática con go_router
- Manejo de resultados de la API con Either
- inyección de dependencias con getIt + Injectable

 ## Estructura del proyecto
 <img width="239" height="749" alt="image" src="https://github.com/user-attachments/assets/5176313c-4d78-4263-a233-8163557bb73c" />

 ## Requisitos previos
 - Tener Flutter y Dart instalados
   
 flutter -- version
 Flutter 3.29.3 · Dart 3.7.2

 ## Pantallas
 - ### Login:
El usuario puede iniciar sesión usando su nombre de usuario(UserName) y contraseña (Password). Referirse a la documentación oficial de [https://fakestoreapi.com/](https://fakestoreapi.com/docs) sección Users>Get all users para obtener las credenciales de los usuarios disponibles (Ya que al ser una API de prueba no permite guardar los datos de registro).
   
 - ### Registro:
El usuario puede registrarse a través de un formulario que solicita correo, nombre de usuario y contraseña (Recordar que al ser una API de prueba no permite guardar los datos de registro).

 - ### Pantalla principal:
Se muestran los descuentos y una lista de productos destacados. Cada producto muestra la imagen, el nombre del producto, el precio y la calificación, además de un botón que permite agregar el producto al carrito.

 - ### Pantalla de búsqueda:
Se muestra una barra de búsqueda donde el usuario puede encontrar un producto a través del nombre.

 - ### Pantalla de carrito:
Se muestran los productos agregados al carrito, la cantidad de productos agregados con la opción de agregar o remover el mismo producto, el subtotal y el total de la compra.

 - ### Pantalla de categorías
Permite al usuario buscar los productos por categoría

 - ### Pantalla de soporte:
Muestra información de contacto de la tienda y las respuestas a las preguntas más frequentes.


## Instrucciones de ejecución
1. Clonar el repositorio: 
   *git clone https://github.com/usuario/repositorio.git*

2. Obtener dependencias: 
   *flutter pub get*

3. Generar código con build_runner: 
   *flutter pub run build_runner build --delete-conflicting-outputs*

4. Ejecutar la aplicación en emulador/dispositivos: 
   *flutter run*

## Vista previa

