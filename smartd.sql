CREATE DATABASE IF NOT EXISTS smartd
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE smartd;

CREATE TABLE agentes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE paquetes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  codigo VARCHAR(50) NOT NULL UNIQUE,
  descripcion VARCHAR(255) NULL,
  direccion_destino VARCHAR(255) NOT NULL,
  ciudad VARCHAR(120) NOT NULL,
  estado_region VARCHAR(120) NOT NULL,
  codigo_postal VARCHAR(20) NOT NULL,
  nombre_destinatario VARCHAR(150) NOT NULL,
  creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE entregas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  paquete_id INT NOT NULL,
  agente_id INT NOT NULL,
  estado ENUM('pendiente','entregado','cancelado') NOT NULL DEFAULT 'pendiente',
  notas VARCHAR(255) NULL,
  fecha_asignacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_entregado DATETIME NULL,
  CONSTRAINT fk_entregas_paquete
    FOREIGN KEY (paquete_id) REFERENCES paquetes(id),
  CONSTRAINT fk_entregas_agente
    FOREIGN KEY (agente_id) REFERENCES agentes(id)
);

CREATE TABLE evidencias_entrega (
  id INT AUTO_INCREMENT PRIMARY KEY,
  entrega_id INT NOT NULL,
  ruta_foto VARCHAR(255) NOT NULL,
  descripcion_foto VARCHAR(255) NULL,
  latitude DECIMAL(10,7) NOT NULL,
  longitude DECIMAL(10,7) NOT NULL,
  direccion_texto VARCHAR(255) NULL,
  creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_evidencia_entrega
    FOREIGN KEY (entrega_id) REFERENCES entregas(id)
);
