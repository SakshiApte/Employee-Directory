
-- Employee Directory Database Schema


-- ENUM Definitions
CREATE TYPE gender_enum AS ENUM ('male', 'female');

CREATE TYPE employment_status_enum AS ENUM (
  'active', 'intern', 'part-time', 'full-time', 'retired', 'fired', 'not active', 'on leave'
);

CREATE TYPE availability_status_enum AS ENUM (
  'in-office', 'remote', 'on vacation', 'out of country', 'work from home'
);

CREATE TYPE work_schedule_enum AS ENUM (
  'full-time', 'part-time', 'shift', 'contract', 'remote-flex'
);

CREATE TYPE role_enum AS ENUM (
  'intern',
  'trainee',
  'junior_developer',
  'assistant',
  'software_engineer',
  'qa_engineer',
  'system_admin',
  'hr_executive',
  'project_coordinator',
  'support_engineer',
  'senior_developer',
  'senior_qa',
  'hr_manager',
  'project_manager',
  'team_lead',
  'sales_manager',
  'department_head',
  'product_owner',
  'tech_architect',
  'company_admin',
  'super_admin',
  'reviewer',
  'auditor',
  'hr_assistant'
);

CREATE TYPE department_enum AS ENUM (
  'development_engineering',
  'frontend_team',
  'backend_team',
  'full_stack',
  'devops',
  'mobile_app_team',
  'qa_testing_team',
  'ai_ml_team',
  'human_resources',
  'recruitment',
  'payroll_finance_hr',
  'training_development',
  'employee_relations',
  'project_management',
  'product_owners',
  'scrum_masters',
  'project_coordinators',
  'it_support',
  'helpdesk_support',
  'network_admins',
  'hardware_infrastructure_support',
  'sales_marketing',
  'sales_executives',
  'digital_marketing',
  'seo_content',
  'admin_operations',
  'office_admin',
  'facilities_coordinator',
  'legal_compliance',
  'legal_advisor',
  'contract_specialist'
);

-- Create Companies Table
CREATE TABLE companies (
    id SERIAL PRIMARY KEY,
    company_name TEXT NOT NULL UNIQUE,
    description TEXT,
    industry_type TEXT,
    location TEXT,
    company_size TEXT,
    website_url TEXT,
    contact_email TEXT,
    contact_phone TEXT,
    logo_url TEXT,
    joined_on DATE DEFAULT CURRENT_DATE,
    left_on DATE,
    status TEXT,
    status_reason TEXT,
    status_updated_by TEXT,
    status_updated_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Departments Table
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    department_name TEXT NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Employees Table
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone_number TEXT,
    profile_picture_url TEXT,
    bio TEXT,

    -- Required Fields
    role role_enum,
    department department_enum,

    -- Company Reference
    company_id INTEGER REFERENCES companies(id) ON DELETE SET NULL,

    -- Personal Information
    gender gender_enum,
    birthdate DATE,
    age INTEGER, -- Auto-calculated from birthdate
    address TEXT,

    -- Employment Details
    joining_date DATE,
    leaving_date DATE,
    employment_status employment_status_enum,
    availability_status availability_status_enum,

    -- Skills and Certifications
    skills TEXT[],
    certifications JSON,

    -- Work Experience and Projects
    work_experience JSON,
    current_company_years INTEGER,
    projects JSON,
    achievements TEXT,
    ratings JSON,

    -- Scheduling and Admin Info
    work_schedule work_schedule_enum,
    tasks TEXT,
    profile_visibility BOOLEAN DEFAULT TRUE,
    performance_reviews JSON,
    salary_info JSON,

    -- Restricted Reason Logging
    status_reason TEXT,
    status_updated_by TEXT,
    status_updated_at TIMESTAMP,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
