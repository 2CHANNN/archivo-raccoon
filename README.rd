# Archivo Raccoon

Evaluación 3 de Diseño Web · Luciano Olguin

Catálogo de seis escenarios de Resident Evil. Cada expediente identifica el juego al que pertenece, describe un lugar y permite abrir una ficha con más información.

## Cómo abrir el proyecto en Windows

1. Extrae el ZIP completo y abre la carpeta ArchivoRaccoon.
2. En la barra de dirección del Explorador escribe cmd y presiona Enter.
3. Con Python 3.9 o superior instalado, ejecuta:

       py -3 servidor.py

4. Mantén esa ventana abierta y entra en http://127.0.0.1:8000 desde tu navegador.
5. Presiona Ctrl+C en la terminal cuando termines.

En Linux o macOS el comando es python3 servidor.py. La aplicación utiliza la biblioteca estándar de Python y trae una copia local de Bootstrap 5.3.3.

## Cómo funciona

Al iniciar, servidor.py abre database/archivo.db con SQLite. Si la tabla escenarios todavía no existe, carga database/archivo.sql. El SQL también sirve para reconstruir el catálogo en una base SQLite vacía.

El navegador pide la lista a la API con fetch. JavaScript conserva los registros y dibuja las tarjetas. Al escribir o seleccionar un juego, combina los dos filtros y actualiza el DOM. Abrir una ficha hace una segunda consulta con el identificador del escenario.

## Archivos

- servidor.py atiende las rutas y consulta la base.
- database/archivo.sql contiene la tabla y los seis registros iniciales.
- web/index.html define la portada, el buscador y la plantilla de las tarjetas.
- web/css/estilo.css contiene los estilos propios.
- web/js/archivo.js carga, filtra y muestra los expedientes.
- web/vendor contiene Bootstrap y su licencia. La cuadrícula organiza filtros y tarjetas, y las clases del formulario dan estilo a sus controles.
- pruebas/resultados-thunder.txt conserva las respuestas reales de Thunder Client CLI.

## Repetir las pruebas en Thunder Client

Con el servidor abierto, inicia Thunder Client en Visual Studio Code. En New Request elige GET, pega una de estas direcciones y pulsa Send.

| Dirección | Resultado esperado |
| --- | --- |
| http://127.0.0.1:8000/api/escenarios | 200 OK y una lista con seis escenarios |
| http://127.0.0.1:8000/api/escenarios/1 | 200 OK y la ficha de la Mansión Spencer con su detalle |
| http://127.0.0.1:8000/api/escenarios/99 | 404 Not Found y el mensaje «Expediente no encontrado» |

## Entrega por Git

La carpeta incluye un repositorio Git local con un commit en main. Para publicarlo, crea un repositorio vacío en tu cuenta de GitHub y copia su URL HTTPS. Desde la carpeta ArchivoRaccoon, con Git instalado, ejecuta estas dos líneas reemplazando URL_DEL_REPOSITORIO por la dirección copiada:

    git remote add origin URL_DEL_REPOSITORIO
    git push -u origin main

Abre el repositorio en GitHub, verifica que aparezcan servidor.py y las carpetas y comparte el enlace con la profesora. Si el repositorio es privado, dale acceso.

## Demostración para la presentación

1. Abre el catálogo y enseña que aparecen los seis expedientes.
2. Selecciona Resident Evil 2. Quedarán tres. Escribe «comisaria» sin tilde y abre la única ficha que aparece.
3. Muestra database/archivo.sql y la función consultar de servidor.py para explicar de dónde sale la información.
4. En web/js/archivo.js muestra la función mostrarEscenarios. Explica que los filtros actúan sobre la lista ya cargada y que abrir una ficha sí vuelve a consultar al servidor.
5. Muestra en Thunder Client la diferencia entre pedir la ficha 1 y pedir la 99.
