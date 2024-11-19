-- Tablas de catálogos básicos
-- Tabla de marcas de equipo
CREATE TABLE equipo_marcas (
    id SERIAL PRIMARY KEY,
    nombre_marca VARCHAR(255) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE equipo_procesadores (
    id SERIAL PRIMARY KEY,
    nombre_procesador VARCHAR(255) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE equipo_ubicaciones (
    id SERIAL PRIMARY KEY,
    nombre_ubicacion VARCHAR(255) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE equipo_responsables (
    id SERIAL PRIMARY KEY,
    nombre_completo VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE equipo_tipos (
    id SERIAL PRIMARY KEY,
    tipo_equipo VARCHAR(255) NOT NULL,
    descripcion TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla principal de equipos
CREATE TABLE equipos_computo (
-- Información básica
    id SERIAL PRIMARY KEY,
    fecha_alta DATE NOT NULL,
    identificador VARCHAR(255) NOT NULL UNIQUE,
    tipo_equipo_id INT NOT NULL REFERENCES equipo_tipos(id),
    status VARCHAR(50) NOT NULL DEFAULT 'Activo' CHECK (status IN ('Activo', 'Inactivo', 'En mantenimiento', 'Baja')),
    marbete VARCHAR(100) UNIQUE,
    descripcion TEXT,
    clasificacion VARCHAR(100),
    cantidad INT NOT NULL DEFAULT 1 CHECK (cantidad > 0),
    imagen VARCHAR(500),

-- Especificaciones técnicas
    marca_equipo_id INT REFERENCES equipo_marcas(id) ON DELETE SET NULL,
    modelo VARCHAR(100),
    serie VARCHAR(100) UNIQUE,

-- Almacenamiento
    tipo_disco VARCHAR(50) CHECK (tipo_disco IN ('SSD', 'HDD', 'NVMe')),
    tam_disco1 INT CHECK (tam_disco1 > 0),
    tam_disco2 INT CHECK (tam_disco2 > 0),

-- Memoria
    tipo_mem VARCHAR(50),
    tam_mem INT CHECK (tam_mem > 0),

-- Procesador
    tipo_procesador_id INT REFERENCES equipo_procesadores(id),
    desc_procesador VARCHAR(255),

-- Monitor
    tipo_monitor VARCHAR(100),
    tam_monitor INT CHECK (tam_monitor > 0),
    marca_monitor VARCHAR(100),
    serie_monitor VARCHAR(100) UNIQUE,
    marbete_monitor VARCHAR(100) UNIQUE,

-- Software
    sist_operativo VARCHAR(100),
    bits INT CHECK (bits IN (32, 64)),

-- Ubicación y responsable
    ip_asignada VARCHAR(15) CHECK (ip_asignada ~ '^(\d{1,3}\.){3}\d{1,3}$'),
    ubicacion_id INT REFERENCES equipo_ubicaciones(id),
    area VARCHAR(255) NOT NULL,
    responsable_id INT REFERENCES equipo_responsables(id),

-- Información administrativa
    fecha_adquisicion DATE NOT NULL,
    estado_bien VARCHAR(50) NOT NULL CHECK (estado_bien IN ('Nuevo', 'Usado', 'Obsoleto')),
    situacion VARCHAR(100),
    uso VARCHAR(100),
    documento VARCHAR(255),
    folio_documento VARCHAR(100),
    proveedor VARCHAR(255),

-- Información financiera
    precio_unitario DECIMAL(12,2) CHECK (precio_unitario >= 0),
    depreciacion DECIMAL(12,2),
    revaluacion DECIMAL(12,2),
    valor_actual DECIMAL(12,2),

-- Campos adicionales
    comentarios TEXT,
    mantenimientos TEXT,

-- Campos de auditoría
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

-- Restricciones
    CONSTRAINT fk_tipo_equipo FOREIGN KEY (tipo_equipo_id)
        REFERENCES equipo_tipos(id) ON DELETE RESTRICT
);

-- Tabla de mantenimientos
CREATE TABLE mantenimientos_equipo (
    id SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    tipo_mantenimiento VARCHAR(255) NOT NULL,
    equipo_id INT NOT NULL REFERENCES equipos_computo(id) ON DELETE CASCADE,
    descripcion TEXT,
    prioridad VARCHAR(50) CHECK (prioridad IN ('Alta', 'Media', 'Baja')),
    solicita_id INT REFERENCES equipo_responsables(id) ON DELETE SET NULL,
    status VARCHAR(50) CHECK (status IN ('Pendiente', 'En proceso', 'Completado', 'Cancelado')),
    actividad_realizada TEXT,
    presupuesto_requerido DECIMAL(12,2) CHECK (presupuesto_requerido >= 0),
    horas INT CHECK (horas > 0),
    requerimientos TEXT,
    resultado TEXT,
    responsable_id INT REFERENCES equipo_responsables(id) ON DELETE SET NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices para optimizar consultas frecuentes
CREATE INDEX idx_equipos_tipo ON equipos_computo(tipo_equipo_id);
CREATE INDEX idx_equipos_status ON equipos_computo(status);
CREATE INDEX idx_equipos_ubicacion ON equipos_computo(ubicacion_id);
CREATE INDEX idx_equipos_area ON equipos_computo(area);
CREATE INDEX idx_equipos_responsable ON equipos_computo(responsable_id);
CREATE INDEX idx_mantenimientos_equipo ON mantenimientos_equipo(equipo_id);
CREATE INDEX idx_mantenimientos_fecha ON mantenimientos_equipo(fecha);
CREATE INDEX idx_mantenimientos_status ON mantenimientos_equipo(status);

-- Trigger para actualizar fecha_actualizacion
CREATE OR REPLACE FUNCTION update_fecha_actualizacion()
RETURNS TRIGGER AS $$
BEGIN
    NEW.fecha_actualizacion = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_equipos_timestamp
    BEFORE UPDATE ON equipos_computo
    FOR EACH ROW
    EXECUTE FUNCTION update_fecha_actualizacion();

CREATE TRIGGER update_mantenimientos_timestamp
    BEFORE UPDATE ON mantenimientos_equipo
    FOR EACH ROW
    EXECUTE FUNCTION update_fecha_actualizacion();