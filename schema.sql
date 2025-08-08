-- schema.sql
CREATE DATABASE IF NOT EXISTS edu_course;
USE edu_course;

-- Users
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(150) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role ENUM('student','tutor','admin') DEFAULT 'student',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Kategori Kelas
CREATE TABLE IF NOT EXISTS kategori_kelas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama_kategori VARCHAR(150) NOT NULL,
  deskripsi TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Tutor (relasi ke user)
CREATE TABLE IF NOT EXISTS tutor (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  nama VARCHAR(150),
  bio TEXT,
  foto TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_tutor_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Produk / Kelas (course)
CREATE TABLE IF NOT EXISTS produk_kelas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama_kelas VARCHAR(200) NOT NULL,
  deskripsi TEXT,
  harga DECIMAL(12,2) DEFAULT 0,
  kategori_id INT,
  tutor_id INT,
  thumbnail TEXT,
  level ENUM('beginner','intermediate','advanced') DEFAULT 'beginner',
  durasi_total VARCHAR(100), -- misal "4 minggu" atau "10 jam"
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_produk_kategori FOREIGN KEY (kategori_id) REFERENCES kategori_kelas(id) ON DELETE SET NULL,
  CONSTRAINT fk_produk_tutor FOREIGN KEY (tutor_id) REFERENCES tutor(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Modul Kelas
CREATE TABLE IF NOT EXISTS modul_kelas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  produk_id INT NOT NULL,
  judul_modul VARCHAR(200),
  urutan_modul INT DEFAULT 0,
  deskripsi_modul TEXT,
  durasi VARCHAR(50),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_modul_produk FOREIGN KEY (produk_id) REFERENCES produk_kelas(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Pretest (soal sebelum/mulai kelas)
CREATE TABLE IF NOT EXISTS pretest (
  id INT AUTO_INCREMENT PRIMARY KEY,
  produk_id INT NOT NULL,
  soal JSON,             -- struktur soal disimpan sebagai JSON
  waktu_pengerjaan INT,  -- dalam menit
  jumlah_soal INT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_pretest_produk FOREIGN KEY (produk_id) REFERENCES produk_kelas(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Review
CREATE TABLE IF NOT EXISTS review (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  produk_id INT NOT NULL,
  rating INT CHECK (rating BETWEEN 1 AND 5),
  komentar TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_review_produk FOREIGN KEY (produk_id) REFERENCES produk_kelas(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Kelas Saya (enrollments)
CREATE TABLE IF NOT EXISTS kelas_saya (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  produk_id INT NOT NULL,
  tanggal_mulai DATE,
  progress FLOAT DEFAULT 0, -- persen
  status ENUM('aktif','selesai','batal') DEFAULT 'aktif',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_kelas_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_kelas_produk FOREIGN KEY (produk_id) REFERENCES produk_kelas(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Orders
CREATE TABLE IF NOT EXISTS orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  produk_id INT NOT NULL,
  status ENUM('pending','success','expired') DEFAULT 'pending',
  tanggal_order DATETIME DEFAULT CURRENT_TIMESTAMP,
  invoice_number VARCHAR(100),
  payment_due DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_orders_produk FOREIGN KEY (produk_id) REFERENCES produk_kelas(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Pembayaran (relasi ke orders)
CREATE TABLE IF NOT EXISTS pembayaran (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  metode ENUM('bank_transfer','ewallet','qris','other') DEFAULT 'bank_transfer',
  status_pembayaran ENUM('pending','verified','failed') DEFAULT 'pending',
  bukti_transfer TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_pembayaran_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Material (per modul)
CREATE TABLE IF NOT EXISTS material (
  id INT AUTO_INCREMENT PRIMARY KEY,
  modul_id INT NOT NULL,
  tipe ENUM('rangkuman','video','quiz','file','link') DEFAULT 'rangkuman',
  isi TEXT,   -- bisa menyimpan url, teks, atau JSON
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_material_modul FOREIGN KEY (modul_id) REFERENCES modul_kelas(id) ON DELETE CASCADE
) ENGINE=InnoDB;
