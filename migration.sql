-- High-frequency notification queries (polled every 30s per user)
CREATE INDEX idx_notifikasi_pengguna_baca ON notifikasi(id_pengguna, sudah_baca);
CREATE INDEX idx_notifikasi_pengguna_tarikh ON notifikasi(id_pengguna, dibuat_pada DESC);

-- Aduan listing filters
CREATE INDEX idx_aduan_pengguna ON aduan(id_pengguna, dipadam_pada);
CREATE INDEX idx_aduan_pengendali ON aduan(id_pengendali, status, dipadam_pada);

-- Bantuan status filtering (dashboard counts)
CREATE INDEX idx_permohonan_status ON permohonan_bantuan(status);
