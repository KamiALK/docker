-- DB mysql://root:kamiloalca@127.0.0.1:3306/SolarInfo
-- %DB mysql://root:kamiloalca@127.0.0.1:3306/SolarInfo


-- drop table SolarInfo.historial_transactions;
-- show tables;
-- CREATE TABLE historial_transactions (
--   `historial_transactions_id` INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
--   `Date/Time` TIMESTAMP,
--   `Gate` VARCHAR(100),
--   `Card number` INTEGER,
--   `Card type` VARCHAR(50),
--   `Operation explanation` VARCHAR(50),
--   `Direction` VARCHAR(100),
--   `Attention` BOOLEAN,
--   `Entry days` VARCHAR(100),
--   `Customer` VARCHAR (100),
--   `Event title` VARCHAR(100),
--   `Multiple entry` BOOLEAN,
--   `Entry type` VARCHAR(50)
-- );
--
-- show tables;

-- drop tabble if exists historial_transactions;

-- select * from historial_transactions ;

show databases;
use InstitucionDB;
-- CREATE DATABASE IF NOT EXISTS InstitucionDB; USE InstitucionDB; -- Crear la tabla de Estudiantes CREATE TABLE Estudiantes ( id_estudiante INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(50) NOT NULL, edad INT(3) NOT NULL, grado VARCHAR(10) NOT NULL ); -- Insertar datos en Estudiantes INSERT INTO Estudiantes (nombre,edad, grado) VALUES ('Ana Pérez', 12, '7°'), ('Carlos López', 13, '8°'), ('María Gómez', 11, '6°'), ('Javier Torres', 14, '9°'), ('Sofía Ramírez', 12, '7°'); -- Crear la tabla de Profesores CREATE TABLE Profesores ( id_profesor INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(50) NOT NULL, especialidad VARCHAR(50) NOT NULL ); -- Insertar datos en Profesores INSERT INTO Profesores (nombre, especialidad) VALUES ('Laura Martínez', 'Matemáticas'), ('Pedro Fernández', 'Ciencias'), ('Elena Rojas', 'Historia'), ('Juan Méndez', 'Inglés'); -- Crear la tabla de Materias CREATE TABLE Materias ( id_materia INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(50) NOT NULL, id_profesor INT, FOREIGN KEY (id_profesor) REFERENCES Profesores(id_profesor) ); -- Insertar datos en Materias INSERT INTO Materias (nombre, id_profesor) VALUES ('Matemáticas', 1), ('Ciencias', 2), ('Historia', 3), ('Inglés', 4); -- Crear la tabla de Calificaciones CREATE TABLE Calificaciones ( id_calificacion INT AUTO_INCREMENT PRIMARY KEY, id_estudiante INT, id_materia INT, nota DECIMAL(4,2), FOREIGN KEY (id_estudiante) REFERENCES Estudiantes(id_estudiante), FOREIGN KEY (id_materia) REFERENCES Materias(id_materia) ); -- Insertar datos en Calificaciones INSERT INTO Calificaciones (id_estudiante, id_materia, nota) VALUES (1, 1, 4.5), -- Ana en Matemáticas (1, 2, 3.8), -- Ana en Ciencias (2, 1, 4.2), -- Carlos en Matemáticas (3, 3, 3.5), -- María en Historia (4, 4, 4.0), -- Javier en Inglés (5, 2, 4.7); -- Sofía en Ciencias
-- CREATE DATABASE IF NOT EXISTS InstitucionDB; USE InstitucionDB;
-- Crear la tabla de Estudiantes 
-- CREATE TABLE Estudiantes ( id_estudiante INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(50) NOT NULL, edad INT(3) NOT NULL, grado VARCHAR(10) NOT NULL ); 
-- Insertar datos en Estudiantes 
-- INSERT INTO Estudiantes (nombre,edad, grado) VALUES ('Ana Pérez', 12, '7°'), ('Carlos López', 13, '8°'), ('María Gómez', 11, '6°'), ('Javier Torres', 14, '9°'), ('Sofía Ramírez', 12, '7°');
-- Crear la tabla de Profesores 
-- CREATE TABLE Profesores ( id_profesor INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(50) NOT NULL, especialidad VARCHAR(50) NOT NULL );
-- Insertar datos en Profesores 
-- INSERT INTO Profesores (nombre, especialidad) VALUES ('Laura Martínez', 'Matemáticas'), ('Pedro Fernández', 'Ciencias'), ('Elena Rojas', 'Historia'), ('Juan Méndez', 'Inglés');
-- Crear la tabla de Materias 
-- CREATE TABLE Materias ( id_materia INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(50) NOT NULL, id_profesor INT, FOREIGN KEY (id_profesor) REFERENCES Profesores(id_profesor) );
-- Insertar datos en Materias 
-- INSERT INTO Materias (nombre, id_profesor) VALUES ('Matemáticas', 1), ('Ciencias', 2), ('Historia', 3), ('Inglés', 4);
-- Crear la tabla de Calificaciones 
-- CREATE TABLE Calificaciones ( id_calificacion INT AUTO_INCREMENT PRIMARY KEY, id_estudiante INT, id_materia INT, nota DECIMAL(4,2), FOREIGN KEY (id_estudiante) REFERENCES Estudiantes(id_estudiante), FOREIGN KEY (id_materia) REFERENCES Materias(id_materia) );
-- Insertar datos en Calificaciones 
INSERT INTO Calificaciones (id_estudiante, id_materia, nota) VALUES (1, 1, 4.5)
-- INSERT INTO Calificaciones (id_estudiante, id_materia, nota) VALUES (1, 2, 3.8);
-- INSERT INTO Calificaciones (id_estudiante, id_materia, nota) VALUES (2, 1, 4.2);
-- INSERT INTO Calificaciones (id_estudiante, id_materia, nota) VALUES (3, 3, 3.5);
-- INSERT INTO Calificaciones (id_estudiante, id_materia, nota) VALUES (4, 4, 4.0);
-- INSERT INTO Calificaciones (id_estudiante, id_materia, nota) VALUES (5, 2, 4.7);
-- INSERT INTO Calificaciones (id_estudiante, id_materia, nota) VALUES (5, 2, 4.7);
select * from Estudiantes;
