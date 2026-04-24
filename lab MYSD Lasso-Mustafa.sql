Ciclo 1

Conceptos CRUD Morado 
CREATE TABLE Participante(
    id_participante NUMBER(5) NOT NULL,
    tipo_id         VARCHAR2(2) NOT NULL,
    numero_id       NUMBER(15) NOT NULL,
    pais            VARCHAR2(15) NOT NULL,
    correo          VARCHAR2(30) NOT NULL
);

CREATE TABLE Persona(
    persona_id NUMBER(5) NOT NULL,
    nombres    VARCHAR2(50) NOT NULL
);

CREATE TABLE Empresa(
    empresa_id  NUMBER(5) NOT NULL,
    razonSocial VARCHAR2(30) NOT NULL,
    persona_id  NUMBER(5)
);

CREATE TABLE Ciclista(
    ciclista_id NUMBER(5) NOT NULL,
    nacimiento  DATE NOT NULL,
    categoria   NUMBER(1) NOT NULL
);

Conceptos CRUD Naranja
CREATE TABLE Carrera(
    codigo_carrera VARCHAR2(20) NOT NULL,
    nombre         VARCHAR2(30) NOT NULL,
    pais           VARCHAR2(15) NOT NULL,
    categoria      NUMBER(1) NOT NULL,
    periodicidad   VARCHAR2(20) NOT NULL
);

CREATE TABLE Punto(
    orden           NUMBER(2) NOT NULL,
    nombre          VARCHAR2(10) NOT NULL,
    tipo            VARCHAR2(1) NOT NULL,
    distancia       NUMBER(8,2) NOT NULL,
    tiempoLimite    NUMBER(9),
    codigo_carrera  VARCHAR2(20) NOT NULL,
    nombre_version  VARCHAR2(5) NOT NULL
);

CREATE TABLE Segmento(
    nombre_segmento VARCHAR2(10) NOT NULL,
    tipo            VARCHAR2(1) NOT NULL,
    punto_inicio    NUMBER(2) NOT NULL,
    punto_fin       NUMBER(2) NOT NULL,
    codigo_carrera  VARCHAR2(20) NOT NULL,
    nombre_version  VARCHAR2(5) NOT NULL
);

CREATE TABLE PropiedadDe(
    p_id           NUMBER(5) NOT NULL,
    codigo_carrera VARCHAR2(20) NOT NULL,
    porcentaje     NUMBER(4,2) NOT NULL
);

Conceptos CRUD Aguamarina
CREATE TABLE VersionCarrera(
    nombre_version VARCHAR2(5) NOT NULL,
    fecha          DATE NOT NULL,
    codigo_carrera VARCHAR2(20) NOT NULL
);

CREATE TABLE ParticipaEn(
    ciclista_id    NUMBER(5) NOT NULL,
    nombre_version VARCHAR2(5) NOT NULL
);

CREATE TABLE EsOrganizador(
    p_id           NUMBER(5) NOT NULL,
    nombre_version VARCHAR2(5) NOT NULL
);

Conceptos CRUD Azul 
CREATE TABLE Registro(
    numero          NUMBER(5) NOT NULL,
    fecha           DATE NOT NULL,
    tiempo          NUMBER(9) NOT NULL,
    posicion        NUMBER(5) NOT NULL,
    revision        VARCHAR2(20),
    dificultad      VARCHAR2(1),
    comentario      VARCHAR2(200),
    ciclista_id     NUMBER(5) NOT NULL,
    nombre_version  VARCHAR2(5) NOT NULL,
    nombre_segmento VARCHAR2(10) NOT NULL
);

Conceptos CRUD Gris

CREATE TABLE Encuesta(
    id_encuesta     NUMBER(10) NOT NULL,
    criterio        VARCHAR2(1) NOT NULL,
    presupuesto     NUMBER(12) NOT NULL,
    valorIncentivo  NUMBER(12) NOT NULL,
    fechaInicio     DATE NOT NULL,
    fechaFin        DATE NOT NULL
);


Conceptos CRUD Rosado 

