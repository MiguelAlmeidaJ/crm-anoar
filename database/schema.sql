-- MySQL 8.0+, charset utf8mb4, InnoDB
CREATE TABLE tenants (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(180) NOT NULL,
  slug VARCHAR(120) NOT NULL UNIQUE,
  status ENUM('active','suspended') NOT NULL DEFAULT 'active',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE users (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(180) NOT NULL,
  email VARCHAR(254) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE tenant_users (
  tenant_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  role ENUM('owner','admin','member') NOT NULL DEFAULT 'member',
  PRIMARY KEY (tenant_id,user_id),
  FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE contacts (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  tenant_id BIGINT UNSIGNED NOT NULL,
  owner_user_id BIGINT UNSIGNED NULL,
  name VARCHAR(180) NOT NULL,
  email VARCHAR(254) NULL,
  phone VARCHAR(40) NULL,
  company VARCHAR(180) NULL,
  temperature ENUM('cold','warm','hot') NOT NULL DEFAULT 'cold',
  source VARCHAR(80) NULL,
  notes TEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_contacts_tenant_id (tenant_id,id),
  INDEX idx_contacts_tenant_temperature (tenant_id,temperature),
  INDEX idx_contacts_tenant_email (tenant_id,email),
  CONSTRAINT fk_contacts_tenant FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE,
  CONSTRAINT fk_contacts_owner_membership FOREIGN KEY (tenant_id,owner_user_id)
    REFERENCES tenant_users(tenant_id,user_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE contact_activities (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  tenant_id BIGINT UNSIGNED NOT NULL,
  contact_id BIGINT UNSIGNED NOT NULL,
  actor_user_id BIGINT UNSIGNED NULL,
  kind ENUM('note','call','email','meeting','status_change') NOT NULL,
  description TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_activities_tenant_contact (tenant_id,contact_id),
  FOREIGN KEY (tenant_id,contact_id) REFERENCES contacts(tenant_id,id) ON DELETE CASCADE,
  FOREIGN KEY (tenant_id,actor_user_id) REFERENCES tenant_users(tenant_id,user_id) ON DELETE RESTRICT
) ENGINE=InnoDB;
