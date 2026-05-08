-- 1. Kemaskini struktur jadual untuk menyokong durasi string (HalfDay, FullDay)
ALTER TABLE `fasiliti_slot` MODIFY `durasi` VARCHAR(20) NOT NULL;

-- 2. Kosongkan data lama (jika ada)
TRUNCATE TABLE `fasiliti_slot`;

-- 3. Masukkan data slot default untuk Fasiliti ID 1 (Dewan Serbaguna)
-- Slot 2 Jam
INSERT INTO `fasiliti_slot` (`id_fasiliti`, `masa_mula`, `masa_tamat`, `durasi`) VALUES
(1, '08:00:00', '10:00:00', '2'),
(1, '10:00:00', '12:00:00', '2'),
(1, '12:00:00', '14:00:00', '2'),
(1, '14:00:00', '16:00:00', '2'),
(1, '16:00:00', '18:00:00', '2'),
(1, '18:00:00', '20:00:00', '2'),
(1, '20:00:00', '22:00:00', '2'),
(1, '22:00:00', '23:59:59', '2');

-- Slot HalfDay & FullDay
INSERT INTO `fasiliti_slot` (`id_fasiliti`, `masa_mula`, `masa_tamat`, `durasi`) VALUES
(1, '08:00:00', '14:00:00', 'HalfDay'),
(1, '08:00:00', '22:00:00', 'FullDay');

-- 4. Masukkan data untuk Fasiliti lain (ID 2 - Padang Bola)
INSERT INTO `fasiliti_slot` (`id_fasiliti`, `masa_mula`, `masa_tamat`, `durasi`) VALUES
(2, '08:00:00', '10:00:00', '2'),
(2, '10:00:00', '12:00:00', '2'),
(2, '16:00:00', '18:00:00', '2'),
(2, '20:00:00', '22:00:00', '2'),
(2, '08:00:00', '22:00:00', 'FullDay');
