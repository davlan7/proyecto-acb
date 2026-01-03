-- ===========================================
-- PostgreSQL Database Schema - Escuela de Conducción ACB
-- Versión final, flexible y escalable
-- ===========================================

-- ===========================================
-- 1. Rol
-- ===========================================
CREATE TABLE rol (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    descripcion TEXT
);

-- ===========================================
-- 2. Usuario
-- ===========================================
CREATE TABLE usuario (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    genero VARCHAR(20),
    tipo_documento VARCHAR(50),
    numero_documento VARCHAR(50) UNIQUE,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(50),
    direccion TEXT,
    contrasena VARCHAR(255) NOT NULL,
    rol_id INTEGER NOT NULL REFERENCES rol(id)
);

-- ===========================================
-- 3. Tipo de Vehiculo
-- ===========================================
CREATE TABLE tipo_vehiculo (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    descripcion TEXT
);

-- ===========================================
-- 4. Vehiculo
-- ===========================================
CREATE TABLE vehiculo (
    id SERIAL PRIMARY KEY,
    placa VARCHAR(20) UNIQUE NOT NULL,
    marca VARCHAR(50),
    modelo VARCHAR(50),
    anio INTEGER,
    tipo_vehiculo_id INTEGER NOT NULL REFERENCES tipo_vehiculo(id),
    transmision VARCHAR(20),  -- manual, automático, etc.
    estado_vehiculo VARCHAR(50),
    capacidad INTEGER
);

-- ===========================================
-- 5. Curso
-- ===========================================
CREATE TABLE curso (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    horas_practicas_totales INTEGER NOT NULL,
    horas_teoricas_totales INTEGER NOT NULL,
    precio NUMERIC(12,2) NOT NULL,
    estado_curso VARCHAR(20) DEFAULT 'activo',
    CONSTRAINT chk_horas_practicas CHECK (horas_practicas_totales >= 0),
    CONSTRAINT chk_horas_teoricas CHECK (horas_teoricas_totales >= 0),
    CONSTRAINT chk_precio CHECK (precio >= 0)
);

-- ===========================================
-- 6. Metodo_pago
-- ===========================================
CREATE TABLE metodo_pago (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    descripcion TEXT
);

-- ===========================================
-- 7. Inscripcion
-- ===========================================
CREATE TABLE inscripcion (
    id SERIAL PRIMARY KEY,
    alumno_id INTEGER NOT NULL REFERENCES usuario(id),
    curso_id INTEGER NOT NULL REFERENCES curso(id) ON DELETE CASCADE,
    metodo_pago_id INTEGER NOT NULL REFERENCES metodo_pago(id),
    fecha_inscripcion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado_pago VARCHAR(20) DEFAULT 'pendiente',
    UNIQUE(alumno_id, curso_id)
);

-- ===========================================
-- 8. Sesion (horario dinámico)
-- ===========================================
CREATE TABLE sesion (
    id SERIAL PRIMARY KEY,
    inscripcion_id INTEGER NOT NULL REFERENCES inscripcion(id) ON DELETE CASCADE,
    instructor_id INTEGER REFERENCES usuario(id),
    vehiculo_id INTEGER REFERENCES vehiculo(id),
    inicio TIMESTAMP NOT NULL,
    fin TIMESTAMP NOT NULL,
    tipo VARCHAR(20) CHECK (tipo IN ('practica','teoria')),
    CONSTRAINT chk_horario CHECK (inicio < fin)
);

-- ===========================================
-- 9. Curso Especial (comodín)
-- ===========================================
-- Este registro se inserta para todas las inscripciones especiales
-- Evita NULL en curso_id y horas
INSERT INTO curso (nombre, horas_practicas_totales, horas_teoricas_totales, precio, estado_curso)
VALUES ('Curso Especial', 0, 0, 0, 'activo');
