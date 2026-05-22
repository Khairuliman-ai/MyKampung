-- ==========================================
-- SKRIP MIGRASI MANUAL: LAPORAN SNAPSHOT
-- ==========================================
-- Sila jalankan skrip ini secara manual di phpMyAdmin atau MySQL CLI.
-- Skrip ini akan mencipta jadual `laporan_snapshot` dan memasukkan dummy data sejarah
-- dari bulan Januari hingga April 2026 untuk menyokong visualisasi trend bulanan.

CREATE TABLE IF NOT EXISTS `laporan_snapshot` (
  `id_snapshot` INT AUTO_INCREMENT PRIMARY KEY,
  `tahun` INT NOT NULL,
  `bulan` INT NOT NULL,
  `total_penduduk` INT NOT NULL,
  `total_bantuan_dipohon` INT NOT NULL,
  `total_bantuan_diluluskan` INT NOT NULL,
  `total_aduan_diterima` INT NOT NULL,
  `total_aduan_selesai` INT NOT NULL,
  `total_tempahan_fasiliti` INT NOT NULL,
  `purata_pendapatan` DECIMAL(10,2) NOT NULL,
  `snapshot_pada` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `unique_tahun_bulan` (`tahun`, `bulan`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Memasukkan data simulasi sejarah bulanan (Januari - April 2026)
INSERT INTO `laporan_snapshot` (`tahun`, `bulan`, `total_penduduk`, `total_bantuan_dipohon`, `total_bantuan_diluluskan`, `total_aduan_diterima`, `total_aduan_selesai`, `total_tempahan_fasiliti`, `purata_pendapatan`) VALUES
(2026, 1, 140, 5, 3, 4, 3, 10, 2450.00),
(2026, 2, 145, 8, 5, 6, 4, 15, 2480.00),
(2026, 3, 150, 10, 7, 7, 5, 18, 2400.00),
(2026, 4, 156, 12, 9, 8, 6, 22, 2380.00)
ON DUPLICATE KEY UPDATE 
  total_penduduk=VALUES(total_penduduk),
  total_bantuan_dipohon=VALUES(total_bantuan_dipohon),
  total_bantuan_diluluskan=VALUES(total_bantuan_diluluskan),
  total_aduan_diterima=VALUES(total_aduan_diterima),
  total_aduan_selesai=VALUES(total_aduan_selesai),
  total_tempahan_fasiliti=VALUES(total_tempahan_fasiliti),
  purata_pendapatan=VALUES(purata_pendapatan);
