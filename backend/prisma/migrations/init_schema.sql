-- Creación de tablas para el sistema de reclutamiento

-- Tabla de Estados (Normalización de estados comunes)
CREATE TABLE status (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Tipos de Empleo (Normalización de tipos de empleo)
CREATE TABLE employment_type (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Empresas
CREATE TABLE company (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    website VARCHAR(255),
    industry VARCHAR(100),
    size VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Roles (Normalización de roles de empleados)
CREATE TABLE role (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Empleados
CREATE TABLE employee (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL REFERENCES company(id),
    role_id INTEGER NOT NULL REFERENCES role(id),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Tipos de Entrevista
CREATE TABLE interview_type (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Flujos de Entrevista
CREATE TABLE interview_flow (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Pasos de Entrevista
CREATE TABLE interview_step (
    id SERIAL PRIMARY KEY,
    interview_flow_id INTEGER NOT NULL REFERENCES interview_flow(id),
    interview_type_id INTEGER NOT NULL REFERENCES interview_type(id),
    name VARCHAR(100) NOT NULL,
    order_index INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Posiciones
CREATE TABLE position (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL REFERENCES company(id),
    interview_flow_id INTEGER NOT NULL REFERENCES interview_flow(id),
    employment_type_id INTEGER NOT NULL REFERENCES employment_type(id),
    status_id INTEGER NOT NULL REFERENCES status(id),
    title VARCHAR(100) NOT NULL,
    description TEXT,
    is_visible BOOLEAN DEFAULT true,
    location VARCHAR(100),
    job_description TEXT,
    requirements TEXT,
    responsibilities TEXT,
    salary_min NUMERIC(10,2),
    salary_max NUMERIC(10,2),
    benefits TEXT,
    application_deadline DATE,
    contact_info VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Candidatos
CREATE TABLE candidate (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(15),
    address VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Instituciones Educativas (Normalización de instituciones)
CREATE TABLE educational_institution (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    type VARCHAR(50),
    country VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Educación
CREATE TABLE education (
    id SERIAL PRIMARY KEY,
    candidate_id INTEGER NOT NULL REFERENCES candidate(id),
    institution_id INTEGER NOT NULL REFERENCES educational_institution(id),
    title VARCHAR(250) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Experiencia Laboral
CREATE TABLE work_experience (
    id SERIAL PRIMARY KEY,
    candidate_id INTEGER NOT NULL REFERENCES candidate(id),
    company VARCHAR(100) NOT NULL,
    position VARCHAR(100) NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Tipos de Archivo (Normalización de tipos de archivo)
CREATE TABLE file_type (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    extension VARCHAR(10) NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Currículums
CREATE TABLE resume (
    id SERIAL PRIMARY KEY,
    candidate_id INTEGER NOT NULL REFERENCES candidate(id),
    file_type_id INTEGER NOT NULL REFERENCES file_type(id),
    file_path VARCHAR(500) NOT NULL,
    upload_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Aplicaciones
CREATE TABLE application (
    id SERIAL PRIMARY KEY,
    position_id INTEGER NOT NULL REFERENCES position(id),
    candidate_id INTEGER NOT NULL REFERENCES candidate(id),
    resume_id INTEGER REFERENCES resume(id),
    status_id INTEGER NOT NULL REFERENCES status(id),
    application_date DATE NOT NULL DEFAULT CURRENT_DATE,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Resultados de Entrevista (Normalización de resultados)
CREATE TABLE interview_result (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Entrevistas
CREATE TABLE interview (
    id SERIAL PRIMARY KEY,
    application_id INTEGER NOT NULL REFERENCES application(id),
    interview_step_id INTEGER NOT NULL REFERENCES interview_step(id),
    employee_id INTEGER NOT NULL REFERENCES employee(id),
    result_id INTEGER REFERENCES interview_result(id),
    interview_date TIMESTAMP WITH TIME ZONE NOT NULL,
    score INTEGER,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Índices para mejorar el rendimiento

-- Índices básicos en claves foráneas
CREATE INDEX idx_employee_company_id ON employee(company_id);
CREATE INDEX idx_employee_role_id ON employee(role_id);
CREATE INDEX idx_position_company_id ON position(company_id);
CREATE INDEX idx_position_status_id ON position(status_id);
CREATE INDEX idx_position_employment_type_id ON position(employment_type_id);
CREATE INDEX idx_interview_step_flow_id ON interview_step(interview_flow_id);
CREATE INDEX idx_interview_step_type_id ON interview_step(interview_type_id);
CREATE INDEX idx_application_position_id ON application(position_id);
CREATE INDEX idx_application_candidate_id ON application(candidate_id);
CREATE INDEX idx_application_status_id ON application(status_id);
CREATE INDEX idx_interview_application_id ON interview(application_id);
CREATE INDEX idx_interview_employee_id ON interview(employee_id);
CREATE INDEX idx_interview_result_id ON interview(result_id);
CREATE INDEX idx_education_candidate_id ON education(candidate_id);
CREATE INDEX idx_education_institution_id ON education(institution_id);
CREATE INDEX idx_work_experience_candidate_id ON work_experience(candidate_id);
CREATE INDEX idx_resume_candidate_id ON resume(candidate_id);
CREATE INDEX idx_resume_file_type_id ON resume(file_type_id);

-- Índices compuestos para consultas frecuentes
CREATE INDEX idx_application_position_status ON application(position_id, status_id);
CREATE INDEX idx_interview_application_date ON interview(application_id, interview_date);
CREATE INDEX idx_position_company_status_visible ON position(company_id, status_id, is_visible);
CREATE INDEX idx_candidate_name ON candidate(first_name, last_name);
CREATE INDEX idx_employee_company_active ON employee(company_id, is_active);

-- Índices parciales para optimizar consultas específicas
CREATE INDEX idx_employee_active_company ON employee(company_id) WHERE is_active = true;
CREATE INDEX idx_position_visible_company ON position(company_id) WHERE is_visible = true;
CREATE INDEX idx_application_active_position ON application(position_id) WHERE status_id = (SELECT id FROM status WHERE name = 'ACTIVE');

-- Índices para búsquedas de texto
CREATE INDEX idx_position_title ON position(title);
CREATE INDEX idx_company_name ON company(name);
CREATE INDEX idx_educational_institution_name ON educational_institution(name);

-- Índices para ordenamiento
CREATE INDEX idx_interview_date ON interview(interview_date DESC);
CREATE INDEX idx_application_date ON application(application_date DESC);
CREATE INDEX idx_position_deadline ON position(application_deadline ASC);

-- Índices para campos de filtrado frecuente
CREATE INDEX idx_position_location ON position(location);
CREATE INDEX idx_position_salary_range ON position(salary_min, salary_max);
CREATE INDEX idx_candidate_email ON candidate(email);
CREATE INDEX idx_employee_email ON employee(email);

-- Índices para campos de agrupación
CREATE INDEX idx_application_status_date ON application(status_id, application_date);
CREATE INDEX idx_interview_result_date ON interview(result_id, interview_date);
CREATE INDEX idx_position_type_status ON position(employment_type_id, status_id);

-- Triggers para actualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Crear triggers para todas las tablas
DO $$
DECLARE
    t text;
BEGIN
    FOR t IN 
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_type = 'BASE TABLE'
    LOOP
        EXECUTE format('
            CREATE TRIGGER update_%s_updated_at
                BEFORE UPDATE ON %s
                FOR EACH ROW
                EXECUTE FUNCTION update_updated_at_column();
        ', t, t);
    END LOOP;
END;
$$ language 'plpgsql';

-- Consultas útiles optimizadas

-- 1. Consultas de Posiciones Activas
CREATE OR REPLACE VIEW active_positions AS
SELECT p.title, p.location, p.salary_min, p.salary_max,
       c.name as company_name, et.name as employment_type
FROM position p
JOIN company c ON p.company_id = c.id
JOIN employment_type et ON p.employment_type_id = et.id
WHERE p.is_visible = true
AND p.status_id = (SELECT id FROM status WHERE name = 'ACTIVE')
ORDER BY p.application_deadline ASC;

-- 2. Consultas de Candidatos
CREATE OR REPLACE VIEW candidate_applications AS
SELECT c.first_name, c.last_name, c.email,
       a.status_id, a.application_date,
       s.name as status_name
FROM candidate c
JOIN application a ON c.id = a.candidate_id
JOIN status s ON a.status_id = s.id
ORDER BY a.application_date DESC;

-- 3. Consultas de Entrevistas
CREATE OR REPLACE VIEW scheduled_interviews AS
SELECT i.interview_date, e.name as interviewer,
       c.first_name, c.last_name as candidate_name,
       its.name as interview_step,
       p.title as position_title
FROM interview i
JOIN application a ON i.application_id = a.id
JOIN employee e ON i.employee_id = e.id
JOIN candidate c ON a.candidate_id = c.id
JOIN interview_step its ON i.interview_step_id = its.id
JOIN position p ON a.position_id = p.id
WHERE i.interview_date >= CURRENT_DATE
ORDER BY i.interview_date ASC;

-- 4. Consultas de Aplicaciones
CREATE OR REPLACE VIEW active_applications AS
SELECT a.id, c.first_name, c.last_name, c.email,
       a.application_date, r.file_path as resume_path,
       p.title as position_title,
       s.name as status_name
FROM application a
JOIN candidate c ON a.candidate_id = c.id
LEFT JOIN resume r ON a.resume_id = r.id
JOIN position p ON a.position_id = p.id
JOIN status s ON a.status_id = s.id
WHERE a.status_id = (SELECT id FROM status WHERE name = 'ACTIVE')
ORDER BY a.application_date DESC;

-- 5. Consultas de Empleados Activos
CREATE OR REPLACE VIEW active_employees AS
SELECT e.name, e.email, r.name as role_name,
       COUNT(i.id) as interviews_scheduled,
       c.name as company_name
FROM employee e
JOIN role r ON e.role_id = r.id
JOIN company c ON e.company_id = c.id
LEFT JOIN interview i ON e.id = i.employee_id
WHERE e.is_active = true
GROUP BY e.id, r.name, c.name
ORDER BY interviews_scheduled DESC;

-- 6. Consultas de Historial Educativo
CREATE OR REPLACE VIEW candidate_education AS
SELECT c.first_name, c.last_name,
       ei.name as institution, e.title,
       e.start_date, e.end_date,
       ei.type as institution_type
FROM education e
JOIN candidate c ON e.candidate_id = c.id
JOIN educational_institution ei ON e.institution_id = ei.id
ORDER BY e.start_date DESC;

-- 7. Consultas de Experiencia Laboral
CREATE OR REPLACE VIEW candidate_experience AS
SELECT c.first_name, c.last_name, c.email,
       we.company, we.position, we.start_date, we.end_date,
       we.description
FROM work_experience we
JOIN candidate c ON we.candidate_id = c.id
ORDER BY we.start_date DESC;

-- 8. Consultas de Estadísticas
CREATE OR REPLACE VIEW application_statistics AS
SELECT s.name as status,
       COUNT(a.id) as total_applications,
       MIN(a.application_date) as first_application,
       MAX(a.application_date) as last_application,
       p.title as position_title,
       c.name as company_name
FROM application a
JOIN status s ON a.status_id = s.id
JOIN position p ON a.position_id = p.id
JOIN company c ON p.company_id = c.id
GROUP BY s.name, p.title, c.name
ORDER BY total_applications DESC;

-- Funciones útiles para consultas comunes

-- Función para buscar candidatos por nombre
CREATE OR REPLACE FUNCTION search_candidates(search_term TEXT)
RETURNS TABLE (
    candidate_id INTEGER,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255),
    total_applications BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT c.id, c.first_name, c.last_name, c.email,
           COUNT(a.id) as total_applications
    FROM candidate c
    LEFT JOIN application a ON c.id = a.candidate_id
    WHERE c.first_name ILIKE '%' || search_term || '%'
    OR c.last_name ILIKE '%' || search_term || '%'
    GROUP BY c.id
    ORDER BY total_applications DESC;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener estadísticas de entrevistas por empleado
CREATE OR REPLACE FUNCTION get_employee_interview_stats(employee_id INTEGER)
RETURNS TABLE (
    total_interviews BIGINT,
    upcoming_interviews BIGINT,
    average_score NUMERIC,
    last_interview_date TIMESTAMP WITH TIME ZONE
) AS $$
BEGIN
    RETURN QUERY
    SELECT COUNT(*) as total_interviews,
           COUNT(CASE WHEN i.interview_date >= CURRENT_DATE THEN 1 END) as upcoming_interviews,
           AVG(i.score) as average_score,
           MAX(i.interview_date) as last_interview_date
    FROM interview i
    WHERE i.employee_id = employee_id;
END;
$$ LANGUAGE plpgsql; 