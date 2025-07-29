## Aplicación Ecommerce usando FakeStore API

Aplicación que simula una tienda utilizando la API de FakeStore para mostrar productos, productos destacados, buscar productos por nombre y por categoría, simular un proceso de compra al agregarlos al carritos, inicio de sesión, registro de nuevos usuarios e información de contacto y soporte. 

### Tecnologías Usadas

- Flutter SDK 3.29.3
- Dart SDK 3.7.2
- Manejo de errores con Either
- Modelos inmutables con freezed
- Gestión de estado con riverpod
- Navegación automática con go_router
- Persistencia local con shared_preferences
- Inyección de dependencias con get_it + injectable

### Estructura del Proyecto

![alt text](<Captura de pantalla 2025-07-29 a la(s) 6.53.59 a.m..png>)

### Requisitos Previos

Tener Flutter y Dart instalados:

flutter --version
Flutter 3.29.3 • Dart 3.7.2


### Funcionalidades

- Inicio de sesión con nombre de usuario y contraseña
- Registro de usuario (Nombre de usuario, correo y contraseña)
- Pantalla principal con productos destacados
- Pantalla de detalle de producto con nombre de producto, descripción, calificación y precio
- Carrito de compras donde se pueden agregar o eliminar productos y se calcula el precio subtotal y el total de la compra
- Pantalla de búsqueda de productos por nombre
- Pantalla de soporte con la información de contacto de la tienda y preguntas frecuentes.
- Pantalla de búsqueda de productos por categoría

### Instrucciones de Ejecución

#### Clonar el repositorio:

git clone https://github.com/Marisolperez22/aplicativo-ecommerce.git

cd aplicativo-ecommerce

#### Obtener dependecias

flutter pub get

#### Generar código con build_runner:

flutter pub run build_runner build --delete-conflicting-outputs

#### Ejecutar la aplicación en emulador/dispositivo::

flutter run

O en navegador (Flutter Web)::

flutter run -d chrome



