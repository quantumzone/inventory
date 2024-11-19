# Sistema de Inventario de Equipos y Mantenimiento

[Repositorio del Proyecto](https://github.com/quantumzone/inventory)

## Resumen Ejecutivo

El sistema propuesto es una aplicación web para la gestión integral de inventario de equipos de cómputo y sus mantenimientos, desarrollada con Go/Gin en el backend y una interfaz moderna y responsive en el frontend.

## Módulos y Archivos del Sistema

### 1. Módulo de Autenticación
- **controllers/auth.go**: Sistema de autenticación JWT
- **middleware/auth.go**: Middleware de verificación de tokens
- **models/user.go**: Modelo de usuarios y roles
- **routes/auth_routes.go**: Rutas de autenticación
- **services/auth_service.go**: Lógica de negocio de autenticación

### 2. Módulo de Inventario
- **controllers/inventory.go**: Gestión de equipos
- **models/equipment.go**: Modelo de equipos y especificaciones
- **controllers/barcode.go**: Generación de códigos de barras
- **utils/csv_handler.go**: Importación/exportación CSV
- **routes/inventory_routes.go**: Rutas de inventario
- **services/inventory_service.go**: Lógica de negocio de inventario

### 3. Módulo de Mantenimiento
- **controllers/maintenance.go**: Gestión de mantenimientos
- **models/maintenance.go**: Modelo de tickets y seguimiento
- **controllers/files.go**: Manejo de archivos adjuntos
- **services/notification.go**: Sistema de notificaciones
- **routes/maintenance_routes.go**: Rutas de mantenimiento
- **services/maintenance_service.go**: Lógica de mantenimientos

### 4. Módulo de Reportes
- **controllers/reports.go**: Generación de reportes PDF
- **templates/reports/*.go**: Plantillas de reportes
- **services/excel.go**: Exportación a Excel
- **routes/reports_routes.go**: Rutas de reportes
- **services/reports_service.go**: Lógica de generación de reportes

### 5. Módulo de Auditoría
- **models/audit.go**: Registro de cambios
- **middleware/logger.go**: Logging de actividades
- **services/audit.go**: Servicios de auditoría
- **routes/audit_routes.go**: Rutas de auditoría

## Objetivos del Sistema
- Gestionar el inventario completo de equipos de cómputo
- Administrar mantenimientos preventivos y correctivos
- Proporcionar un sistema de tickets para solicitudes de mantenimiento
- Generar reportes específicos en formato PDF
- Permitir importación/exportación de datos
- Implementar sistema de códigos de barras para identificación de equipos
- Mantener un registro de auditoría de cambios

## Público Objetivo
- Administradores del sistema: Acceso completo
- Usuarios regulares: Captura y modificación de información básica

## Características y Funcionalidades Principales

### 1. Gestión de Usuarios
- Autenticación mediante correo y contraseña
- Dos niveles de acceso: Administrador y Usuario Regular
- Control de permisos granular por tipo de usuario
- Gestión de sesiones con JWT

### 2. Gestión de Inventario
- CRUD completo de equipos de cómputo
- Generación e impresión de códigos de barras
- Sistema de búsqueda y filtrado avanzado
- Importación de datos desde CSV
- Exportación de datos a Excel
- Registro de cambios para auditoría
- Validación de datos en tiempo real

### 3. Sistema de Mantenimientos
- Creación y seguimiento de tickets de mantenimiento
- Notificaciones en el sistema basadas en tiempo transcurrido
- Subida de archivos e imágenes en tickets
- Historial completo de mantenimientos por equipo
- Asignación de prioridades
- Seguimiento de estado de tickets

### 4. Reportes
- Total de equipos por uso
- Distribución por tipo de procesador
- Equipos conectados a internet
- Historial de mantenimientos
- Exportación a PDF
- Filtros personalizables
- Visualización de datos en gráficos

## Stack Tecnológico Recomendado

### Backend
- **Lenguaje**: Go 1.21+
- **Framework Web**: Gin 1.9+
- **Base de Datos**: PostgreSQL 15+
- **ORM**: GORM 2.0+
- **Autenticación**: JWT-Go
- **Generación PDF**: go-pdf
- **Manejo de archivos**: Go standar library (io)
- **Validación**: validator/v10
- **Logging**: zap

### Frontend
- **Framework**: Vue.js 3
- **UI Framework**: Tailwind CSS
- **Componentes**: PrimeVue
- **Gráficos**: Chart.js
- **Códigos de Barras**: vue-barcode
- **Estado**: Pinia
- **HTTP Client**: Axios
- **Validación**: Vuelidate

## Modelo de Datos Conceptual

### Tablas Principales
```sql
-- Ya definidas en el schema proporcionado:
- equipos_computo
- mantenimientos_equipo
- equipo_marcas
- equipo_procesadores
- equipo_ubicaciones
- equipo_responsables
- equipo_tipos

-- Nuevas tablas requeridas:
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    rol VARCHAR(50) NOT NULL,
    activo BOOLEAN DEFAULT true,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE historial_cambios (
    id SERIAL PRIMARY KEY,
    tabla VARCHAR(100) NOT NULL,
    registro_id INTEGER NOT NULL,
    usuario_id INTEGER REFERENCES usuarios(id),
    tipo_cambio VARCHAR(50) NOT NULL,
    datos_anteriores JSONB,
    datos_nuevos JSONB,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE notificaciones (
    id SERIAL PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    mensaje TEXT NOT NULL,
    usuario_id INTEGER REFERENCES usuarios(id),
    leida BOOLEAN DEFAULT false,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE archivos_mantenimiento (
    id SERIAL PRIMARY KEY,
    mantenimiento_id INTEGER REFERENCES mantenimientos_equipo(id),
    nombre_archivo VARCHAR(255) NOT NULL,
    ruta_archivo VARCHAR(500) NOT NULL,
    tipo_archivo VARCHAR(100) NOT NULL,
    tamano INTEGER NOT NULL,
    fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Principios de Diseño UI/UX
- Diseño responsive para todos los dispositivos
- Interfaz limpia y minimalista
- Sistema de navegación intuitivo
- Feedback visual para acciones importantes
- Diseño consistente en todas las páginas
- Accesibilidad WCAG 2.1
- Modo oscuro/claro
- Diseño orientado a tareas frecuentes

## Consideraciones de Seguridad
- Autenticación JWT con refresh tokens
- Validación de datos en frontend y backend
- Sanitización de entradas
- Control de acceso basado en roles
- Registro de auditoría para cambios críticos
- Manejo seguro de archivos subidos
- Protección contra XSS y CSRF
- Rate limiting
- Validación de sesiones
- Encriptación de datos sensibles

## Fases de Desarrollo

### Fase 1: Fundamentos (4 semanas)
#### Semana 1-2:
- Configuración del entorno de desarrollo
- Estructura base del proyecto
  - Revisar [estructura base](https://github.com/quantumzone/inventory/tree/main/src)
- Configuración de base de datos
  - Scripts en [database](https://github.com/quantumzone/inventory/tree/main/database)

#### Semana 3-4:
- Sistema de autenticación
  - Código base en [auth module](https://github.com/quantumzone/inventory/tree/main/src/auth)
- Configuración de logging y manejo de errores

### Fase 2: Funcionalidades Core (6 semanas)
#### Semana 5-6:
- CRUD de equipos
  - Código en [equipment module](https://github.com/quantumzone/inventory/tree/main/src/equipment)
- Validaciones y reglas de negocio

#### Semana 7-8:
- Sistema de códigos de barras
  - Implementación en [barcode module](https://github.com/quantumzone/inventory/tree/main/src/barcode)
- Integración con hardware de lectura

#### Semana 9-10:
- Gestión de mantenimientos
  - Código en [maintenance module](https://github.com/quantumzone/inventory/tree/main/src/maintenance)
- Sistema de tickets

### Fase 3: Funcionalidades Avanzadas (4 semanas)
#### Semana 11-12:
- Sistema de notificaciones
  - Implementación en [notifications](https://github.com/quantumzone/inventory/tree/main/src/notifications)
- Gestión de archivos
  - Código en [files module](https://github.com/quantumzone/inventory/tree/main/src/files)

#### Semana 13-14:
- Sistema de reportes
  - Implementación en [reports module](https://github.com/quantumzone/inventory/tree/main/src/reports)
- Exportación e importación de datos

### Fase 4: Refinamiento (2 semanas)
#### Semana 15:
- Pruebas de integración
  - Tests en [tests directory](https://github.com/quantumzone/inventory/tree/main/tests)
- Optimización de rendimiento

#### Semana 16:
- Documentación completa
  - Disponible en [docs](https://github.com/quantumzone/inventory/tree/main/docs)
- Preparación para producción

## Estándares de Código

### Documentación
#### Encabezado de Archivo
```go
/*
Package [nombre] implementa [descripción breve]

Este paquete proporciona funcionalidad para [descripción detallada]
Autor: [nombre]
Fecha: [fecha]
Version: [versión]
*/
```

#### Documentación de Funciones
```go
// NombreFuncion realiza [descripción de la acción]
// Parámetros:
//   - param1: descripción del parámetro 1
//   - param2: descripción del parámetro 2
// Retorna:
//   - tipo: descripción del valor retornado
//   - error: descripción de posibles errores
```

### Estructura de Archivos
Cada módulo debe contener:
- README.md con:
  - Descripción del módulo
  - Dependencias
  - Instrucciones de instalación
  - Ejemplos de uso
- Archivos de prueba (_test.go)
- Documentación de API
- Ejemplos de implementación

### Control de Versiones
- Commits descriptivos siguiendo Conventional Commits
- Tags semánticos para versiones
- Branches para features siguiendo GitFlow
- Pull requests documentados
- Code review obligatorio

## Desafíos Potenciales y Soluciones

### 1. Manejo de archivos adjuntos
- **Desafío**: Almacenamiento eficiente y seguro
- **Solución**: 
  - Sistema de archivos estructurado
  - Validación de tipos de archivo
  - Límites de tamaño
  - Compresión automática de imágenes

### 2. Generación de reportes PDF
- **Desafío**: Rendimiento con grandes conjuntos de datos
- **Solución**:
  - Generación asíncrona
  - Caché de reportes frecuentes
  - Paginación de datos

### 3. Rendimiento de base de datos
- **Desafío**: Consultas complejas y grandes volúmenes
- **Solución**:
  - Índices optimizados
  - Particionamiento de tablas
  - Caché de consultas frecuentes

### 4. Consistencia de datos
- **Desafío**: Validación y integridad
- **Solución**:
  - Validaciones en múltiples capas
  - Transacciones atómicas
  - Constraints en base de datos

## Posibilidades de Expansión Futura

### Fase 1: Mejoras de Funcionalidad
- Integración con correo electrónico
- API REST pública
- Dashboard analítico avanzado
- Sistema de reportes personalizable

### Fase 2: Optimizaciones
- Caché distribuido
- Balanceo de carga
- Replicación de base de datos
- Backup automatizado

### Fase 3: Características Avanzadas
- Machine Learning para predicción de mantenimientos
- Integración con IoT para monitoreo
- Sistema de inventario predictivo
- Automatización de procesos

## Métricas de Éxito
- Tiempo de respuesta < 2 segundos
- Disponibilidad > 99.9%
- Reducción del 50% en tiempo de gestión
- Tasa de adopción del sistema > 90%
- Satisfacción del usuario > 4.5/5
- Reducción de errores de inventario > 80%

## Monitoreo y Mantenimiento
- Logs centralizados
- Métricas de rendimiento
- Alertas automáticas
- Backups diarios
- Actualizaciones programadas
- Soporte técnico 8x5

Este documento debe ser revisado y actualizado regularmente conforme el proyecto avance y los requerimientos evolucionen.
