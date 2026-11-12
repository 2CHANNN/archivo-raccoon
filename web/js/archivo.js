const busqueda = document.querySelector("#busqueda");
const juego = document.querySelector("#juego");
const lista = document.querySelector("#lista");
const estado = document.querySelector("#estado");
const ficha = document.querySelector("#ficha");
const plantilla = document.querySelector("#tarjeta");
let escenarios = [];

function normalizar(texto) {
    return texto.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase().trim();
}

function codigo(id) {
    return "RC–" + String(id).padStart(3, "0");
}

async function leer(ruta) {
    const respuesta = await fetch(ruta);
    if (!respuesta.ok) {
        throw new Error("No se pudo consultar el archivo");
    }
    return respuesta.json();
}

async function abrirFicha(escenario) {
    const detalle = document.querySelector("#detalleFicha");
    ficha.dataset.id = escenario.id;
    document.querySelector("#codigoFicha").textContent = codigo(escenario.id) + " / " + escenario.juego;
    document.querySelector("#nombreFicha").textContent = escenario.nombre;
    detalle.textContent = "Cargando ficha…";
    ficha.showModal();
    try {
        const registro = await leer("/api/escenarios/" + escenario.id);
        if (ficha.dataset.id === String(escenario.id)) {
            detalle.textContent = registro.detalle;
        }
    } catch {
        if (ficha.dataset.id === String(escenario.id)) {
            detalle.textContent = "No se pudo cargar la ficha. Cierra el expediente y vuelve a abrirlo.";
        }
    }
}

function mostrarEscenarios() {
    const termino = normalizar(busqueda.value);
    const visibles = escenarios.filter(escenario =>
        normalizar(escenario.nombre).includes(termino) &&
        (!juego.value || juego.value === escenario.juego)
    );
    lista.replaceChildren();
    for (const escenario of visibles) {
        const tarjeta = plantilla.content.cloneNode(true);
        tarjeta.querySelector(".codigo").textContent = codigo(escenario.id);
        tarjeta.querySelector(".juego").textContent = escenario.juego;
        tarjeta.querySelector("h3").textContent = escenario.nombre;
        tarjeta.querySelector("p").textContent = escenario.descripcion;
        tarjeta.querySelector("button").setAttribute("aria-label", "Abrir expediente de " + escenario.nombre);
        tarjeta.querySelector("button").addEventListener("click", () => abrirFicha(escenario));
        lista.append(tarjeta);
    }
    estado.textContent = visibles.length
        ? "Mostrando " + visibles.length + " de " + escenarios.length + " expedientes"
        : "Sin coincidencias. Prueba otro nombre o cambia la entrega.";
}

async function iniciar() {
    try {
        escenarios = await leer("/api/escenarios");
        const entregas = new Set(escenarios.map(escenario => escenario.juego));
        for (const entrega of entregas) {
            juego.add(new Option(entrega, entrega));
        }
        busqueda.addEventListener("input", mostrarEscenarios);
        juego.addEventListener("change", mostrarEscenarios);
        mostrarEscenarios();
    } catch {
        estado.textContent = "No se pudo cargar el archivo. Comprueba el servidor y recarga la página.";
        busqueda.disabled = true;
        juego.disabled = true;
    }
}

iniciar();
