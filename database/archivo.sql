BEGIN TRANSACTION;

CREATE TABLE escenarios (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    juego TEXT NOT NULL,
    descripcion TEXT NOT NULL,
    detalle TEXT NOT NULL
);

INSERT INTO escenarios (id, nombre, juego, descripcion, detalle) VALUES
(1, 'Mansión Spencer', 'Resident Evil', 'Una residencia aislada en las montañas Arklay.', 'El equipo S.T.A.R.S. busca refugio aquí tras un ataque en el bosque. Las llaves con emblemas conectan alas de la mansión y obligan a volver sobre los propios pasos.'),
(2, 'Residencia del personal', 'Resident Evil', 'Un edificio de servicio al otro lado del patio.', 'Tras abandonar la mansión se llega a los dormitorios del personal. La investigación conduce hasta la Planta 42 y las instalaciones bajo la residencia.'),
(3, 'Comisaría de Raccoon City', 'Resident Evil 2', 'Un antiguo museo convertido en estación de policía.', 'El vestíbulo funciona como punto de regreso mientras se exploran oficinas, galerías y pasillos. Los tres medallones abren un paso bajo la estatua central en el remake.'),
(4, 'Alcantarillas', 'Resident Evil 2', 'Una red de túneles bajo las calles de la ciudad.', 'La sala de monitores reúne las piezas de ajedrez que abren el siguiente tramo en el remake. Los canales inferiores conectan zonas que desde arriba parecen separadas.'),
(5, 'Laboratorio NEST', 'Resident Evil 2', 'Un centro de investigación subterráneo de Umbrella.', 'En el remake, una plataforma central comunica las alas del complejo. La pulsera de identificación permite acceder a más salas a medida que aumenta el nivel de autorización.'),
(6, 'Torre del Reloj', 'Resident Evil 3', 'Un punto de evacuación en medio del brote.', 'En el juego original, Jill explora el interior de la torre para hacer sonar la campana y llamar al helicóptero de rescate.');

COMMIT;