CREATE TABLE Evaluacion(
    id_ev             NUMBER(15) NOT NULL,
    fecha             DATE NOT NULL,
    puntuacion        NUMBER(1) NOT NULL,
    retroalimentacion VARCHAR2(200),
    estado            VARCHAR2(20) NOT NULL,
    p_id              NUMBER(5) NOT NULL,
    codigo_carrera    VARCHAR2(20) NOT NULL,
    id_encuesta       NUMBER(10) NOT NULL
);

CREATE TABLE Comentario(
    id_com        NUMBER(10) NOT NULL,
    contenido     VARCHAR2(200) NOT NULL,
    id_evaluacion NUMBER(15) NOT NULL
);


Atributos 

-- Participante
ALTER TABLE Participante ADD CONSTRAINT CK_TIPO_ID
CHECK (tipo_id IN ('CC','CE','NIT','PA'));

ALTER TABLE Participante ADD CONSTRAINT CK_CORREO
CHECK (correo LIKE '%@%.%');

-- Ciclista
ALTER TABLE Ciclista ADD CONSTRAINT CK_CATEGORIA
CHECK (categoria IN (1,2,3,4,5));

-- Carrera
ALTER TABLE Carrera ADD CONSTRAINT CK_CARRERA_CAT
CHECK (categoria IN (1,2,3,4,5));

ALTER TABLE Carrera ADD CONSTRAINT CK_PERIODICIDAD
CHECK (periodicidad IN ('Anual','Semestral','Trimestral','Bimestral','Irregular'));

-- Punto
ALTER TABLE Punto ADD CONSTRAINT CK_PUNTO_TIPO
CHECK (tipo IN ('P','L','H','A','M','V','C'));

-- Segmento
ALTER TABLE Segmento ADD CONSTRAINT CK_SEGMENTO_TIPO
CHECK (tipo IN ('L','M','C'));

-- Registro
ALTER TABLE Registro ADD CONSTRAINT CK_TIEMPO
CHECK (tiempo > 0);

ALTER TABLE Registro ADD CONSTRAINT CK_DIFICULTAD
CHECK (dificultad IN ('A','M','B'));

-- Evaluacion
ALTER TABLE Evaluacion ADD CONSTRAINT CK_PUNT
CHECK (puntuacion BETWEEN 1 AND 5);

Primarias 

ALTER TABLE Participante ADD PRIMARY KEY (id_participante);
ALTER TABLE Persona ADD PRIMARY KEY (persona_id);
ALTER TABLE Empresa ADD PRIMARY KEY (empresa_id);
ALTER TABLE Ciclista ADD PRIMARY KEY (ciclista_id);

ALTER TABLE Carrera ADD PRIMARY KEY (codigo_carrera);
ALTER TABLE VersionCarrera ADD PRIMARY KEY (nombre_version);

ALTER TABLE Punto ADD PRIMARY KEY (codigo_carrera, orden);
ALTER TABLE Segmento ADD PRIMARY KEY (nombre_segmento, nombre_version);

ALTER TABLE Registro ADD PRIMARY KEY (numero);
ALTER TABLE Encuesta ADD PRIMARY KEY (id_encuesta);
ALTER TABLE Evaluacion ADD PRIMARY KEY (id_ev);
ALTER TABLE Comentario ADD PRIMARY KEY (id_com);

Unicas

ALTER TABLE Participante ADD CONSTRAINT UK_DOC
UNIQUE (tipo_id, numero_id);

-- Evita duplicados de registro
ALTER TABLE Registro ADD CONSTRAINT UK_REG
UNIQUE (ciclista_id, nombre_segmento, nombre_version);

-- Evita duplicados de evaluación
ALTER TABLE Evaluacion ADD CONSTRAINT UK_EVAL
UNIQUE (p_id, codigo_carrera);

Foraneas 

-- Participante
ALTER TABLE Persona ADD FOREIGN KEY (persona_id)
REFERENCES Participante(id_participante);

ALTER TABLE Empresa ADD FOREIGN KEY (empresa_id)
REFERENCES Participante(id_participante);

ALTER TABLE Ciclista ADD FOREIGN KEY (ciclista_id)
REFERENCES Participante(id_participante);

