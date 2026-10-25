CREATE TABLE IF NOT EXISTS departments (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(120) NOT NULL UNIQUE,
  description VARCHAR(500),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS employees (
  id BIGSERIAL PRIMARY KEY,
  employee_code VARCHAR(30) NOT NULL UNIQUE,
  full_name VARCHAR(160) NOT NULL,
  email VARCHAR(254) NOT NULL UNIQUE,
  phone VARCHAR(40),
  position VARCHAR(120) NOT NULL,
  department_id BIGINT REFERENCES departments(id) ON DELETE SET NULL,
  hire_date DATE NOT NULL DEFAULT CURRENT_DATE,
  status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active','on_leave','resigned')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS attendance (
  id BIGSERIAL PRIMARY KEY,
  employee_id BIGINT NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
  attendance_date DATE NOT NULL DEFAULT CURRENT_DATE,
  check_in TIME,
  check_out TIME,
  status VARCHAR(20) NOT NULL DEFAULT 'present' CHECK (status IN ('present','late','absent','leave')),
  note VARCHAR(500),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(employee_id, attendance_date)
);
CREATE INDEX IF NOT EXISTS idx_employees_department ON employees(department_id);
CREATE INDEX IF NOT EXISTS idx_attendance_date ON attendance(attendance_date);
INSERT INTO departments(name, description) VALUES
 ('Nhân sự', 'Tuyển dụng, hồ sơ và chính sách nhân sự'),
 ('Công nghệ thông tin', 'Phát triển và vận hành hệ thống'),
 ('Kinh doanh', 'Kinh doanh và chăm sóc khách hàng')
ON CONFLICT(name) DO NOTHING;
INSERT INTO employees(employee_code, full_name, email, phone, position, department_id, hire_date, status)
VALUES
 ('NV001','Nguyễn Minh Anh','minhanh@example.com','0901000001','Chuyên viên nhân sự',(SELECT id FROM departments WHERE name='Nhân sự'),CURRENT_DATE - 500,'active'),
 ('NV002','Trần Quốc Bảo','quocbao@example.com','0901000002','Lập trình viên',(SELECT id FROM departments WHERE name='Công nghệ thông tin'),CURRENT_DATE - 240,'active'),
 ('NV003','Lê Thu Hà','thuha@example.com','0901000003','Nhân viên kinh doanh',(SELECT id FROM departments WHERE name='Kinh doanh'),CURRENT_DATE - 100,'on_leave')
ON CONFLICT(employee_code) DO NOTHING;
