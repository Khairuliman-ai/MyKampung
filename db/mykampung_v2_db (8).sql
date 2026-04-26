-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 26, 2026 at 08:05 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mykampung_v2_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `aduan`
--

CREATE TABLE `aduan` (
  `id_aduan` int(11) NOT NULL,
  `id_pengguna` int(11) NOT NULL,
  `id_kategori_aduan` int(11) NOT NULL,
  `tajuk` varchar(100) NOT NULL,
  `keterangan` text NOT NULL,
  `status` varchar(30) DEFAULT 'SUBMITTED',
  `gambar_aduan` varchar(255) DEFAULT NULL,
  `catatan_pentadbir` text DEFAULT NULL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `dikemaskini_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `dipadam_pada` timestamp NULL DEFAULT NULL,
  `id_pengendali` int(11) DEFAULT NULL COMMENT 'AJK yg handle',
  `keutamaan` varchar(10) DEFAULT 'SEDERHANA' COMMENT 'RENDAH/SEDERHANA/TINGGI/KRITIKAL',
  `bukti_selesai` varchar(255) DEFAULT NULL COMMENT 'Gambar bukti penyelesaian',
  `catatan_ajk` text DEFAULT NULL,
  `catatan_ketua` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `aduan`
--

INSERT INTO `aduan` (`id_aduan`, `id_pengguna`, `id_kategori_aduan`, `tajuk`, `keterangan`, `status`, `gambar_aduan`, `catatan_pentadbir`, `dibuat_pada`, `dikemaskini_pada`, `dipadam_pada`, `id_pengendali`, `keutamaan`, `bukti_selesai`, `catatan_ajk`, `catatan_ketua`) VALUES
(1, 4, 1, 'Jalan Berlubang di Jalan Teratai', 'Terdapat lubang besar yang bahaya untuk penunggang motosikal.', 'UNDER_REVIEW_AJK', NULL, NULL, '2026-03-13 19:52:27', '2026-04-25 07:08:10', NULL, NULL, 'SEDERHANA', NULL, NULL, NULL),
(2, 2, 3, 'Longkang Tersumbat', 'Longkang belakang rumah tersumbat dan berbau busuk.', 'SUBMITTED', NULL, NULL, '2026-03-13 19:52:27', '2026-04-25 07:08:10', NULL, NULL, 'SEDERHANA', NULL, NULL, NULL),
(3, 6, 9, 'Lampu Gelanggang Futsal Terbakar', 'Dua biji lampu rosak, gelap nak main malam.', 'RESOLVED', NULL, NULL, '2026-03-13 19:52:27', '2026-04-25 07:08:10', NULL, NULL, 'SEDERHANA', NULL, NULL, NULL),
(4, 8, 6, 'Kumpulan Kera Musnahkan Kebun', 'Banyak kera masuk kebun pisang dan rosakkan tanaman.', 'SUBMITTED', NULL, NULL, '2026-03-13 19:52:27', '2026-04-25 07:08:10', NULL, NULL, 'SEDERHANA', NULL, NULL, NULL),
(5, 5, 4, 'Lampu Jalan Terpadam', 'Tiang lampu no 12 di Jalan Orkid terpadam sejak 3 hari lepas.', 'RESOLVED', NULL, NULL, '2026-03-13 19:52:27', '2026-04-25 07:08:10', NULL, NULL, 'SEDERHANA', NULL, NULL, NULL),
(6, 10, 2, 'Motor Kerap Hilang', 'Tolong tingkatkan rondaan SRS, banyak kes kecurian motor.', 'UNDER_REVIEW_AJK', NULL, NULL, '2026-03-13 19:52:27', '2026-04-25 07:08:10', NULL, NULL, 'SEDERHANA', NULL, NULL, NULL),
(7, 7, 5, 'Pokok Tumbang Hempap Pagar', 'Hujan lebat semalam akibatkan dahan reput jatuh atas pagar dewan.', 'RESOLVED', NULL, NULL, '2026-03-13 19:52:27', '2026-04-25 07:08:10', NULL, NULL, 'SEDERHANA', NULL, NULL, NULL),
(8, 9, 8, 'Kes Denggi Meningkat', 'Ada kes denggi dekat Lorong Kenanga 2, mohon fogging.', 'UNDER_REVIEW_AJK', NULL, NULL, '2026-03-13 19:52:27', '2026-04-25 07:08:10', NULL, NULL, 'SEDERHANA', NULL, NULL, NULL),
(9, 3, 7, 'Budak Motor Bising Malam', 'Sekumpulan remaja selalu merempit pukul 2 pagi.', 'SUBMITTED', NULL, NULL, '2026-03-13 19:52:27', '2026-04-25 07:08:10', NULL, NULL, 'SEDERHANA', NULL, NULL, NULL),
(10, 1, 10, 'Anjing Liar Berkeliaran', 'Bahaya untuk kanak-kanak yang pergi ke sekolah.', 'SUBMITTED', NULL, NULL, '2026-03-13 19:52:27', '2026-04-25 07:08:10', NULL, NULL, 'SEDERHANA', NULL, NULL, NULL),
(11, 2, 2, 'Test1', 'Test1.1', 'UNDER_REVIEW_AJK', NULL, NULL, '2026-04-25 09:10:27', '2026-04-25 09:20:05', NULL, NULL, 'SEDERHANA', NULL, 'test1', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `ajk_jawatan`
--

CREATE TABLE `ajk_jawatan` (
  `id_pengguna` int(11) NOT NULL,
  `id_jawatan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ajk_jawatan`
--

INSERT INTO `ajk_jawatan` (`id_pengguna`, `id_jawatan`) VALUES
(1, 1),
(3, 3),
(5, 9),
(6, 8),
(7, 5),
(10, 6),
(21, 11),
(24, 12);

-- --------------------------------------------------------

--
-- Table structure for table `bantuan`
--

CREATE TABLE `bantuan` (
  `id_bantuan` int(11) NOT NULL,
  `nama_bantuan` varchar(100) NOT NULL,
  `jenis_bantuan` varchar(20) DEFAULT 'KOMUNITI',
  `peruntukan` decimal(15,2) NOT NULL,
  `status` varchar(20) DEFAULT 'AKTIF',
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `dikemaskini_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `dipadam_pada` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bantuan`
--

INSERT INTO `bantuan` (`id_bantuan`, `nama_bantuan`, `jenis_bantuan`, `peruntukan`, `status`, `dibuat_pada`, `dikemaskini_pada`, `dipadam_pada`) VALUES
(1, 'Bantuan Sara Hidup Kampung', 'KOMUNITI', 15000.00, 'AKTIF', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(2, 'Khairat Kematian', 'KOMUNITI', 5000.00, 'AKTIF', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(3, 'Bantuan Bencana Alam (Banjir)', 'KOMUNITI', 20000.00, 'AKTIF', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(4, 'Bantuan Ibu Tunggal', 'KOMUNITI', 8000.00, 'AKTIF', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(5, 'Bantuan Awal Persekolahan', 'KOMUNITI', 10000.00, 'AKTIF', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(6, 'Bantuan Baja Pertanian', 'KOMUNITI', 6000.00, 'AKTIF', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(7, 'Pembaikan Rumah Daif', 'KOMUNITI', 50000.00, 'AKTIF', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(8, 'Bantuan Kerusi Roda OKU', 'KOMUNITI', 3000.00, 'AKTIF', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(9, 'Bantuan Peniaga Kecil', 'KOMUNITI', 12000.00, 'AKTIF', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(10, 'Dana Kecemerlangan Pelajar', 'KOMUNITI', 4000.00, 'AKTIF', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(11, 'BANTUAN PEMULIHAN RUMAH KEDIAMAN', 'RASMI', 0.00, 'AKTIF', '2026-04-22 10:42:49', '2026-04-22 10:42:49', NULL),
(12, 'BANTUAN RAWATAN PERUBATAN', 'RASMI', 0.00, 'AKTIF', '2026-04-22 10:42:49', '2026-04-22 10:42:49', NULL),
(13, 'BANTUAN SEWA RUMAH', 'RASMI', 0.00, 'AKTIF', '2026-04-22 10:42:49', '2026-04-22 10:42:49', NULL),
(14, 'BANTUAN TETAP BULANAN', 'RASMI', 0.00, 'AKTIF', '2026-04-22 10:42:49', '2026-04-22 10:42:49', NULL),
(15, 'BIASISWA PENDIDIKAN DALAM NEGARA (BPDN)', 'RASMI', 0.00, 'AKTIF', '2026-04-22 10:42:49', '2026-04-22 10:42:49', NULL),
(16, 'BIASISWA PENDIDIKAN LUAR NEGARA (BPLN)', 'RASMI', 0.00, 'AKTIF', '2026-04-22 10:42:49', '2026-04-22 10:42:49', NULL),
(17, 'BIASISWA PROFESIONAL PERAKAUNAN (BPP)', 'RASMI', 0.00, 'AKTIF', '2026-04-22 10:42:49', '2026-04-22 10:42:49', NULL),
(18, 'PROG. BIASISWA SULTAN ISMAIL PETRA (BSIP)', 'RASMI', 0.00, 'AKTIF', '2026-04-22 10:42:49', '2026-04-22 10:42:49', NULL),
(19, 'PROGRAM DERMASISWA SULTAN ISMAIL PETRA (DSIP)', 'RASMI', 0.00, 'AKTIF', '2026-04-22 10:42:49', '2026-04-22 10:42:49', NULL),
(20, 'SUMBANGAN IPT - FISABILILLAH', 'RASMI', 0.00, 'AKTIF', '2026-04-22 10:42:49', '2026-04-22 10:42:49', NULL),
(21, 'Test 2', 'KOMUNITI', 10.00, 'AKTIF', '2026-04-23 00:30:54', '2026-04-23 00:30:54', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `fasiliti`
--

CREATE TABLE `fasiliti` (
  `id_fasiliti` int(11) NOT NULL,
  `nama_fasiliti` varchar(100) NOT NULL,
  `lokasi` varchar(100) NOT NULL,
  `status` varchar(50) DEFAULT 'AKTIF',
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `dikemaskini_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `dipadam_pada` timestamp NULL DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `requires_approval` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fasiliti`
--

INSERT INTO `fasiliti` (`id_fasiliti`, `nama_fasiliti`, `lokasi`, `status`, `dibuat_pada`, `dikemaskini_pada`, `dipadam_pada`, `latitude`, `longitude`, `requires_approval`) VALUES
(1, 'Dewan Orang Ramai', 'Pusat Kampung', 'AKTIF', '2026-03-13 19:52:27', '2026-04-21 12:06:53', NULL, 6.02890000, 102.29350000, 0),
(2, 'Padang Bola Sepak', 'Jalan Bunga Raya', 'AKTIF', '2026-03-13 19:52:27', '2026-04-21 12:06:53', NULL, 6.02890000, 102.29350000, 0),
(3, 'Gelanggang Futsal', 'Taman Belia', 'AKTIF', '2026-03-13 19:52:27', '2026-04-21 12:06:53', NULL, 6.02890000, 102.29350000, 0),
(4, 'Balai Raya', 'Jalan Masjid', 'AKTIF', '2026-03-13 19:52:27', '2026-04-21 12:06:53', NULL, 6.02890000, 102.29350000, 0),
(5, 'Surau Al-Taqwa', 'Jalan Kenanga', 'AKTIF', '2026-03-13 19:52:27', '2026-04-21 12:06:53', NULL, 6.02890000, 102.29350000, 0),
(6, 'Bilik Mesyuarat JKKK', 'Kompleks Penghulu', 'AKTIF', '2026-03-13 19:52:27', '2026-04-21 12:06:53', NULL, 6.02890000, 102.29350000, 0),
(7, 'Gelanggang Sepak Takraw', 'Jalan Mawar', 'AKTIF', '2026-03-13 19:52:27', '2026-04-21 12:06:53', NULL, 6.02890000, 102.29350000, 0),
(8, 'Pusat Internet Desa', 'Sebelah Balai Raya', 'AKTIF', '2026-03-13 19:52:27', '2026-04-21 12:06:53', NULL, 6.02890000, 102.29350000, 0),
(9, 'Taman Permainan Kanak-kanak', 'Jalan Dahlia', 'AKTIF', '2026-03-13 19:52:27', '2026-04-21 12:06:53', NULL, 6.02890000, 102.29350000, 0),
(10, 'Tapak Pasar Malam', 'Dataran Kampung', 'AKTIF', '2026-03-13 19:52:27', '2026-04-21 12:06:53', NULL, 6.02890000, 102.29350000, 0),
(11, 'Dewan Test1', 'Jalan 30', 'AKTIF', '2026-04-20 02:30:40', '2026-04-20 02:30:40', NULL, 6.02890000, 102.29350000, 0);

-- --------------------------------------------------------

--
-- Table structure for table `fasiliti_sekatan`
--

CREATE TABLE `fasiliti_sekatan` (
  `id_Sekatan` int(11) NOT NULL,
  `id_fasiliti` int(11) DEFAULT NULL,
  `tarikh` date DEFAULT NULL,
  `sebab` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `fasiliti_slot`
--

CREATE TABLE `fasiliti_slot` (
  `id_slot` int(11) NOT NULL,
  `id_fasiliti` int(11) NOT NULL,
  `masa_mula` time NOT NULL,
  `masa_tamat` time NOT NULL,
  `durasi` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hebahan`
--

CREATE TABLE `hebahan` (
  `id_hebahan` int(11) NOT NULL,
  `id_pengguna` int(11) NOT NULL,
  `tajuk` varchar(50) NOT NULL,
  `kandungan` text DEFAULT NULL,
  `kategori` enum('Kecemasan','Aktiviti','Umum') DEFAULT 'Umum',
  `gambar_poster` varchar(255) DEFAULT NULL,
  `status_hebahan` enum('Draft','Published','Archived') DEFAULT 'Published',
  `tarikh_mula_acara` datetime DEFAULT NULL,
  `tarikh_tamat_acara` datetime DEFAULT NULL,
  `lokasi_acara` varchar(255) DEFAULT NULL,
  `tarikh_tamat` datetime DEFAULT NULL,
  `tarikh_hebahan` date NOT NULL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `dikemaskini_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `dipadam_pada` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hebahan`
--

INSERT INTO `hebahan` (`id_hebahan`, `id_pengguna`, `tajuk`, `kandungan`, `kategori`, `gambar_poster`, `status_hebahan`, `tarikh_mula_acara`, `tarikh_tamat_acara`, `lokasi_acara`, `tarikh_tamat`, `tarikh_hebahan`, `dibuat_pada`, `dikemaskini_pada`, `dipadam_pada`) VALUES
(1, 1, 'Gotong Royong Perdana', 'Program membersihkan tanah perkuburan pada hari Sabtu ini.', 'Umum', NULL, 'Published', NULL, NULL, NULL, NULL, '2023-11-01', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(2, 1, 'Mesyuarat AJK Bulanan', 'Semua AJK diwajibkan hadir ke balai raya pada malam Jumaat.', 'Umum', NULL, 'Published', NULL, NULL, NULL, NULL, '2023-11-05', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(3, 1, 'Bantuan Banjir Monsun', 'Sila daftar di dewan untuk mangsa banjir.', 'Umum', NULL, 'Published', NULL, NULL, NULL, NULL, '2023-11-15', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(4, 3, 'Kejohanan Futsal Belia', 'Penyertaan dibuka untuk belia kampung.', 'Umum', NULL, 'Published', NULL, NULL, NULL, NULL, '2023-11-20', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(5, 8, 'Kuliah Maghrib Bulanan', 'Kuliah akan disampaikan oleh Ustaz jemputan bulan ini.', 'Umum', NULL, 'Published', NULL, NULL, NULL, NULL, '2023-11-22', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(6, 9, 'Kutipan Yuran Khairat', 'Ahli diminta menjelaskan yuran RM20 setahun.', 'Umum', NULL, 'Published', NULL, NULL, NULL, NULL, '2023-11-25', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(7, 1, 'Suntikan Vaksin Percuma', 'Klinik Kesihatan akan buka kaunter di Balai Raya.', 'Umum', NULL, 'Published', NULL, NULL, NULL, NULL, '2023-12-01', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(8, 10, 'Rondaan SRS Malam', 'Jadual rondaan telah dikemaskini untuk bulan Disember.', 'Umum', NULL, 'Published', NULL, NULL, NULL, NULL, '2023-12-05', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(9, 5, 'Sumbangan Asnaf', 'Majlis penyerahan bantuan asnaf di masjid.', 'Umum', NULL, 'Published', NULL, NULL, NULL, NULL, '2023-12-10', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(10, 1, 'Sambutan Hari Keluarga', 'Semua penduduk dijemput hadir ke padang awam.', 'Umum', NULL, 'Published', NULL, NULL, NULL, NULL, '2023-12-15', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `jawatan_ajk`
--

CREATE TABLE `jawatan_ajk` (
  `id_jawatan` int(11) NOT NULL,
  `nama_jawatan` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jawatan_ajk`
--

INSERT INTO `jawatan_ajk` (`id_jawatan`, `nama_jawatan`) VALUES
(1, 'Pengerusi'),
(2, 'Timbalan Pengerusi'),
(3, 'Setiausaha'),
(4, 'Penolong Setiausaha'),
(5, 'Bendahari'),
(6, 'Biro Keselamatan'),
(7, 'Biro Agama & Da\'wah'),
(8, 'Biro Sukan & Riadah'),
(9, 'Biro Kebajikan & Sosial'),
(10, 'Biro Ekonomi & Usahawan'),
(11, 'Biro Hebahan'),
(12, 'Test last');

-- --------------------------------------------------------

--
-- Table structure for table `kategori_aduan`
--

CREATE TABLE `kategori_aduan` (
  `id_kategori_aduan` int(11) NOT NULL,
  `nama_kategori` varchar(80) NOT NULL,
  `contoh_tajuk` varchar(100) DEFAULT NULL,
  `penerangan` varchar(200) DEFAULT NULL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `dikemaskini_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `dipadam_pada` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kategori_aduan`
--

INSERT INTO `kategori_aduan` (`id_kategori_aduan`, `nama_kategori`, `contoh_tajuk`, `penerangan`, `dibuat_pada`, `dikemaskini_pada`, `dipadam_pada`) VALUES
(1, 'Infrastruktur', 'Jalan berlubang, paip pecah', 'Aduan kerosakan kemudahan asas awam.', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(2, 'Keselamatan', 'Kecurian, lumba haram', 'Aduan berkaitan keselamatan dan jenayah.', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(3, 'Kebersihan', 'Sampah tidak dikutip, longkang tersumbat', 'Aduan tahap kebersihan kawasan.', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(4, 'Utiliti', 'Tiada bekalan air, elektrik terputus', 'Aduan masalah elektrik, air dan telco.', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(5, 'Bencana Alam', 'Pokok tumbang, tanah runtuh', 'Kejadian kecemasan bencana.', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(6, 'Haiwan Liar', 'Kera kacau kebun, anjing liar', 'Ancaman haiwan berbahaya.', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(7, 'Sosial', 'Remaja lepak, bising', 'Gejala tidak sihat di kalangan masyarakat.', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(8, 'Kesihatan', 'Wabak denggi, tempat nyamuk membiak', 'Aduan risiko penyakit berjangkit.', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(9, 'Fasiliti Rosak', 'Lampu dewan terbakar, tandas rosak', 'Kerosakan pada harta benda kampung.', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(10, 'Lain-lain', 'Aduan am', 'Aduan yang tidak tersenarai di atas.', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `log_aduan`
--

CREATE TABLE `log_aduan` (
  `id_log_aduan` int(11) NOT NULL,
  `id_aduan` int(11) NOT NULL,
  `id_pelaku` int(11) NOT NULL COMMENT 'Siapa buat action',
  `status_lama` varchar(30) NOT NULL,
  `status_baru` varchar(30) NOT NULL,
  `catatan` text DEFAULT NULL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `log_aduan`
--

INSERT INTO `log_aduan` (`id_log_aduan`, `id_aduan`, `id_pelaku`, `status_lama`, `status_baru`, `catatan`, `dibuat_pada`) VALUES
(1, 11, 10, 'SUBMITTED', 'UNDER_REVIEW_AJK', 'test1', '2026-04-25 09:20:05');

-- --------------------------------------------------------

--
-- Table structure for table `log_aktiviti`
--

CREATE TABLE `log_aktiviti` (
  `id_log` int(11) NOT NULL,
  `id_pengguna` int(11) NOT NULL,
  `id_admin` int(11) NOT NULL,
  `jenis_tindakan` varchar(50) NOT NULL,
  `keterangan_tindakan` text DEFAULT NULL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `log_aktiviti`
--

INSERT INTO `log_aktiviti` (`id_log`, `id_pengguna`, `id_admin`, `jenis_tindakan`, `keterangan_tindakan`, `dibuat_pada`) VALUES
(1, 2, 1, 'KEMASKINI_PROFIL', 'Admin mengemaskini: No. Telefon (011-1101 3816 -> 011-1101 3817). ', '2026-04-19 13:06:46'),
(2, 2, 1, 'KEMASKINI_PROFIL', 'Admin mengemaskini: No. Telefon. ', '2026-04-19 13:12:12'),
(3, 2, 1, 'KEMASKINI_PROFIL', 'Admin mengemaskini: Status Keluarga (Bujang -> Berkahwin). ', '2026-04-19 13:16:54'),
(4, 2, 3, 'KEMASKINI_PROFIL', 'Admin mengemaskini: Status Keluarga (Berkahwin -> Ibu Tunggal). ', '2026-04-19 13:19:18'),
(5, 3, 1, 'KEMASKINI_PROFIL', 'Admin mengemaskini: Status Keluarga (Bujang -> Berkahwin). ', '2026-04-19 13:21:52'),
(6, 3, 1, 'KEMASKINI_PROFIL', 'Admin mengemaskini: Status Keluarga (Berkahwin -> Duda). ', '2026-04-20 12:22:13'),
(7, 2, 3, 'KEMASKINI_PROFIL', 'Admin mengemaskini: Alamat (Bandar: - -> Pasir Puteh; Poskod: - -> 16810; Negeri: - -> Kelantan; ). ', '2026-04-22 09:21:47');

-- --------------------------------------------------------

--
-- Table structure for table `pengguna`
--

CREATE TABLE `pengguna` (
  `id_pengguna` int(11) NOT NULL,
  `nama_penuh` varchar(150) NOT NULL,
  `nombor_kp` varchar(14) NOT NULL,
  `nombor_telefon` varchar(20) DEFAULT NULL,
  `tarikh_lahir` date DEFAULT NULL,
  `kata_laluan` varchar(255) NOT NULL,
  `status` int(1) NOT NULL DEFAULT 0,
  `status_keluarga` varchar(50) DEFAULT NULL,
  `pekerjaan` varchar(50) DEFAULT NULL,
  `pendapatan` decimal(10,2) DEFAULT NULL,
  `nama_jalan` varchar(50) DEFAULT NULL,
  `daerah` varchar(100) DEFAULT NULL,
  `nombor_poskod` varchar(10) DEFAULT NULL,
  `bandar` varchar(50) DEFAULT NULL,
  `negeri` varchar(50) DEFAULT NULL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `dikemaskini_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `dipadam_pada` timestamp NULL DEFAULT NULL,
  `lampiran_pengesahan` varchar(255) DEFAULT NULL,
  `reset_token` varchar(100) DEFAULT NULL,
  `token_expiry` datetime DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `foto_profil` varchar(255) DEFAULT 'default_avatar.png'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pengguna`
--

INSERT INTO `pengguna` (`id_pengguna`, `nama_penuh`, `nombor_kp`, `nombor_telefon`, `tarikh_lahir`, `kata_laluan`, `status`, `status_keluarga`, `pekerjaan`, `pendapatan`, `nama_jalan`, `daerah`, `nombor_poskod`, `bandar`, `negeri`, `dibuat_pada`, `dikemaskini_pada`, `dipadam_pada`, `lampiran_pengesahan`, `reset_token`, `token_expiry`, `email`, `latitude`, `longitude`, `foto_profil`) VALUES
(1, 'Ahmad bin Ali', '800101031234', '012-3456 5353', '1980-01-01', '$2a$10$4REPQtKXDeP/GXdC2d06SuFynGXcEkMfbsfRUQZ09L7itoiobVi/C', 1, 'Bujang', 'CEO', 1200.09, 'Jalan Mawar 11', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-03-13 19:52:27', '2026-04-23 00:51:58', NULL, NULL, NULL, NULL, 'khairuliman736@gmail.com', 6.03112933, 102.29697188, 'profil_1_1776905518169.jpg'),
(2, 'Siti binti Abuyal', '850202035566', '011-1101 3816', '1985-02-02', '$2a$12$NUn7qK.c4bD4scgC8fG7/ucy.iqtBLxkoqIR7.b1s0nXhM88UNPa6', 1, 'Bujang', 'Petani', 1000.00, 'Jalan Melati 2', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-03-13 19:52:27', '2026-04-23 00:54:03', NULL, NULL, NULL, NULL, 'siti@gmail.com', 6.03130217, 102.29371122, 'profil_2_1776905643592.jpg'),
(3, 'Muthu a/l Samy', '900303037788', '014-5678 901', '1990-03-03', '$2a$12$GIGxqxu1FHhiZkKGkhSAGerrvcl4hXyp1uO3Qk3iu.mJVhv4ZMarm', 1, 'Bujang', 'Peniaga', 3999.99, 'Jalan Kenanga', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-03-13 19:52:27', '2026-04-23 00:52:40', NULL, NULL, NULL, NULL, 's71383@ocean.umt.edu.my', 6.03130217, 102.29371122, 'profil_3_1776905560441.jpg'),
(4, 'Chong Wei Ming', '750404039911', '016-6789 011', '1975-04-04', '$2a$12$GIGxqxu1FHhiZkKGkhSAGerrvcl4hXyp1uO3Qk3iu.mJVhv4ZMarm', 1, 'Bujang', 'Guru', 3000.01, 'Jalan Teratai', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-03-13 19:52:27', '2026-04-23 00:53:01', NULL, NULL, NULL, NULL, 'khayxstyle@gmail.com', 6.03130217, 102.29371122, 'profil_4_1776905581340.jpg'),
(5, 'Aminah binti Hassan', '650505032233', '017-7890123', '1965-05-05', '$2a$12$GIGxqxu1FHhiZkKGkhSAGerrvcl4hXyp1uO3Qk3iu.mJVhv4ZMarm', 1, 'Ibu Tunggal', 'Pesara', 1200.00, 'Jalan Orkid', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-03-13 19:52:27', '2026-04-23 00:53:46', NULL, NULL, NULL, NULL, 'aminah@gmail.com', 6.03130217, 102.29371122, 'profil_5_1776905626958.jpg'),
(6, 'Kamal bin Mustafa', '950606034455', '011-8901234', '1995-06-06', '$2a$12$GIGxqxu1FHhiZkKGkhSAGerrvcl4hXyp1uO3Qk3iu.mJVhv4ZMarm', 1, 'Bujang', 'Jurutera', 4000.00, 'Jalan Mawar 2', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-03-13 19:52:27', '2026-04-23 00:52:25', NULL, NULL, NULL, NULL, 'kamal@gmail.com', 6.03130217, 102.29371122, 'profil_6_1776905545480.jpg'),
(7, 'Nurul binti Hisham', '880707036677', '018-9012345', '1988-07-07', '$2a$12$GIGxqxu1FHhiZkKGkhSAGerrvcl4hXyp1uO3Qk3iu.mJVhv4ZMarm', 1, 'Berkahwin', 'Suri Rumah', 0.00, 'Jalan Dahlia', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-03-13 19:52:27', '2026-04-19 13:56:08', NULL, NULL, NULL, NULL, '', 6.03130217, 102.29371122, 'default_avatar.png'),
(8, 'Razak bin Osman', '700808038899', '019-0123456', '1970-08-08', 'hash123', 1, 'Berkahwin', 'Petani', 1800.00, 'Jalan Raya Kampung', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-03-13 19:52:27', '2026-04-19 13:56:08', NULL, NULL, NULL, NULL, '', 6.03130217, 102.29371122, 'default_avatar.png'),
(9, 'Fatimah binti Zainal', '920909031122', '012-1234567', '1992-09-09', 'hash123', 1, 'Bujang', 'Kerani Kewangan', 2200.00, 'Jalan Kenanga 2', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-03-13 19:52:27', '2026-04-19 13:56:08', NULL, NULL, NULL, NULL, '', 6.03130217, 102.29371122, 'default_avatar.png'),
(10, 'Hafiz bin Johan', '821010033344', '013-2345678', '1982-10-10', '$2a$12$GIGxqxu1FHhiZkKGkhSAGerrvcl4hXyp1uO3Qk3iu.mJVhv4ZMarm', 1, 'Berkahwin', 'Pemandu Lori', 2800.00, 'Jalan Orkid 3', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-03-13 19:52:27', '2026-04-25 07:36:35', NULL, NULL, NULL, NULL, '', 6.03130217, 102.29371122, 'default_avatar.png'),
(11, 'Iman Bin Khairul', '040101030441', NULL, '2004-01-01', 'Abdkarim', 1, NULL, NULL, NULL, 'Kg Danan', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-04-01 07:11:10', '2026-04-19 13:56:08', NULL, 'bukti_040101030441_1775027470599.pdf', NULL, NULL, '', 6.03130217, 102.29371122, 'default_avatar.png'),
(15, 'Muhammad Naim Najmi Bin Hazre', '990404110432', NULL, '1999-04-04', 'hash123', 1, NULL, NULL, NULL, 'Kg Danan', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-04-05 12:33:29', '2026-04-19 13:56:08', NULL, 'bukti_990404110432_1775392409643.pdf', NULL, NULL, '', 6.03130217, 102.29371122, 'default_avatar.png'),
(16, 'Muhammad Naim Najmi Bin Hazrew', '990404110431', '012345678', '1999-04-04', 'hash123', 1, NULL, NULL, NULL, 'Kg Danan', 'Selising', '16810', '800101031231', 'Kelantan', '2026-04-06 09:06:30', '2026-04-19 13:56:08', NULL, 'bukti_990404110431_1775466390091.pdf', NULL, NULL, '', 6.03130217, 102.29371122, 'default_avatar.png'),
(18, 'MUHAMMAD KHAIRUL IMAN BIN ABD KARIM', '040101030440', '01111013816', '2004-01-01', '$2a$10$D0Yd9Rk1AnddKLDA1AFx/Oax/X2fNfFv9zR4cgwU1XaS8tHOI5Jva', 1, NULL, NULL, NULL, 'Lot. 98 Kg Danan', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-04-14 09:17:11', '2026-04-19 13:56:08', NULL, 'bukti_040101030440_1776158231600.pdf', NULL, NULL, '', 6.03130217, 102.29371122, 'default_avatar.png'),
(21, 'MUHAMAD AMIR BIN RUSLI', '042304034506', '01111013816', '2005-11-04', '$2a$10$PWjG2khEQHBAx8sDwadOqe1OHEc.ZK0JV5CGmSllfNIGnSYKDeld.', 1, NULL, NULL, NULL, 'Lot. 98 Kg Danan', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-04-17 04:10:48', '2026-04-19 13:56:08', NULL, 'bukti_042304034506_1776399048381.pdf', NULL, NULL, 'amir123@gmail.com', 6.03130217, 102.29371122, 'default_avatar.png'),
(22, 'MUHAMMD AIMAN BIN SAMAD', '010302030441', '01120034344', '2001-03-02', '$2a$10$.l7X.UGDpzKRG47QQ76YbOsKx18VRpxslYVWinUWw6xuY6ucAbqHS', 2, NULL, NULL, NULL, 'Lot 67, Kampung Danan', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-04-18 05:48:01', '2026-04-20 12:31:10', NULL, 'bukti_010302030441_1776491281745.pdf', NULL, NULL, 'khayxstyle@gmail.com', 6.03130217, 102.29371122, 'default_avatar.png'),
(23, 'HAIKAL DANIAL BIN MOHD ROHAIZA', '040503030441', '03222004245', '2004-05-03', '$2a$10$ej9jvSZ9UH43oocQg1jBEudAbFyN0UBVVUPWDRF9oUr6moMw6CTOi', 1, NULL, NULL, NULL, 'Kg Danan', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-04-20 12:33:29', '2026-04-23 04:51:27', NULL, 'bukti_040503030441_1776688409125.pdf', NULL, NULL, 's70622@ocean.umt.edu.my', NULL, NULL, 'default_avatar.png'),
(24, 'HARIZ FARHAN BIN AHMAD', '440303020441', '01433056007', '2044-03-03', '$2a$10$.48PBQFJgEqH8mwRyYIEMeUYIpoKizcpjXhhYKrGJY6q69dkWr5Ue', 1, NULL, NULL, NULL, 'Lot 55, Kampung Dana', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-04-23 00:55:38', '2026-04-23 00:57:36', NULL, 'bukti_440303020441_1776905738539.pdf', NULL, NULL, 'hariz@gmail.com', NULL, NULL, 'default_avatar.png');

-- --------------------------------------------------------

--
-- Table structure for table `pengguna_peranan`
--

CREATE TABLE `pengguna_peranan` (
  `id_pengguna` int(11) NOT NULL,
  `id_peranan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pengguna_peranan`
--

INSERT INTO `pengguna_peranan` (`id_pengguna`, `id_peranan`) VALUES
(1, 2),
(2, 4),
(3, 3),
(4, 4),
(5, 3),
(6, 3),
(7, 4),
(8, 4),
(9, 4),
(10, 3),
(11, 4),
(15, 4),
(16, 4),
(18, 4),
(21, 3),
(22, 3),
(23, 4),
(24, 3);

-- --------------------------------------------------------

--
-- Table structure for table `peranan`
--

CREATE TABLE `peranan` (
  `id_peranan` int(11) NOT NULL,
  `nama_peranan` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `peranan`
--

INSERT INTO `peranan` (`id_peranan`, `nama_peranan`) VALUES
(1, 'Pentadbir Sistem'),
(2, 'Ketua Kampung'),
(3, 'AJK Kampung'),
(4, 'Penduduk'),
(5, 'Pegawai Kerajaan'),
(6, 'Pemuda/Belia'),
(7, 'Imam Surau'),
(8, 'Bilal'),
(9, 'Pengawal Sukarela'),
(10, 'Penyewa Fasiliti');

-- --------------------------------------------------------

--
-- Table structure for table `permohonan_bantuan`
--

CREATE TABLE `permohonan_bantuan` (
  `id_permohonan` int(11) NOT NULL,
  `id_pengguna` int(11) NOT NULL,
  `id_bantuan` int(11) NOT NULL,
  `status` varchar(50) DEFAULT 'BARU',
  `catatan_pemohon` text DEFAULT NULL,
  `catatan_pentadbir` text DEFAULT NULL,
  `dokumen_pemohon` varchar(255) DEFAULT NULL,
  `dokumen_pentadbir` varchar(255) DEFAULT NULL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `dikemaskini_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `dipadam_pada` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `permohonan_bantuan`
--

INSERT INTO `permohonan_bantuan` (`id_permohonan`, `id_pengguna`, `id_bantuan`, `status`, `catatan_pemohon`, `catatan_pentadbir`, `dokumen_pemohon`, `dokumen_pentadbir`, `dibuat_pada`, `dikemaskini_pada`, `dipadam_pada`) VALUES
(1, 5, 4, 'DILULUSKAN', 'Mohon bantuan kewangan sara anak.', NULL, NULL, NULL, '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(2, 8, 6, 'DIKEMBALIKAN', 'Mohon baja untuk kebun.', 'kabur', NULL, NULL, '2026-03-13 19:52:27', '2026-04-21 06:41:50', NULL),
(3, 7, 5, 'MENUNGGU', 'Anak 3 orang akan masuk sekolah.', NULL, NULL, NULL, '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(4, 4, 9, 'DILULUSKAN', 'Mohon bantuan modal niaga.', NULL, NULL, NULL, '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(5, 2, 5, 'LULUS', 'Mohon bantuan pakaian sekolah anak.', 'DILULUSKAN: Permohonan disokong oleh Ketua Kampung.', NULL, NULL, '2026-03-13 19:52:27', '2026-04-22 12:34:05', NULL),
(6, 10, 3, 'MENUNGGU', 'Rumah dimasuki air sedalam 1 meter.', NULL, NULL, NULL, '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(7, 5, 7, 'DITOLAK', 'Atap zink bocor teruk.', NULL, NULL, NULL, '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(8, 6, 10, 'DILULUSKAN', 'Adik dapat 5A SPM.', NULL, NULL, NULL, '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(9, 9, 1, 'BARU', 'Kos sara hidup meningkat.', NULL, NULL, NULL, '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(10, 3, 9, 'DITOLAK', 'Mohon tambah gerai.', NULL, NULL, NULL, '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(11, 2, 1, 'BARU', NULL, NULL, NULL, NULL, '2026-04-22 10:17:39', '2026-04-22 10:17:39', NULL),
(12, 2, 2, 'BARU', NULL, NULL, NULL, NULL, '2026-04-22 10:29:15', '2026-04-22 10:29:15', NULL),
(13, 2, 1, 'LULUS', 'Test2', 'DILULUSKAN: Permohonan disokong oleh Ketua Kampung.', '1776854721715_Case_Study_1.pdf', NULL, '2026-04-22 10:45:21', '2026-04-22 12:32:35', NULL),
(14, 2, 9, 'BARU', 'test2', NULL, '1776854828765_Week4_(1).pdf', NULL, '2026-04-22 10:47:08', '2026-04-22 10:47:08', NULL),
(15, 2, 6, 'BARU', 'test3', NULL, '1776854986603_Week4.pdf', NULL, '2026-04-22 10:49:46', '2026-04-22 10:49:46', NULL),
(16, 2, 2, 'BARU', 'Test4', NULL, '1776855498368_Week4.pdf', NULL, '2026-04-22 10:58:18', '2026-04-22 10:58:18', NULL),
(17, 2, 10, 'BARU', 'Test6', NULL, '1776855550838_Week4.pdf', NULL, '2026-04-22 10:59:10', '2026-04-22 10:59:10', NULL),
(18, 2, 9, 'BARU', 'Test7', NULL, '1776855843312_Week4.pdf', NULL, '2026-04-22 11:04:03', '2026-04-22 11:04:03', NULL),
(19, 2, 8, 'BARU', 'fewfAtest 8', NULL, '1776856122289_Week4.pdf', NULL, '2026-04-22 11:08:42', '2026-04-22 13:40:18', NULL),
(20, 2, 11, 'BARU', 'Test11', NULL, '1776856311135_SME_Paper_2.pdf', NULL, '2026-04-22 11:11:51', '2026-04-22 11:11:51', NULL),
(21, 4, 6, 'LULUS', 'Test terakhir 1.1.1', 'DILULUSKAN: Permohonan disokong oleh Ketua Kampung.', '1776864686216_Assignment_SME.pdf', NULL, '2026-04-22 13:17:55', '2026-04-23 02:11:37', NULL),
(22, 2, 7, 'MENUNGGU_KETUA', 'test10', 'Disemak oleh JKKK: Dokumen Lengkap.', '1776920160559_thesis.pdf', NULL, '2026-04-23 04:56:00', '2026-04-23 04:58:50', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tempahan_fasiliti`
--

CREATE TABLE `tempahan_fasiliti` (
  `id_tempahan` int(11) NOT NULL,
  `id_fasiliti` int(11) NOT NULL,
  `id_pengguna` int(11) NOT NULL,
  `tarikh_tempah` date NOT NULL,
  `masa_mula` time NOT NULL,
  `masa_tamat` time NOT NULL,
  `status` varchar(50) DEFAULT 'MENUNGGU',
  `catatan_pemohon` text DEFAULT NULL,
  `catatan_pentadbir` varchar(150) DEFAULT NULL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `dikemaskini_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `dipadam_pada` timestamp NULL DEFAULT NULL,
  `alasan_penolakan` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tempahan_fasiliti`
--

INSERT INTO `tempahan_fasiliti` (`id_tempahan`, `id_fasiliti`, `id_pengguna`, `tarikh_tempah`, `masa_mula`, `masa_tamat`, `status`, `catatan_pemohon`, `catatan_pentadbir`, `dibuat_pada`, `dikemaskini_pada`, `dipadam_pada`, `alasan_penolakan`) VALUES
(1, 1, 2, '2023-12-01', '08:00:00', '17:00:00', 'LULUS', NULL, NULL, '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL, NULL),
(2, 3, 6, '2023-12-02', '20:00:00', '22:00:00', 'LULUS', NULL, NULL, '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL, NULL),
(3, 2, 4, '2023-12-05', '15:00:00', '18:00:00', 'MENUNGGU', NULL, NULL, '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL, NULL),
(4, 4, 1, '2023-12-10', '09:00:00', '13:00:00', 'LULUS', NULL, NULL, '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL, NULL),
(5, 5, 8, '2023-12-12', '18:00:00', '21:00:00', 'LULUS', NULL, NULL, '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL, NULL),
(6, 7, 3, '2023-12-15', '17:00:00', '19:00:00', 'MENUNGGU', NULL, NULL, '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL, NULL),
(7, 1, 7, '2023-12-20', '10:00:00', '16:00:00', 'TOLAK', NULL, NULL, '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL, NULL),
(8, 6, 9, '2023-12-22', '20:00:00', '23:00:00', 'LULUS', NULL, NULL, '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL, NULL),
(9, 10, 10, '2023-12-25', '15:00:00', '23:00:00', 'LULUS', NULL, NULL, '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL, NULL),
(10, 8, 5, '2023-12-30', '09:00:00', '12:00:00', 'MENUNGGU', NULL, NULL, '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL, NULL),
(11, 3, 2, '2026-04-14', '08:17:00', '11:17:00', 'DIBATAL', NULL, NULL, '2026-04-14 00:18:05', '2026-04-18 07:08:07', NULL, NULL),
(12, 2, 4, '2026-04-18', '00:00:00', '14:19:00', 'LULUS', NULL, NULL, '2026-04-18 03:20:03', '2026-04-18 04:54:45', NULL, NULL),
(13, 6, 2, '2026-04-18', '14:44:00', '14:47:00', 'MENUNGGU', NULL, NULL, '2026-04-18 06:43:22', '2026-04-18 06:43:22', NULL, NULL),
(14, 1, 4, '2026-04-22', '10:00:00', '12:00:00', 'MENUNGGU', '', NULL, '2026-04-22 00:44:40', '2026-04-22 00:44:40', NULL, NULL),
(15, 1, 4, '2026-04-22', '12:00:00', '14:00:00', 'MENUNGGU', '', NULL, '2026-04-22 00:53:45', '2026-04-22 00:53:45', NULL, NULL),
(16, 2, 4, '2026-04-22', '20:00:00', '22:00:00', 'MENUNGGU', '', NULL, '2026-04-22 01:23:15', '2026-04-22 01:23:15', NULL, NULL),
(17, 3, 4, '2026-04-22', '18:00:00', '20:00:00', 'DIBATAL', '', NULL, '2026-04-22 08:57:00', '2026-04-22 09:05:41', NULL, NULL),
(18, 3, 2, '2026-04-22', '18:00:00', '20:00:00', 'LULUS', '', NULL, '2026-04-22 09:06:06', '2026-04-22 09:06:06', NULL, NULL),
(19, 1, 4, '2026-04-23', '08:00:00', '22:00:00', 'TOLAK', 'Majlish Kawin', NULL, '2026-04-22 09:10:20', '2026-04-22 09:14:26', NULL, 'tidak memenuhi kretiria'),
(20, 1, 2, '2026-04-23', '08:00:00', '22:00:00', 'LULUS', 'Test terakhir', NULL, '2026-04-22 14:42:11', '2026-04-22 14:43:09', NULL, NULL),
(21, 2, 2, '2026-04-23', '16:00:00', '18:00:00', 'DIBATAL', '', NULL, '2026-04-23 05:05:08', '2026-04-23 05:06:58', NULL, NULL),
(22, 2, 2, '2026-04-23', '08:00:00', '22:00:00', 'MENUNGGU', 'test112', NULL, '2026-04-23 05:09:42', '2026-04-23 05:09:42', NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `aduan`
--
ALTER TABLE `aduan`
  ADD PRIMARY KEY (`id_aduan`),
  ADD KEY `id_pengguna` (`id_pengguna`),
  ADD KEY `id_kategori_aduan` (`id_kategori_aduan`),
  ADD KEY `aduan_ibfk_pengendali` (`id_pengendali`);

--
-- Indexes for table `ajk_jawatan`
--
ALTER TABLE `ajk_jawatan`
  ADD PRIMARY KEY (`id_pengguna`,`id_jawatan`),
  ADD KEY `id_jawatan` (`id_jawatan`);

--
-- Indexes for table `bantuan`
--
ALTER TABLE `bantuan`
  ADD PRIMARY KEY (`id_bantuan`);

--
-- Indexes for table `fasiliti`
--
ALTER TABLE `fasiliti`
  ADD PRIMARY KEY (`id_fasiliti`);

--
-- Indexes for table `fasiliti_sekatan`
--
ALTER TABLE `fasiliti_sekatan`
  ADD PRIMARY KEY (`id_Sekatan`);

--
-- Indexes for table `fasiliti_slot`
--
ALTER TABLE `fasiliti_slot`
  ADD PRIMARY KEY (`id_slot`),
  ADD KEY `id_fasiliti` (`id_fasiliti`);

--
-- Indexes for table `hebahan`
--
ALTER TABLE `hebahan`
  ADD PRIMARY KEY (`id_hebahan`),
  ADD KEY `id_pengguna` (`id_pengguna`);

--
-- Indexes for table `jawatan_ajk`
--
ALTER TABLE `jawatan_ajk`
  ADD PRIMARY KEY (`id_jawatan`);

--
-- Indexes for table `kategori_aduan`
--
ALTER TABLE `kategori_aduan`
  ADD PRIMARY KEY (`id_kategori_aduan`);

--
-- Indexes for table `log_aduan`
--
ALTER TABLE `log_aduan`
  ADD PRIMARY KEY (`id_log_aduan`),
  ADD KEY `id_aduan` (`id_aduan`),
  ADD KEY `id_pelaku` (`id_pelaku`);

--
-- Indexes for table `log_aktiviti`
--
ALTER TABLE `log_aktiviti`
  ADD PRIMARY KEY (`id_log`),
  ADD KEY `log_ibfk_pengguna` (`id_pengguna`),
  ADD KEY `log_ibfk_admin` (`id_admin`);

--
-- Indexes for table `pengguna`
--
ALTER TABLE `pengguna`
  ADD PRIMARY KEY (`id_pengguna`),
  ADD UNIQUE KEY `nombor_kp` (`nombor_kp`);

--
-- Indexes for table `pengguna_peranan`
--
ALTER TABLE `pengguna_peranan`
  ADD PRIMARY KEY (`id_pengguna`,`id_peranan`),
  ADD KEY `id_peranan` (`id_peranan`);

--
-- Indexes for table `peranan`
--
ALTER TABLE `peranan`
  ADD PRIMARY KEY (`id_peranan`);

--
-- Indexes for table `permohonan_bantuan`
--
ALTER TABLE `permohonan_bantuan`
  ADD PRIMARY KEY (`id_permohonan`),
  ADD KEY `id_pengguna` (`id_pengguna`),
  ADD KEY `id_bantuan` (`id_bantuan`);

--
-- Indexes for table `tempahan_fasiliti`
--
ALTER TABLE `tempahan_fasiliti`
  ADD PRIMARY KEY (`id_tempahan`),
  ADD KEY `id_fasiliti` (`id_fasiliti`),
  ADD KEY `id_pengguna` (`id_pengguna`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `aduan`
--
ALTER TABLE `aduan`
  MODIFY `id_aduan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `bantuan`
--
ALTER TABLE `bantuan`
  MODIFY `id_bantuan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `fasiliti`
--
ALTER TABLE `fasiliti`
  MODIFY `id_fasiliti` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `fasiliti_sekatan`
--
ALTER TABLE `fasiliti_sekatan`
  MODIFY `id_Sekatan` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `fasiliti_slot`
--
ALTER TABLE `fasiliti_slot`
  MODIFY `id_slot` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hebahan`
--
ALTER TABLE `hebahan`
  MODIFY `id_hebahan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `jawatan_ajk`
--
ALTER TABLE `jawatan_ajk`
  MODIFY `id_jawatan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `kategori_aduan`
--
ALTER TABLE `kategori_aduan`
  MODIFY `id_kategori_aduan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `log_aduan`
--
ALTER TABLE `log_aduan`
  MODIFY `id_log_aduan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `log_aktiviti`
--
ALTER TABLE `log_aktiviti`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `pengguna`
--
ALTER TABLE `pengguna`
  MODIFY `id_pengguna` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `peranan`
--
ALTER TABLE `peranan`
  MODIFY `id_peranan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `permohonan_bantuan`
--
ALTER TABLE `permohonan_bantuan`
  MODIFY `id_permohonan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `tempahan_fasiliti`
--
ALTER TABLE `tempahan_fasiliti`
  MODIFY `id_tempahan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `aduan`
--
ALTER TABLE `aduan`
  ADD CONSTRAINT `aduan_ibfk_1` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`),
  ADD CONSTRAINT `aduan_ibfk_2` FOREIGN KEY (`id_kategori_aduan`) REFERENCES `kategori_aduan` (`id_kategori_aduan`),
  ADD CONSTRAINT `aduan_ibfk_pengendali` FOREIGN KEY (`id_pengendali`) REFERENCES `pengguna` (`id_pengguna`);

--
-- Constraints for table `ajk_jawatan`
--
ALTER TABLE `ajk_jawatan`
  ADD CONSTRAINT `ajk_jawatan_ibfk_1` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE CASCADE,
  ADD CONSTRAINT `ajk_jawatan_ibfk_2` FOREIGN KEY (`id_jawatan`) REFERENCES `jawatan_ajk` (`id_jawatan`) ON DELETE CASCADE;

--
-- Constraints for table `fasiliti_sekatan`
--
ALTER TABLE `fasiliti_sekatan`
  ADD CONSTRAINT `fasiliti_sekatan_ibfk_1` FOREIGN KEY (`id_Sekatan`) REFERENCES `fasiliti` (`id_fasiliti`);

--
-- Constraints for table `fasiliti_slot`
--
ALTER TABLE `fasiliti_slot`
  ADD CONSTRAINT `fasiliti_slot_ibfk_1` FOREIGN KEY (`id_fasiliti`) REFERENCES `fasiliti` (`id_fasiliti`) ON DELETE CASCADE;

--
-- Constraints for table `hebahan`
--
ALTER TABLE `hebahan`
  ADD CONSTRAINT `hebahan_ibfk_1` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`);

--
-- Constraints for table `log_aduan`
--
ALTER TABLE `log_aduan`
  ADD CONSTRAINT `log_aduan_ibfk_1` FOREIGN KEY (`id_aduan`) REFERENCES `aduan` (`id_aduan`) ON DELETE CASCADE,
  ADD CONSTRAINT `log_aduan_ibfk_2` FOREIGN KEY (`id_pelaku`) REFERENCES `pengguna` (`id_pengguna`);

--
-- Constraints for table `log_aktiviti`
--
ALTER TABLE `log_aktiviti`
  ADD CONSTRAINT `log_ibfk_admin` FOREIGN KEY (`id_admin`) REFERENCES `pengguna` (`id_pengguna`),
  ADD CONSTRAINT `log_ibfk_pengguna` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE CASCADE;

--
-- Constraints for table `pengguna_peranan`
--
ALTER TABLE `pengguna_peranan`
  ADD CONSTRAINT `pengguna_peranan_ibfk_1` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE CASCADE,
  ADD CONSTRAINT `pengguna_peranan_ibfk_2` FOREIGN KEY (`id_peranan`) REFERENCES `peranan` (`id_peranan`) ON DELETE CASCADE;

--
-- Constraints for table `permohonan_bantuan`
--
ALTER TABLE `permohonan_bantuan`
  ADD CONSTRAINT `permohonan_bantuan_ibfk_1` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`),
  ADD CONSTRAINT `permohonan_bantuan_ibfk_2` FOREIGN KEY (`id_bantuan`) REFERENCES `bantuan` (`id_bantuan`);

--
-- Constraints for table `tempahan_fasiliti`
--
ALTER TABLE `tempahan_fasiliti`
  ADD CONSTRAINT `tempahan_fasiliti_ibfk_1` FOREIGN KEY (`id_fasiliti`) REFERENCES `fasiliti` (`id_fasiliti`),
  ADD CONSTRAINT `tempahan_fasiliti_ibfk_2` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
