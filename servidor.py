import json
import sqlite3
from contextlib import closing
from pathlib import Path
from wsgiref.simple_server import make_server

RAIZ = Path(__file__).resolve().parent
BASE = RAIZ / "database" / "archivo.db"
ARCHIVOS = {
    "/": ("index.html", "text/html"),
    "/css/estilo.css": ("css/estilo.css", "text/css"),
    "/js/archivo.js": ("js/archivo.js", "text/javascript"),
    "/vendor/bootstrap.min.css": ("vendor/bootstrap.min.css", "text/css"),
}


def iniciar_base():
    with closing(sqlite3.connect(BASE)) as conexion:
        tabla = conexion.execute(
            "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'escenarios'"
        ).fetchone()
        if tabla is None:
            script = (RAIZ / "database" / "archivo.sql").read_text(encoding="utf-8")
            conexion.executescript(script)


def consultar(ruta):
    with closing(sqlite3.connect(BASE)) as conexion:
        conexion.row_factory = sqlite3.Row
        if ruta == "/api/escenarios":
            filas = conexion.execute(
                "SELECT id, nombre, juego, descripcion FROM escenarios ORDER BY id"
            )
            return "200 OK", [dict(fila) for fila in filas]

        prefijo = "/api/escenarios/"
        numero = ruta.removeprefix(prefijo)
        if ruta.startswith(prefijo) and numero.isascii() and numero.isdigit():
            fila = conexion.execute(
                "SELECT * FROM escenarios WHERE id = ?", (numero,)
            ).fetchone()
            if fila:
                return "200 OK", dict(fila)
            return "404 Not Found", {"error": "Expediente no encontrado"}
        return "404 Not Found", {"error": "Ruta no encontrada"}


def aplicacion(entorno, responder):
    ruta = entorno["PATH_INFO"]
    tipo = "application/json"
    cabeceras = []
    if entorno["REQUEST_METHOD"] != "GET":
        estado, datos = "405 Method Not Allowed", {"error": "Usa el método GET"}
        cabeceras.append(("Allow", "GET"))
    elif ruta in ARCHIVOS:
        archivo, tipo = ARCHIVOS[ruta]
        contenido = (RAIZ / "web" / archivo).read_bytes()
        estado = "200 OK"
    else:
        try:
            estado, datos = consultar(ruta)
        except sqlite3.Error:
            estado, datos = "500 Internal Server Error", {"error": "Error al consultar el archivo"}

    if tipo == "application/json":
        contenido = json.dumps(datos, ensure_ascii=False).encode("utf-8")
    cabeceras.extend([
        ("Content-Type", tipo + "; charset=utf-8"),
        ("Content-Length", str(len(contenido))),
    ])
    responder(estado, cabeceras)
    return [contenido]


if __name__ == "__main__":
    iniciar_base()
    with make_server("127.0.0.1", 8000, aplicacion) as servidor:
        print("Archivo Raccoon disponible en http://127.0.0.1:8000", flush=True)
        servidor.serve_forever()