-- Carrera
ALTER TABLE VersionCarrera ADD FOREIGN KEY (codigo_carrera)
REFERENCES Carrera(codigo_carrera);

ALTER TABLE Punto ADD FOREIGN KEY (nombre_version)
REFERENCES VersionCarrera(nombre_version);

-- Segmento (IMPORTANTE)
ALTER TABLE Segmento ADD FOREIGN KEY (codigo_carrera, punto_inicio)
REFERENCES Punto(codigo_carrera, orden);

ALTER TABLE Segmento ADD FOREIGN KEY (codigo_carrera, punto_fin)
REFERENCES Punto(codigo_carrera, orden);

-- Registro
ALTER TABLE Registro ADD FOREIGN KEY (ciclista_id)
REFERENCES Ciclista(ciclista_id);

ALTER TABLE Registro ADD FOREIGN KEY (nombre_segmento, nombre_version)
REFERENCES Segmento(nombre_segmento, nombre_version);

-- Evaluacion
ALTER TABLE Evaluacion ADD FOREIGN KEY (p_id)
REFERENCES Participante(id_participante);

ALTER TABLE Evaluacion ADD FOREIGN KEY (codigo_carrera)
REFERENCES Carrera(codigo_carrera);

ALTER TABLE Evaluacion ADD FOREIGN KEY (id_encuesta)
REFERENCES Encuesta(id_encuesta);

-- Comentario
ALTER TABLE Comentario ADD FOREIGN KEY (id_evaluacion)
REFERENCES Evaluacion(id_ev);

XTablas

DROP TABLE Comentario;
DROP TABLE Evaluacion;
DROP TABLE Encuesta;

DROP TABLE Registro;

DROP TABLE Segmento;
DROP TABLE Punto;
DROP TABLE VersionCarrera;

DROP TABLE PropiedadDe;
DROP TABLE Carrera;

DROP TABLE Ciclista;
DROP TABLE Empresa;
DROP TABLE Persona;
DROP TABLE Participante;

Consultas 

-- Consulta 1: registros ordenados
SELECT *
FROM Registro
ORDER BY tiempo;

-- Consulta 2: registros por ciclista
SELECT *
FROM Registro
WHERE ciclista_id = 1;

-- Consulta 3: evaluaciones por carrera
SELECT *
FROM Evaluacion
WHERE codigo_carrera = 'C01';

Tuplas 

-- Registro válido
INSERT INTO Registro 
VALUES (1, SYSDATE, 300, 1, NULL, 'A', 'OK', 1, 'V01', 'SEG1');

-- Registro inválido (duplicado)
INSERT INTO Registro 
VALUES (2, SYSDATE, 350, 1, NULL, 'A', 'ERROR', 1, 'V01', 'SEG1');

Acciones

-- Acción: registrar resultado de un ciclista
INSERT INTO Registro 
VALUES (3, SYSDATE, 400, 2, NULL, 'M', 'Correcto', 2, 'V01', 'SEG1');

-- Acción: registrar evaluación
INSERT INTO Evaluacion 
VALUES (10, SYSDATE, 5, 'Excelente', 'Publicada', 1, 'C01', 1);

Disparadores 

-- Evitar duplicados en Registro
CREATE OR REPLACE TRIGGER TRG_REGISTRO
BEFORE INSERT ON Registro
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Registro
    WHERE ciclista_id = :NEW.ciclista_id
      AND nombre_version = :NEW.nombre_version
      AND nombre_segmento = :NEW.nombre_segmento;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001,'Registro duplicado');
    END IF;
END;
/

-- Evitar duplicados en Evaluacion
CREATE OR REPLACE TRIGGER TRG_EVALUACION
BEFORE INSERT ON Evaluacion
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Evaluacion
    WHERE p_id = :NEW.p_id
      AND codigo_carrera = :NEW.codigo_carrera;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20002,'Evaluación duplicada');
    END IF;
END;
/

XDisparadores 

DROP TRIGGER TRG_REGISTRO;
DROP TRIGGER TRG_EVALUACION;