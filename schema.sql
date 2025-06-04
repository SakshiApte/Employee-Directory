-- Drop if exists for clean re-creation
DROP TABLE IF EXISTS certifications CASCADE;
DROP TABLE IF EXISTS experience CASCADE;
DROP TABLE IF EXISTS projects CASCADE;
DROP TABLE IF EXISTS tasks CASCADE;
DROP TABLE IF EXISTS skills CASCADE;

-- Employees table must be created first

--schema.sql 
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    profile_picture_url TEXT,
    designation_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    sub_department_id INTEGER NOT NULL,
    main_department_id INTEGER NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female')) NOT NULL,
    birth_date DATE NOT NULL,
    joining_date DATE NOT NULL,
    leaving_date DATE,
    employment_status VARCHAR(30) CHECK (
        employment_status IN (
            'active', 'temporary', 'part-time', 'full-time',
            'retired', 'fired', 'not active (temporary)', 'out of country'
        )
    ) NOT NULL,
    availability_status VARCHAR(30) CHECK (
        availability_status IN (
            'available', 'not available', 'on leave', 'in meeting',
            'on project', 'out of office'
        )
    ) NOT NULL,
    work_schedule VARCHAR(30) CHECK (
        work_schedule IN ('day shift', 'night shift', 'hybrid', 'remote', 'flexible')
    ) NOT NULL,
    company_id INTEGER NOT NULL,
    employee_unique_code VARCHAR(50) UNIQUE NOT NULL,
    previous_experience_years INTEGER,
    previous_companies_info TEXT,
    completed_projects INTEGER DEFAULT 0,
    active_projects INTEGER DEFAULT 0,
    average_rating DECIMAL(2,1) DEFAULT 0.0 CHECK (average_rating BETWEEN 0 AND 5),
    rating_count INTEGER DEFAULT 0,
    tasks_assigned INTEGER DEFAULT 0,
    tasks_completed INTEGER DEFAULT 0,
    tasks_pending INTEGER DEFAULT 0,
    CONSTRAINT fk_designation FOREIGN KEY (designation_id) REFERENCES designations(id),
    CONSTRAINT fk_role FOREIGN KEY (role_id) REFERENCES roles(id),
    CONSTRAINT fk_sub_department FOREIGN KEY (sub_department_id) REFERENCES sub_departments(id),
    CONSTRAINT fk_main_department FOREIGN KEY (main_department_id) REFERENCES main_departments(id)
);

-- Projects Table
CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    project_name VARCHAR(150) NOT NULL,
    project_description TEXT,
    project_status VARCHAR(30) CHECK (
        project_status IN ('active', 'completed', 'on hold', 'cancelled')
    ) DEFAULT 'active',
    assigned_date DATE,
    completed_date DATE,
    CONSTRAINT fk_project_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- Certifications Table
CREATE TABLE certifications (
    certification_id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    certification_name VARCHAR(150) NOT NULL,
    issuing_organization VARCHAR(150),
    issued_date DATE,
    expiration_date DATE,
    certification_url TEXT,
    CONSTRAINT fk_certification_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- Experience Table
CREATE TABLE experience (
    experience_id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    company_name VARCHAR(150) NOT NULL,
    role_held VARCHAR(100) NOT NULL,
    duration_years INTEGER,
    work_summary TEXT,
    start_date DATE,
    end_date DATE,
    CONSTRAINT fk_experience_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- Tasks Table
CREATE TABLE tasks (
    task_id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    task_title VARCHAR(150) NOT NULL,
    task_description TEXT,
    assigned_by INTEGER,
    assigned_date DATE DEFAULT CURRENT_DATE,
    due_date DATE,
    status VARCHAR(20) CHECK (status IN ('assigned', 'completed', 'pending')) DEFAULT 'assigned',
    completed_date DATE,
    CONSTRAINT fk_task_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    CONSTRAINT fk_task_assigner FOREIGN KEY (assigned_by) REFERENCES employees(employee_id)
);

-- Skills Table
CREATE TABLE skills (
    skill_id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    skill_name VARCHAR(100) NOT NULL,
    proficiency_level VARCHAR(50) CHECK (
        proficiency_level IN ('Beginner', 'Intermediate', 'Advanced', 'Expert')
    ),
    years_of_experience INTEGER,
    CONSTRAINT fk_skill_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- Table for Recently Viewed Profiles
CREATE TABLE IF NOT EXISTS user_views (
    id SERIAL PRIMARY KEY,
    viewer_employee_id INTEGER NOT NULL,
    viewed_employee_id INTEGER NOT NULL,
    viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_viewer FOREIGN KEY (viewer_employee_id) REFERENCES employees(employee_id),
    CONSTRAINT fk_viewed FOREIGN KEY (viewed_employee_id) REFERENCES employees(employee_id)
);

-- Table for Pinned Profiles
CREATE TABLE IF NOT EXISTS pinned_profiles (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    pinned_employee_id INTEGER NOT NULL,
    pinned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pinner FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    CONSTRAINT fk_pinned FOREIGN KEY (pinned_employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE IF NOT EXISTS announcements (
    id SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    message TEXT NOT NULL,
    posted_by INTEGER NOT NULL,
    target_audience VARCHAR(50) DEFAULT 'all', -- optional future use
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_poster FOREIGN KEY (posted_by) REFERENCES employees(employee_id)
);

