-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 23, 2026 at 06:17 AM
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
  `status` varchar(30) NOT NULL DEFAULT 'SUBMITTED',
  `gambar_aduan` varchar(255) DEFAULT NULL,
  `catatan_pentadbir` text DEFAULT NULL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `dikemaskini_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `dipadam_pada` timestamp NULL DEFAULT NULL,
  `id_pengendali` int(11) DEFAULT NULL COMMENT 'AJK yg handle',
  `keutamaan` varchar(10) DEFAULT 'SEDERHANA' COMMENT 'RENDAH/SEDERHANA/TINGGI/KRITIKAL',
  `bukti_selesai` varchar(255) DEFAULT NULL COMMENT 'Gambar bukti penyelesaian',
  `catatan_ajk` text DEFAULT NULL,
  `catatan_ketua` text DEFAULT NULL,
  `reopen_count` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `aduan`
--

INSERT INTO `aduan` (`id_aduan`, `id_pengguna`, `id_kategori_aduan`, `tajuk`, `keterangan`, `status`, `gambar_aduan`, `catatan_pentadbir`, `dibuat_pada`, `dikemaskini_pada`, `dipadam_pada`, `id_pengendali`, `keutamaan`, `bukti_selesai`, `catatan_ajk`, `catatan_ketua`, `reopen_count`) VALUES
(1, 4, 1, 'Jalan Berlubang di Jalan Teratai', 'Terdapat lubang besar yang bahaya untuk penunggang motosikal.', 'UNDER_REVIEW_AJK', NULL, NULL, '2026-03-13 19:52:27', '2026-04-25 07:08:10', NULL, NULL, 'SEDERHANA', NULL, NULL, NULL, 0),
(2, 2, 3, 'Longkang Tersumbat', 'Longkang belakang rumah tersumbat dan berbau busuk.', 'UNDER_REVIEW_AJK', NULL, NULL, '2026-03-13 19:52:27', '2026-04-28 00:26:52', NULL, NULL, 'SEDERHANA', NULL, 'wdw', NULL, 0),
(3, 6, 9, 'Lampu Gelanggang Futsal Terbakar', 'Dua biji lampu rosak, gelap nak main malam.', 'RESOLVED', NULL, NULL, '2026-03-13 19:52:27', '2026-04-25 07:08:10', NULL, NULL, 'SEDERHANA', NULL, NULL, NULL, 0),
(4, 8, 6, 'Kumpulan Kera Musnahkan Kebun', 'Banyak kera masuk kebun pisang dan rosakkan tanaman.', 'SUBMITTED', NULL, NULL, '2026-03-13 19:52:27', '2026-04-25 07:08:10', NULL, NULL, 'SEDERHANA', NULL, NULL, NULL, 0),
(5, 5, 4, 'Lampu Jalan Terpadam', 'Tiang lampu no 12 di Jalan Orkid terpadam sejak 3 hari lepas.', 'RESOLVED', NULL, NULL, '2026-03-13 19:52:27', '2026-04-25 07:08:10', NULL, NULL, 'SEDERHANA', NULL, NULL, NULL, 0),
(6, 10, 2, 'Motor Kerap Hilang', 'Tolong tingkatkan rondaan SRS, banyak kes kecurian motor.', 'UNDER_REVIEW_AJK', NULL, NULL, '2026-03-13 19:52:27', '2026-04-25 07:08:10', NULL, NULL, 'SEDERHANA', NULL, NULL, NULL, 0),
(7, 7, 5, 'Pokok Tumbang Hempap Pagar', 'Hujan lebat semalam akibatkan dahan reput jatuh atas pagar dewan.', 'RESOLVED', NULL, NULL, '2026-03-13 19:52:27', '2026-04-25 07:08:10', NULL, NULL, 'SEDERHANA', NULL, NULL, NULL, 0),
(8, 9, 8, 'Kes Denggi Meningkat', 'Ada kes denggi dekat Lorong Kenanga 2, mohon fogging.', 'UNDER_REVIEW_AJK', NULL, NULL, '2026-03-13 19:52:27', '2026-04-25 07:08:10', NULL, NULL, 'SEDERHANA', NULL, NULL, NULL, 0),
(9, 3, 7, 'Budak Motor Bising Malam', 'Sekumpulan remaja selalu merempit pukul 2 pagi.', 'SUBMITTED', NULL, NULL, '2026-03-13 19:52:27', '2026-04-25 07:08:10', NULL, NULL, 'SEDERHANA', NULL, NULL, NULL, 0),
(10, 1, 10, 'Anjing Liar Berkeliaran', 'Bahaya untuk kanak-kanak yang pergi ke sekolah.', 'SUBMITTED', NULL, NULL, '2026-03-13 19:52:27', '2026-04-25 07:08:10', NULL, NULL, 'SEDERHANA', NULL, NULL, NULL, 0),
(11, 2, 2, 'Test1', 'Test1.1', 'UNDER_REVIEW_AJK', NULL, NULL, '2026-04-25 09:10:27', '2026-04-25 09:20:05', NULL, NULL, 'SEDERHANA', NULL, 'test1', NULL, 0),
(12, 4, 5, 'Test2', 'Banjir', 'SUBMITTED', 'aduan_4_1777271660732_Gantt Chart.gif', NULL, '2026-04-27 06:34:20', '2026-05-23 03:55:40', NULL, 10, 'TINGGI', NULL, 'DIhantar ke ketua kampung', 'fef', 0),
(13, 4, 1, 'Test3', 'test3', 'RESOLVED', 'aduan_4_1777287222288_3667006.png', NULL, '2026-04-27 10:53:42', '2026-04-27 11:10:52', NULL, 10, 'SEDERHANA', NULL, 'Selesai', NULL, 0),
(14, 4, 1, 'Test4', 'Test4', 'SUBMITTED', 'aduan_4_1777335127450_male-face-avatar-icon-set-flat-design-social-media-profiles_1281173-3806.avif', NULL, '2026-04-28 00:12:07', '2026-05-23 03:55:40', NULL, 10, 'TINGGI', NULL, 'Test4', 'Tidak lengkap', 0),
(15, 4, 1, 'Test5', 'Test5', 'SUBMITTED', NULL, NULL, '2026-04-28 00:17:17', '2026-05-23 03:55:40', NULL, 10, 'SEDERHANA', NULL, NULL, 'f', 0),
(16, 4, 1, 'Test6', 'fefoew', 'SUBMITTED', NULL, NULL, '2026-04-28 00:23:02', '2026-05-23 03:55:40', NULL, 10, 'SEDERHANA', NULL, 'ewfwf', NULL, 0),
(17, 4, 1, 'Test6', 'fewf', 'RESOLVED', NULL, NULL, '2026-04-28 00:27:33', '2026-04-28 00:29:33', NULL, 10, 'SEDERHANA', NULL, 'fewf', NULL, 0),
(18, 4, 1, 'Test2', 'few', 'CLOSED', NULL, NULL, '2026-04-28 00:34:30', '2026-04-28 00:36:53', NULL, 10, 'SEDERHANA', NULL, 'fwq', 'fwq', 0),
(19, 4, 1, 'test 7', 'vds', 'CLOSED', NULL, NULL, '2026-04-28 00:37:14', '2026-04-28 00:38:40', NULL, 10, 'SEDERHANA', NULL, 'vds', 'vds', 0),
(20, 2, 1, 'test 4', 'test 4', 'UNDER_REVIEW_AJK', NULL, NULL, '2026-05-10 12:52:16', '2026-05-10 12:59:18', NULL, 10, 'SEDERHANA', NULL, 'test4', NULL, 0),
(21, 2, 1, '23/5', '25/5', 'RESOLVED', 'aduan_2_1779474934287_professional-profile-pictures-1080-x-1080-460wjhrkbwdcp1ig.jpg', NULL, '2026-05-22 18:35:34', '2026-05-22 18:38:17', NULL, 10, 'SEDERHANA', NULL, '23/5', '23/5', 0),
(22, 2, 1, 'Test 100', 'test 100', 'UNDER_REVIEW_KETUA', 'aduan_2_1779509637370_professional-profile-pictures-1080-x-1080-460wjhrkbwdcp1ig.jpg', NULL, '2026-05-23 04:13:57', '2026-05-23 04:16:38', NULL, 10, 'TINGGI', NULL, 'test100', 'test100', 0);

-- --------------------------------------------------------

--
-- Table structure for table `ahli_keluarga`
--

CREATE TABLE `ahli_keluarga` (
  `id_ahli` int(11) NOT NULL,
  `id_pengguna` int(11) NOT NULL,
  `nama_penuh` varchar(150) NOT NULL,
  `nombor_kp` varchar(14) DEFAULT NULL,
  `nombor_telefon` varchar(20) DEFAULT NULL,
  `umur` int(3) DEFAULT NULL,
  `hubungan` varchar(50) DEFAULT NULL,
  `pekerjaan` varchar(50) DEFAULT NULL,
  `pendapatan` decimal(10,2) DEFAULT NULL,
  `pengesahan_pendapatan` varchar(255) DEFAULT NULL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ahli_keluarga`
--

INSERT INTO `ahli_keluarga` (`id_ahli`, `id_pengguna`, `nama_penuh`, `nombor_kp`, `nombor_telefon`, `umur`, `hubungan`, `pekerjaan`, `pendapatan`, `pengesahan_pendapatan`, `dibuat_pada`) VALUES
(3, 1, 'Ammar', '234341-24-1242', '012-3244 3315', 20, 'Lain-lain', NULL, NULL, NULL, '2026-05-20 11:49:53'),
(7, 2, 'ali', '111111-11-1111', '111-1111 1111', 20, 'Anak', 'test', 5000.00, 'verify_fam_2_1779446343237_Flow_of_Participation_–_Student_Research_Day_(SRD2026).pdf', '2026-05-22 16:57:20'),
(8, 2, 'aminah', '222222-22-2222', '022-2222 2222', 18, 'Anak', 'Pelajar', 0.00, '', '2026-05-22 16:57:20');

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
  `syarat_dokumen` text DEFAULT NULL,
  `status` varchar(20) DEFAULT 'AKTIF',
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `dikemaskini_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `dipadam_pada` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bantuan`
--

INSERT INTO `bantuan` (`id_bantuan`, `nama_bantuan`, `jenis_bantuan`, `peruntukan`, `syarat_dokumen`, `status`, `dibuat_pada`, `dikemaskini_pada`, `dipadam_pada`) VALUES
(1, 'Bantuan Sara Hidup Kampung', 'KOMUNITI', 15000.00, NULL, 'AKTIF', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(2, 'Khairat Kematian', 'KOMUNITI', 5000.00, NULL, 'AKTIF', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(3, 'Bantuan Bencana Alam (Banjir)', 'KOMUNITI', 20000.00, NULL, 'AKTIF', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(4, 'Bantuan Ibu Tunggal', 'KOMUNITI', 8000.00, NULL, 'AKTIF', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(5, 'Bantuan Awal Persekolahan', 'KOMUNITI', 10000.00, NULL, 'AKTIF', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(6, 'Bantuan Baja Pertanian', 'KOMUNITI', 6000.00, NULL, 'AKTIF', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(7, 'Pembaikan Rumah Daif', 'KOMUNITI', 50000.00, NULL, 'AKTIF', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(8, 'Bantuan Kerusi Roda OKU', 'KOMUNITI', 3000.00, NULL, 'AKTIF', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(9, 'Bantuan Peniaga Kecil', 'KOMUNITI', 12000.00, NULL, 'AKTIF', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(10, 'Dana Kecemerlangan Pelajar', 'KOMUNITI', 4000.00, NULL, 'AKTIF', '2026-03-13 19:52:27', '2026-03-13 19:52:27', NULL),
(11, 'BANTUAN PEMULIHAN RUMAH KEDIAMAN', 'RASMI', 0.00, NULL, 'AKTIF', '2026-04-22 10:42:49', '2026-04-22 10:42:49', NULL),
(12, 'BANTUAN RAWATAN PERUBATAN', 'RASMI', 0.00, NULL, 'AKTIF', '2026-04-22 10:42:49', '2026-04-22 10:42:49', NULL),
(13, 'BANTUAN SEWA RUMAH', 'RASMI', 0.00, NULL, 'AKTIF', '2026-04-22 10:42:49', '2026-04-22 10:42:49', NULL),
(14, 'BANTUAN TETAP BULANAN', 'RASMI', 0.00, NULL, 'AKTIF', '2026-04-22 10:42:49', '2026-04-22 10:42:49', NULL),
(15, 'BIASISWA PENDIDIKAN DALAM NEGARA (BPDN)', 'RASMI', 0.00, NULL, 'AKTIF', '2026-04-22 10:42:49', '2026-04-22 10:42:49', NULL),
(16, 'BIASISWA PENDIDIKAN LUAR NEGARA (BPLN)', 'RASMI', 0.00, NULL, 'AKTIF', '2026-04-22 10:42:49', '2026-04-22 10:42:49', NULL),
(17, 'BIASISWA PROFESIONAL PERAKAUNAN (BPP)', 'RASMI', 0.00, NULL, 'AKTIF', '2026-04-22 10:42:49', '2026-04-22 10:42:49', NULL),
(18, 'PROG. BIASISWA SULTAN ISMAIL PETRA (BSIP)', 'RASMI', 0.00, NULL, 'AKTIF', '2026-04-22 10:42:49', '2026-04-22 10:42:49', NULL),
(19, 'PROGRAM DERMASISWA SULTAN ISMAIL PETRA (DSIP)', 'RASMI', 0.00, NULL, 'AKTIF', '2026-04-22 10:42:49', '2026-04-22 10:42:49', NULL),
(20, 'SUMBANGAN IPT - FISABILILLAH', 'RASMI', 0.00, NULL, 'AKTIF', '2026-04-22 10:42:49', '2026-04-22 10:42:49', NULL),
(21, 'Test 2', 'KOMUNITI', 10.00, NULL, 'AKTIF', '2026-04-23 00:30:54', '2026-04-23 00:30:54', NULL),
(998, 'LAIN-LAIN (KOMUNITI)', 'KOMUNITI', 0.00, 'Sila lampirkan dokumen sokongan yang berkaitan.', 'AKTIF', '2026-05-04 17:18:42', '2026-05-04 17:18:42', NULL),
(999, 'LAIN-LAIN', 'RASMI', 0.00, 'Tiada', 'AKTIF', '2026-05-04 16:52:53', '2026-05-04 16:54:40', NULL),
(1000, 'Test A', 'RASMI', 0.00, 'Sijil Nikah', 'AKTIF', '2026-05-05 05:36:22', '2026-05-05 05:36:22', NULL),
(1001, 'Test B', 'KOMUNITI', 1000.00, 'Surat Nikah', 'AKTIF', '2026-05-05 05:38:19', '2026-05-05 05:38:19', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `bantuan_lampiran`
--

CREATE TABLE `bantuan_lampiran` (
  `id_lampiran` int(11) NOT NULL,
  `id_permohonan` int(11) NOT NULL,
  `nama_fail` varchar(255) NOT NULL,
  `jenis_lampiran` varchar(50) DEFAULT 'PEMOHON',
  `dimuat_naik_pada` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bantuan_lampiran`
--

INSERT INTO `bantuan_lampiran` (`id_lampiran`, `id_permohonan`, `nama_fail`, `jenis_lampiran`, `dimuat_naik_pada`) VALUES
(1, 32, '1777926944486_Lab_report5_s71383_cybersecurity.pdf', 'PEMOHON', '2026-05-04 20:35:44'),
(2, 32, '1777926944487_2112.10920v1.pdf', 'PEMOHON', '2026-05-04 20:35:44'),
(3, 32, '1777926944489_Assignment_Guidelines_260405_081555.pdf', 'PEMOHON', '2026-05-04 20:35:44'),
(4, 33, '1777927073154_Lab_report5_s71383_cybersecurity.pdf', 'PEMOHON', '2026-05-04 20:37:53'),
(5, 33, '1777927073159_2112.10920v1.pdf', 'PEMOHON', '2026-05-04 20:37:53'),
(6, 33, '1777927073161_Assignment_Guidelines_260405_081555.pdf', 'PEMOHON', '2026-05-04 20:37:53'),
(8, 34, '1777927520110_2112.10920v1.pdf', 'PEMOHON', '2026-05-04 20:45:20'),
(9, 34, '1777927520111_Assignment_Guidelines_260405_081555.pdf', 'PEMOHON', '2026-05-04 20:45:20'),
(10, 35, '1777928178734_Lab_report5_s71383_cybersecurity.pdf', 'PEMOHON', '2026-05-04 20:56:18'),
(11, 36, '1777928734684_Lab_report5_s71383_cybersecurity.pdf', 'PEMOHON', '2026-05-04 21:05:34'),
(12, 36, '1777928734686_2112.10920v1.pdf', 'PEMOHON', '2026-05-04 21:05:34'),
(13, 37, '1777960629949_Week4_(1).pdf', 'PEMOHON', '2026-05-05 05:57:09'),
(14, 37, '1777960629951_Week4.pdf', 'PEMOHON', '2026-05-05 05:57:09'),
(15, 37, '1777960629951_2112.10920v1_-_Copy.pdf', 'PEMOHON', '2026-05-05 05:57:09'),
(16, 36, 'KETUA_1777964948379_Lab_report5_s71383_cybersecurity_-_Copy.pdf', 'PENTADBIR', '2026-05-05 07:09:08'),
(17, 36, 'KETUA_1777964948387_Lab_report5_s71383_cybersecurity.pdf', 'PENTADBIR', '2026-05-05 07:09:08'),
(18, 38, '1778154790290_Lab_report5_s71383_cybersecurity_-_Copy.pdf', 'PEMOHON', '2026-05-07 11:53:10'),
(19, 39, '1779279938690_Individual_Assignment.pdf', 'PEMOHON', '2026-05-20 12:25:38'),
(20, 40, '1779453373652_Flow_of_Participation_â€“_Student_Research_Day_(SRD2026).pdf', 'PEMOHON', '2026-05-22 12:36:13'),
(21, 41, '1779454062744_Flow_of_Participation_â€“_Student_Research_Day_(SRD2026).pdf', 'PEMOHON', '2026-05-22 12:47:42');

-- --------------------------------------------------------

--
-- Table structure for table `bantuan_rule`
--

CREATE TABLE `bantuan_rule` (
  `rule_key` varchar(50) NOT NULL,
  `rule_name` varchar(100) NOT NULL,
  `weight` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bantuan_rule`
--

INSERT INTO `bantuan_rule` (`rule_key`, `rule_name`, `weight`) VALUES
('DEPENDENT_FACTOR', 'Faktor Bilangan Tanggungan', 50),
('EMPLOYMENT_STATUS_FACTOR', 'Faktor Pengangguran', 0),
('FAMILY_STATUS_FACTOR', 'Faktor Status Ibu Tunggal/OKU', 0),
('INCOME_FACTOR', 'Faktor Pendapatan Rendah', 50),
('POVERTY_LINE', 'Had Pendapatan Paras Kemiskinan', 1699.95);

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
  `requires_approval` tinyint(1) DEFAULT 0,
  `gambar_fasiliti` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fasiliti`
--

INSERT INTO `fasiliti` (`id_fasiliti`, `nama_fasiliti`, `lokasi`, `status`, `dibuat_pada`, `dikemaskini_pada`, `dipadam_pada`, `latitude`, `longitude`, `requires_approval`, `gambar_fasiliti`) VALUES
(1, 'Dewan Serbaguna', 'Pusat Kampung', 'AKTIF', '2026-03-13 19:52:27', '2026-04-28 14:16:09', NULL, 6.02890000, 102.29350000, 1, 'fasiliti_1777363928905_fasiliti_cropped.jpg'),
(2, 'Padang Bola Sepak', 'Jalan Bunga Raya', 'AKTIF', '2026-03-13 19:52:27', '2026-04-28 08:15:47', NULL, 6.02890000, 102.29350000, 0, 'fasiliti_1777364147873_fasiliti_cropped.jpg'),
(3, 'Gelanggang Futsal', 'Taman Belia', 'TIDAK AKTIF', '2026-03-13 19:52:27', '2026-04-28 08:16:27', NULL, 6.02890000, 102.29350000, 0, NULL),
(4, 'Balai Raya', 'Jalan Masjid', 'AKTIF', '2026-03-13 19:52:27', '2026-04-28 08:08:08', NULL, 6.02890000, 102.29350000, 0, 'fasiliti_1777363688503_fasiliti_cropped.jpg'),
(5, 'Masjid Al-Taqwa', 'Jalan Kenanga', 'AKTIF', '2026-03-13 19:52:27', '2026-04-28 08:14:42', NULL, 6.02890000, 102.29350000, 0, 'fasiliti_1777364082893_fasiliti_cropped.jpg'),
(6, 'Bilik Mesyuarat AJK', 'Kompleks Penghulu', 'AKTIF', '2026-03-13 19:52:27', '2026-04-28 08:13:14', NULL, 6.02890000, 102.29350000, 0, 'fasiliti_1777363994374_fasiliti_cropped.jpg'),
(7, 'Gelanggang Sepak Takraw', 'Jalan Mawar', 'TIDAK AKTIF', '2026-03-13 19:52:27', '2026-04-28 08:18:37', NULL, 6.02890000, 102.29350000, 0, NULL),
(8, 'Pusat Internet Desa', 'Sebelah Balai Raya', 'AKTIF', '2026-03-13 19:52:27', '2026-04-28 08:17:43', NULL, 6.02890000, 102.29350000, 0, 'fasiliti_1777364263083_fasiliti_cropped.jpg'),
(9, 'Taman Permainan Kanak-kanak', 'Jalan Dahlia', 'TIDAK AKTIF', '2026-03-13 19:52:27', '2026-04-28 08:16:43', NULL, 6.02890000, 102.29350000, 0, NULL),
(10, 'Tapak Pasar Malam', 'Dataran Kampung', 'TIDAK AKTIF', '2026-03-13 19:52:27', '2026-04-28 08:16:35', NULL, 6.02890000, 102.29350000, 0, NULL),
(11, 'Dewan Test1', 'Jalan 30', 'TIDAK_AKTIF', '2026-04-20 02:30:40', '2026-04-28 08:15:57', '2026-04-28 08:15:57', 6.02890000, 102.29350000, 0, NULL);

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
  `durasi` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fasiliti_slot`
--

INSERT INTO `fasiliti_slot` (`id_slot`, `id_fasiliti`, `masa_mula`, `masa_tamat`, `durasi`) VALUES
(1, 1, '08:00:00', '10:00:00', '2'),
(2, 1, '10:00:00', '12:00:00', '2'),
(3, 1, '12:00:00', '14:00:00', '2'),
(4, 1, '14:00:00', '16:00:00', '2'),
(5, 1, '16:00:00', '18:00:00', '2'),
(6, 1, '18:00:00', '20:00:00', '2'),
(7, 1, '20:00:00', '22:00:00', '2'),
(8, 1, '22:00:00', '23:59:59', '2'),
(9, 1, '08:00:00', '14:00:00', 'HalfDay'),
(10, 1, '08:00:00', '22:00:00', 'FullDay'),
(11, 2, '08:00:00', '10:00:00', '2'),
(12, 2, '10:00:00', '12:00:00', '2'),
(13, 2, '16:00:00', '18:00:00', '2'),
(14, 2, '20:00:00', '22:00:00', '2'),
(15, 2, '08:00:00', '22:00:00', 'FullDay');

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
(1, 1, 'Gotong Royong Perdana', 'Program membersihkan tanah perkuburan pada hari Sabtu ini.', 'Umum', NULL, 'Published', NULL, NULL, NULL, NULL, '2023-11-01', '2026-03-13 19:52:27', '2026-04-30 07:01:42', '2026-04-30 07:01:42'),
(2, 1, 'Mesyuarat AJK Bulanan', 'Semua AJK diwajibkan hadir ke balai raya pada malam Jumaat.', 'Umum', 'hebahan_21_1777533577091_Gemini_Generated_Image_p1lu6lp1lu6lp1lu.png', 'Published', '2026-06-15 20:30:00', '2026-06-15 22:30:00', 'Bilik Mesyuarat AJK', NULL, '2023-11-05', '2026-03-13 19:52:27', '2026-04-30 07:19:37', NULL),
(3, 1, 'Bantuan Banjir Monsun', 'Sila daftar di dewan untuk mangsa banjir.', 'Umum', NULL, 'Published', NULL, NULL, NULL, NULL, '2023-11-15', '2026-03-13 19:52:27', '2026-04-30 07:21:03', '2026-04-30 07:21:03'),
(4, 3, 'Kejohanan Futsal Belia', 'Penyertaan dibuka untuk belia kampung.', 'Umum', 'hebahan_21_1777532961665_Gemini_Generated_Image_ti6agpti6agpti6a.png', 'Published', '2026-06-01 08:00:00', '2026-06-02 11:00:00', 'Gelanggang Futsal Kampung Danan', NULL, '2023-11-20', '2026-03-13 19:52:27', '2026-04-30 07:09:21', NULL),
(5, 8, 'Kuliah Maghrib Bulanan', 'Kuliah akan disampaikan oleh Ustaz jemputan bulan ini.', 'Umum', 'hebahan_21_1777533462058_Gemini_Generated_Image_n3p8wln3p8wln3p8.png', 'Published', '2026-05-20 19:00:00', '2026-05-20 22:00:00', '', NULL, '2023-11-22', '2026-03-13 19:52:27', '2026-04-30 07:17:42', NULL),
(6, 9, 'Kutipan Yuran Khairat', 'Ahli diminta menjelaskan yuran RM20 setahun.', 'Umum', NULL, 'Published', NULL, NULL, NULL, NULL, '2023-11-25', '2026-03-13 19:52:27', '2026-04-30 07:21:08', '2026-04-30 07:21:08'),
(7, 1, 'Suntikan Vaksin Percuma', 'Klinik Kesihatan akan buka kaunter di Balai Raya.', 'Umum', NULL, 'Published', NULL, NULL, NULL, NULL, '2023-12-01', '2026-03-13 19:52:27', '2026-04-30 07:21:12', '2026-04-30 07:21:12'),
(8, 10, 'Rondaan SRS Malam', 'Jadual rondaan telah dikemaskini untuk bulan Disember.', 'Umum', NULL, 'Published', NULL, NULL, NULL, NULL, '2023-12-05', '2026-03-13 19:52:27', '2026-04-30 07:21:16', '2026-04-30 07:21:16'),
(9, 5, 'Sumbangan Asnaf', 'Majlis penyerahan bantuan asnaf di masjid.', 'Umum', NULL, 'Published', NULL, NULL, NULL, NULL, '2023-12-10', '2026-03-13 19:52:27', '2026-04-30 07:21:20', '2026-04-30 07:21:20'),
(10, 1, 'Sambutan Hari Keluarga', 'Semua penduduk dijemput hadir ke padang awam.', 'Umum', 'hebahan_21_1777533658918_Gemini_Generated_Image_5x766n5x766n5x76 (1).png', 'Published', '2026-05-25 14:00:00', '2026-05-25 18:00:00', 'Dewan Serbaguna', NULL, '2023-12-15', '2026-03-13 19:52:27', '2026-04-30 07:20:58', NULL),
(11, 21, 'Test2', 'fwqfw', 'Umum', 'hebahan_21_1777347009060_3667006.png', 'Published', '2026-04-28 11:29:00', '2026-04-30 11:29:00', 'feww', '2026-05-07 11:29:00', '2026-04-28', '2026-04-28 03:30:09', '2026-04-30 07:01:34', '2026-04-30 07:01:34'),
(12, 21, 'Gotong Royong Perdana', 'Hebahan Program Khidmat Masyarakat: Semangat Gotong-Royong\r\n\r\nTuan/Puan,\r\n\r\nMerujuk kepada poster, pihak kami dengan sukacitanya ingin menjemput seluruh warga [Nama Organisasi/Kawasan] untuk menyertai aktiviti gotong-royong perdana.\r\n\r\nObjektif program ini adalah untuk memupuk kesedaran tentang kebersihan alam sekitar dan mengukuhkan semangat kerjasama antara kita. Kerana seperti slogan kami, ', 'Umum', 'hebahan_21_1777533819112_Gemini_Generated_Image_vypzswvypzswvypz.png', 'Published', '2026-05-30 09:00:00', '2026-05-30 12:00:00', 'Seluruh Kampung', '2026-04-30 22:19:00', '2026-04-28', '2026-04-28 14:19:18', '2026-04-30 07:23:39', NULL);

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
(12, 'Test last'),
(13, 'Test 5'),
(14, 'Test 6');

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
-- Table structure for table `laporan_snapshot`
--

CREATE TABLE `laporan_snapshot` (
  `id_snapshot` int(11) NOT NULL,
  `tahun` int(11) NOT NULL,
  `bulan` int(11) NOT NULL,
  `total_penduduk` int(11) NOT NULL,
  `total_bantuan_dipohon` int(11) NOT NULL,
  `total_bantuan_diluluskan` int(11) NOT NULL,
  `total_aduan_diterima` int(11) NOT NULL,
  `total_aduan_selesai` int(11) NOT NULL,
  `total_tempahan_fasiliti` int(11) NOT NULL,
  `purata_pendapatan` decimal(10,2) NOT NULL,
  `snapshot_pada` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `laporan_snapshot`
--

INSERT INTO `laporan_snapshot` (`id_snapshot`, `tahun`, `bulan`, `total_penduduk`, `total_bantuan_dipohon`, `total_bantuan_diluluskan`, `total_aduan_diterima`, `total_aduan_selesai`, `total_tempahan_fasiliti`, `purata_pendapatan`, `snapshot_pada`) VALUES
(1, 2026, 1, 140, 5, 3, 4, 3, 10, 2450.00, '2026-05-22 17:36:09'),
(2, 2026, 2, 145, 8, 5, 6, 4, 15, 2480.00, '2026-05-22 17:36:09'),
(3, 2026, 3, 150, 10, 7, 7, 5, 18, 2400.00, '2026-05-22 17:36:09'),
(4, 2026, 4, 156, 12, 9, 8, 6, 22, 2380.00, '2026-05-22 17:36:09'),
(5, 2026, 5, 21, 36, 7, 16, 7, 26, 2100.01, '2026-05-22 18:30:34');

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
(1, 11, 10, 'SUBMITTED', 'UNDER_REVIEW_AJK', 'test1', '2026-04-25 09:20:05'),
(2, 12, 10, 'SUBMITTED', 'UNDER_REVIEW_AJK', 'DIhantar ke ketua kampung', '2026-04-27 06:35:22'),
(3, 13, 10, 'SUBMITTED', 'UNDER_REVIEW_AJK', 'Akan dihantar ke ketua kampung', '2026-04-27 11:02:05'),
(4, 13, 10, 'UNDER_REVIEW_AJK', 'IN_PROGRESS_AJK', 'Tindakan akan dibuat', '2026-04-27 11:09:41'),
(5, 13, 10, 'IN_PROGRESS_AJK', 'RESOLVED', 'Selesai', '2026-04-27 11:10:52'),
(6, 14, 10, 'SUBMITTED', 'REJECTED', 'Tidak Penting', '2026-04-28 00:13:07'),
(7, 14, 1, 'REJECTED', 'CLOSED', 'Tidak lengkap', '2026-04-28 00:14:16'),
(8, 16, 10, 'SUBMITTED', 'UNDER_REVIEW_AJK', 'ff', '2026-04-28 00:24:14'),
(9, 16, 10, 'UNDER_REVIEW_AJK', 'IN_PROGRESS_AJK', 'rr', '2026-04-28 00:24:26'),
(10, 16, 10, 'IN_PROGRESS_AJK', 'RESOLVED', 'fewfkewfn', '2026-04-28 00:24:42'),
(11, 2, 10, 'SUBMITTED', 'UNDER_REVIEW_AJK', 'wdw', '2026-04-28 00:26:52'),
(12, 17, 10, 'SUBMITTED', 'UNDER_REVIEW_AJK', 'eefdw', '2026-04-28 00:27:48'),
(13, 17, 10, 'UNDER_REVIEW_AJK', 'IN_PROGRESS_AJK', 'fw', '2026-04-28 00:28:00'),
(14, 17, 10, 'IN_PROGRESS_AJK', 'RESOLVED', 'fewf', '2026-04-28 00:29:33'),
(15, 18, 10, 'SUBMITTED', 'UNDER_REVIEW_AJK', 'fw', '2026-04-28 00:35:34'),
(16, 18, 10, 'UNDER_REVIEW_AJK', 'IN_PROGRESS_AJK', 'few', '2026-04-28 00:35:43'),
(17, 18, 10, 'IN_PROGRESS_AJK', 'RESOLVED', 'fwq', '2026-04-28 00:36:24'),
(18, 18, 1, 'RESOLVED', 'CLOSED', 'fwq', '2026-04-28 00:36:53'),
(19, 19, 10, 'SUBMITTED', 'UNDER_REVIEW_AJK', 'dv', '2026-04-28 00:37:45'),
(20, 19, 10, 'UNDER_REVIEW_AJK', 'ESCALATED_TO_KETUA', 'vds', '2026-04-28 00:37:52'),
(21, 19, 1, 'ESCALATED_TO_KETUA', 'UNDER_REVIEW_KETUA', 'dv', '2026-04-28 00:38:12'),
(22, 19, 1, 'UNDER_REVIEW_KETUA', 'IN_PROGRESS_HIGH_LEVEL', 'vd', '2026-04-28 00:38:22'),
(23, 19, 1, 'IN_PROGRESS_HIGH_LEVEL', 'RESOLVED', 'vd', '2026-04-28 00:38:31'),
(24, 19, 1, 'RESOLVED', 'CLOSED', 'vds', '2026-04-28 00:38:40'),
(25, 20, 10, 'SUBMITTED', 'UNDER_REVIEW_AJK', 'test4', '2026-05-10 12:59:18'),
(26, 21, 10, 'SUBMITTED', 'UNDER_REVIEW_AJK', '23/5', '2026-05-22 18:36:49'),
(27, 21, 10, 'UNDER_REVIEW_AJK', 'ESCALATED_TO_KETUA', '23/5', '2026-05-22 18:37:12'),
(28, 21, 1, 'ESCALATED_TO_KETUA', 'UNDER_REVIEW_KETUA', '23/5', '2026-05-22 18:37:42'),
(29, 21, 1, 'UNDER_REVIEW_KETUA', 'IN_PROGRESS_HIGH_LEVEL', '23/5', '2026-05-22 18:38:00'),
(30, 21, 1, 'IN_PROGRESS_HIGH_LEVEL', 'RESOLVED', '23/5', '2026-05-22 18:38:17'),
(31, 22, 10, 'SUBMITTED', 'UNDER_REVIEW_AJK', 'test100', '2026-05-23 04:15:05'),
(32, 22, 10, 'UNDER_REVIEW_AJK', 'ESCALATED_TO_KETUA', 'test100', '2026-05-23 04:15:29'),
(33, 22, 1, 'ESCALATED_TO_KETUA', 'UNDER_REVIEW_KETUA', 'test100', '2026-05-23 04:16:38');

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
(7, 2, 3, 'KEMASKINI_PROFIL', 'Admin mengemaskini: Alamat (Bandar: - -> Pasir Puteh; Poskod: - -> 16810; Negeri: - -> Kelantan; ). ', '2026-04-22 09:21:47'),
(8, 2, 3, 'KEMASKINI_PROFIL', 'Admin mengemaskini: Status Keluarga (Bujang -> Berkahwin). ', '2026-05-09 12:03:05');

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
  `foto_profil` varchar(255) DEFAULT 'default_avatar.png',
  `pengesahan_pendapatan` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pengguna`
--

INSERT INTO `pengguna` (`id_pengguna`, `nama_penuh`, `nombor_kp`, `nombor_telefon`, `tarikh_lahir`, `kata_laluan`, `status`, `status_keluarga`, `pekerjaan`, `pendapatan`, `nama_jalan`, `daerah`, `nombor_poskod`, `bandar`, `negeri`, `dibuat_pada`, `dikemaskini_pada`, `dipadam_pada`, `lampiran_pengesahan`, `reset_token`, `token_expiry`, `email`, `latitude`, `longitude`, `foto_profil`, `pengesahan_pendapatan`) VALUES
(1, 'Ahmad bin Ali', '800101031234', '012-3456 5353', '1980-01-01', '$2a$10$4REPQtKXDeP/GXdC2d06SuFynGXcEkMfbsfRUQZ09L7itoiobVi/C', 1, 'Bujang', 'CEO', 1200.09, 'Jalan Mawar 11', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-03-13 19:52:27', '2026-05-20 11:49:53', NULL, NULL, NULL, NULL, 'khairuliman736@gmail.com', 6.03112933, 102.29697188, 'profil_1_1779277793710_professional-profile-pictures-1080-x-1080-460wjhrkbwdcp1ig.jpg', NULL),
(2, 'Siti binti Abuyal', '850202035566', '011-1101 3816', '1985-02-02', '$2a$12$NUn7qK.c4bD4scgC8fG7/ucy.iqtBLxkoqIR7.b1s0nXhM88UNPa6', 1, 'Berkahwin', 'Petani', 799.98, 'Jalan Melati 2', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-03-13 19:52:27', '2026-05-22 16:57:20', NULL, NULL, NULL, NULL, 'siti@gmail.com', 5.92294100, 102.31455260, 'profil_2_1776905643592.jpg', 'verify_2_1779446283020_Flow_of_Participation_–_Student_Research_Day_(SRD2026).pdf'),
(3, 'Muthu a/l Samy', '900303037788', '014-5678 901', '1990-03-03', '$2a$12$GIGxqxu1FHhiZkKGkhSAGerrvcl4hXyp1uO3Qk3iu.mJVhv4ZMarm', 1, 'Bujang', 'Peniaga', 3999.99, 'Jalan Kenanga', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-03-13 19:52:27', '2026-04-23 00:52:40', NULL, NULL, NULL, NULL, 's71383@ocean.umt.edu.my', 6.03130217, 102.29371122, 'profil_3_1776905560441.jpg', NULL),
(4, 'Chong Wei Ming', '750404039911', '016-6789 011', '1975-04-04', '$2a$12$GIGxqxu1FHhiZkKGkhSAGerrvcl4hXyp1uO3Qk3iu.mJVhv4ZMarm', 1, 'Bujang', 'Guru', 3000.01, 'Jalan Teratai', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-03-13 19:52:27', '2026-04-28 09:15:22', NULL, NULL, NULL, NULL, 'khayxstyle@gmail.com', 5.92294100, 102.31455260, 'profil_4_1776905581340.jpg', NULL),
(5, 'Aminah binti Hassan', '650505032233', '017-7890123', '1965-05-05', '$2a$12$GIGxqxu1FHhiZkKGkhSAGerrvcl4hXyp1uO3Qk3iu.mJVhv4ZMarm', 1, 'Ibu Tunggal', 'Pesara', 1200.00, 'Jalan Orkid', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-03-13 19:52:27', '2026-04-23 00:53:46', NULL, NULL, NULL, NULL, 'aminah@gmail.com', 6.03130217, 102.29371122, 'profil_5_1776905626958.jpg', NULL),
(6, 'Kamal bin Mustafa', '950606034455', '011-8901234', '1995-06-06', '$2a$12$GIGxqxu1FHhiZkKGkhSAGerrvcl4hXyp1uO3Qk3iu.mJVhv4ZMarm', 1, 'Bujang', 'Jurutera', 4000.00, 'Jalan Mawar 2', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-03-13 19:52:27', '2026-04-23 00:52:25', NULL, NULL, NULL, NULL, 'kamal@gmail.com', 6.03130217, 102.29371122, 'profil_6_1776905545480.jpg', NULL),
(7, 'Nurul binti Hisham', '880707036677', '018-9012345', '1988-07-07', '$2a$12$GIGxqxu1FHhiZkKGkhSAGerrvcl4hXyp1uO3Qk3iu.mJVhv4ZMarm', 1, 'Berkahwin', 'Suri Rumah', 0.00, 'Jalan Dahlia', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-03-13 19:52:27', '2026-04-19 13:56:08', NULL, NULL, NULL, NULL, '', 6.03130217, 102.29371122, 'default_avatar.png', NULL),
(8, 'Razak bin Osman', '700808038899', '019-0123456', '1970-08-08', 'hash123', 1, 'Berkahwin', 'Petani', 1800.00, 'Jalan Raya Kampung', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-03-13 19:52:27', '2026-04-19 13:56:08', NULL, NULL, NULL, NULL, '', 6.03130217, 102.29371122, 'default_avatar.png', NULL),
(9, 'Fatimah binti Zainal', '920909031122', '012-1234567', '1992-09-09', 'hash123', 1, 'Bujang', 'Kerani Kewangan', 2200.00, 'Jalan Kenanga 2', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-03-13 19:52:27', '2026-04-19 13:56:08', NULL, NULL, NULL, NULL, '', 6.03130217, 102.29371122, 'default_avatar.png', NULL),
(10, 'Hafiz bin Johan', '821010033344', '013-2345678', '1982-10-10', '$2a$12$GIGxqxu1FHhiZkKGkhSAGerrvcl4hXyp1uO3Qk3iu.mJVhv4ZMarm', 1, 'Berkahwin', 'Pemandu Lori', 2800.00, 'Jalan Orkid 3', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-03-13 19:52:27', '2026-04-25 07:36:35', NULL, NULL, NULL, NULL, '', 6.03130217, 102.29371122, 'default_avatar.png', NULL),
(11, 'Iman Bin Khairul', '040101030441', NULL, '2004-01-01', 'Abdkarim', 1, NULL, NULL, NULL, 'Kg Danan', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-04-01 07:11:10', '2026-04-19 13:56:08', NULL, 'bukti_040101030441_1775027470599.pdf', NULL, NULL, '', 6.03130217, 102.29371122, 'default_avatar.png', NULL),
(15, 'Muhammad Naim Najmi Bin Hazre', '990404110432', NULL, '1999-04-04', 'hash123', 1, NULL, NULL, NULL, 'Kg Danan', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-04-05 12:33:29', '2026-04-19 13:56:08', NULL, 'bukti_990404110432_1775392409643.pdf', NULL, NULL, '', 6.03130217, 102.29371122, 'default_avatar.png', NULL),
(16, 'Muhammad Naim Najmi Bin Hazrew', '990404110431', '012345678', '1999-04-04', 'hash123', 1, NULL, NULL, NULL, 'Kg Danan', 'Selising', '16810', '800101031231', 'Kelantan', '2026-04-06 09:06:30', '2026-04-19 13:56:08', NULL, 'bukti_990404110431_1775466390091.pdf', NULL, NULL, '', 6.03130217, 102.29371122, 'default_avatar.png', NULL),
(18, 'MUHAMMAD KHAIRUL IMAN BIN ABD KARIM', '040101030440', '01111013816', '2004-01-01', '$2a$10$D0Yd9Rk1AnddKLDA1AFx/Oax/X2fNfFv9zR4cgwU1XaS8tHOI5Jva', 1, NULL, NULL, NULL, 'Lot. 98 Kg Danan', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-04-14 09:17:11', '2026-04-19 13:56:08', NULL, 'bukti_040101030440_1776158231600.pdf', NULL, NULL, '', 6.03130217, 102.29371122, 'default_avatar.png', NULL),
(21, 'MUHAMAD AMIR BIN RUSLI', '042304034506', '01111013816', '2005-11-04', '$2a$10$PWjG2khEQHBAx8sDwadOqe1OHEc.ZK0JV5CGmSllfNIGnSYKDeld.', 1, NULL, NULL, NULL, 'Lot. 98 Kg Danan', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-04-17 04:10:48', '2026-04-19 13:56:08', NULL, 'bukti_042304034506_1776399048381.pdf', NULL, NULL, 'amir123@gmail.com', 6.03130217, 102.29371122, 'default_avatar.png', NULL),
(22, 'MUHAMMD AIMAN BIN SAMAD', '010302030441', '01120034344', '2001-03-02', '$2a$10$.l7X.UGDpzKRG47QQ76YbOsKx18VRpxslYVWinUWw6xuY6ucAbqHS', 2, NULL, NULL, NULL, 'Lot 67, Kampung Danan', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-04-18 05:48:01', '2026-04-20 12:31:10', NULL, 'bukti_010302030441_1776491281745.pdf', NULL, NULL, 'khayxstyle@gmail.com', 6.03130217, 102.29371122, 'default_avatar.png', NULL),
(23, 'HAIKAL DANIAL BIN MOHD ROHAIZA', '040503030441', '03222004245', '2004-05-03', '$2a$10$ej9jvSZ9UH43oocQg1jBEudAbFyN0UBVVUPWDRF9oUr6moMw6CTOi', 1, NULL, NULL, NULL, 'Kg Danan', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-04-20 12:33:29', '2026-04-23 04:51:27', NULL, 'bukti_040503030441_1776688409125.pdf', NULL, NULL, 's70622@ocean.umt.edu.my', NULL, NULL, 'default_avatar.png', NULL),
(24, 'HARIZ FARHAN BIN AHMAD', '440303020441', '01433056007', '2044-03-03', '$2a$10$.48PBQFJgEqH8mwRyYIEMeUYIpoKizcpjXhhYKrGJY6q69dkWr5Ue', 1, NULL, NULL, NULL, 'Lot 55, Kampung Dana', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-04-23 00:55:38', '2026-05-08 02:15:53', NULL, 'bukti_440303020441_1776905738539.pdf', NULL, NULL, 'hariz@gmail.com', NULL, NULL, 'default_avatar.png', NULL),
(25, 'asma bin husna', '032405040332', '01111012333', '2004-12-05', '$2a$10$LGUWSbgq.R0HKUr1H5IJruri1UJcDUffLsjiOoYH0EGZBq3Mshd.G', 2, NULL, NULL, NULL, 'LOT96, KG DANAN', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-05-08 02:17:11', '2026-05-09 12:02:38', NULL, 'bukti_032405040332_1778206631690_Lab_report5_s71383_cybersecurity.pdf', NULL, NULL, 'asma@gmail.com', NULL, NULL, 'default_avatar.png', NULL),
(26, 'MUHAMMAD AIDIL BIN HAMAT', '590202030441', '01230546604', '1959-02-02', '$2a$10$1IxcVyVhhNwEiEt04kq1E.9kpORrYqZ6dHxjmqvxFuVsbe5k./LGi', 1, NULL, NULL, NULL, 'No 12, Jalan Melati', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-05-09 11:29:59', '2026-05-09 11:36:11', NULL, 'bukti_590202030441_1778326199302_Lab_report5_s71383_cybersecurity.pdf', NULL, NULL, 'khairuliman736@gmail.com', NULL, NULL, 'default_avatar.png', NULL),
(27, 'Muthu a/l Samya', '800101-03-1235', '01111013817', '1980-01-01', '$2a$10$n54Z3XAhvzWz6QJbTulxJefaU0MUaTblkq/9NiN43pubcNFPypRHG', 1, NULL, NULL, NULL, 'kampong pok jin Terengganu', 'Selising', '16810', 'Pasir Puteh', 'Kelantan', '2026-05-18 08:37:46', '2026-05-18 08:39:10', NULL, 'bukti_800101-03-1235_1779093466254_Internship_for_Computer___IT_Students_Job_in_Kuala_Lumpur_-_Jobstreet.pdf', NULL, NULL, 's70810@ocean.umt.edu.my', NULL, NULL, 'default_avatar.png', NULL);

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
(24, 3),
(25, 4),
(26, 4),
(27, 4);

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
  `nama_bank` varchar(100) DEFAULT NULL,
  `nombor_akaun` varchar(50) DEFAULT NULL,
  `penyata_bank` varchar(255) DEFAULT NULL,
  `catatan_pemohon` text DEFAULT NULL,
  `catatan_pentadbir` text DEFAULT NULL,
  `dokumen_pentadbir` varchar(255) DEFAULT NULL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `dikemaskini_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `dipadam_pada` timestamp NULL DEFAULT NULL,
  `eligibility_score` double DEFAULT 0,
  `eligibility_tier` varchar(20) DEFAULT 'RENDAH',
  `eligibility_flags` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `permohonan_bantuan`
--

INSERT INTO `permohonan_bantuan` (`id_permohonan`, `id_pengguna`, `id_bantuan`, `status`, `nama_bank`, `nombor_akaun`, `penyata_bank`, `catatan_pemohon`, `catatan_pentadbir`, `dokumen_pentadbir`, `dibuat_pada`, `dikemaskini_pada`, `dipadam_pada`, `eligibility_score`, `eligibility_tier`, `eligibility_flags`) VALUES
(1, 5, 4, 'DILULUSKAN', NULL, NULL, NULL, 'Mohon bantuan kewangan sara anak.', NULL, NULL, '2026-03-13 19:52:27', '2026-05-22 16:53:03', NULL, 40, 'SEDERHANA', '[\"PENDAPATAN_RENDAH\",\"IBU_BAPA_TUNGGAL\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(2, 8, 6, 'DIKEMBALIKAN', NULL, NULL, NULL, 'Mohon baja untuk kebun.', 'kabur', NULL, '2026-03-13 19:52:27', '2026-05-22 16:53:03', NULL, 20, 'RENDAH', '[\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(3, 7, 5, 'MENUNGGU', NULL, NULL, NULL, 'Anak 3 orang akan masuk sekolah.', NULL, NULL, '2026-03-13 19:52:27', '2026-05-22 16:53:03', NULL, 50, 'SEDERHANA', '[\"TIADA_PENDAPATAN\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(4, 4, 9, 'DILULUSKAN', NULL, NULL, NULL, 'Mohon bantuan modal niaga.', NULL, NULL, '2026-03-13 19:52:27', '2026-05-22 16:53:03', NULL, 5, 'RENDAH', '[]'),
(5, 2, 5, 'LULUS', NULL, NULL, NULL, 'Mohon bantuan pakaian sekolah anak.', 'DILULUSKAN: Permohonan disokong oleh Ketua Kampung.', NULL, '2026-03-13 19:52:27', '2026-05-22 17:38:34', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(6, 10, 3, 'MENUNGGU', NULL, NULL, NULL, 'Rumah dimasuki air sedalam 1 meter.', NULL, NULL, '2026-03-13 19:52:27', '2026-05-22 16:53:03', NULL, 5, 'RENDAH', '[]'),
(7, 5, 7, 'DITOLAK', NULL, NULL, NULL, 'Atap zink bocor teruk.', NULL, NULL, '2026-03-13 19:52:27', '2026-05-22 16:53:03', NULL, 40, 'SEDERHANA', '[\"PENDAPATAN_RENDAH\",\"IBU_BAPA_TUNGGAL\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(8, 6, 10, 'DILULUSKAN', NULL, NULL, NULL, 'Adik dapat 5A SPM.', NULL, NULL, '2026-03-13 19:52:27', '2026-05-22 16:53:03', NULL, 5, 'RENDAH', '[]'),
(9, 9, 1, 'LULUS', NULL, NULL, NULL, 'Kos sara hidup meningkat.', 'DILULUSKAN: Permohonan disokong oleh Ketua Kampung.', NULL, '2026-03-13 19:52:27', '2026-05-22 16:53:03', NULL, 20, 'RENDAH', '[]'),
(10, 3, 9, 'DITOLAK', NULL, NULL, NULL, 'Mohon tambah gerai.', NULL, NULL, '2026-03-13 19:52:27', '2026-05-22 16:53:03', NULL, 5, 'RENDAH', '[]'),
(11, 2, 1, 'DITOLAK', NULL, NULL, NULL, NULL, 'DITOLAK oleh Ketua Kampung: DITOLAK: Skor kelayakan permohonan (30%) adalah di bawah paras minima kelayakan. Sila hubungi AJK jika maklumat sosio-ekonomi (pendapatan/pekerjaan/ahli keluarga) perlu dikemaskini.', NULL, '2026-04-22 10:17:39', '2026-05-22 17:38:34', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(12, 2, 2, 'MENUNGGU_KETUA', NULL, NULL, NULL, NULL, 'Disemak oleh JKKK: Dokumen Lengkap.', NULL, '2026-04-22 10:29:15', '2026-05-22 17:38:34', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(13, 2, 1, 'LULUS', NULL, NULL, NULL, 'Test2', 'DILULUSKAN: Permohonan disokong oleh Ketua Kampung.', NULL, '2026-04-22 10:45:21', '2026-05-22 17:38:34', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(14, 2, 9, 'MENUNGGU_KETUA', NULL, NULL, NULL, 'test2', 'Disemak oleh JKKK: Dokumen Lengkap.', NULL, '2026-04-22 10:47:08', '2026-05-22 17:38:34', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(15, 2, 6, 'MENUNGGU_KETUA', NULL, NULL, NULL, 'test3', 'Disemak oleh JKKK: Dokumen Lengkap.', NULL, '2026-04-22 10:49:46', '2026-05-22 17:38:34', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(16, 2, 2, 'MENUNGGU_KETUA', NULL, NULL, NULL, 'Test4', 'Disemak oleh JKKK: Dokumen Lengkap.', NULL, '2026-04-22 10:58:18', '2026-05-22 17:38:34', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(17, 2, 10, 'MENUNGGU_KETUA', NULL, NULL, NULL, 'Test6', 'Disemak oleh JKKK: Dokumen Lengkap.', NULL, '2026-04-22 10:59:10', '2026-05-22 17:38:34', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(18, 2, 9, 'LULUS', NULL, NULL, NULL, 'Test7', 'DILULUSKAN: Permohonan disokong oleh Ketua Kampung.', NULL, '2026-04-22 11:04:03', '2026-05-22 17:38:34', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(20, 2, 11, 'MENUNGGU_KETUA', NULL, NULL, NULL, 'Test11', 'Disemak oleh JKKK: Dokumen Lengkap.', NULL, '2026-04-22 11:11:51', '2026-05-22 17:38:34', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(21, 4, 6, 'LULUS', NULL, NULL, NULL, 'Test terakhir 1.1.1', 'DILULUSKAN: Permohonan disokong oleh Ketua Kampung.', NULL, '2026-04-22 13:17:55', '2026-05-22 16:47:05', NULL, 5, 'RENDAH', '[]'),
(22, 2, 7, 'MENUNGGU_KETUA', NULL, NULL, NULL, 'test10', 'Disemak oleh JKKK: Dokumen Lengkap.', NULL, '2026-04-23 04:56:00', '2026-05-22 16:57:51', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(23, 4, 1, 'MENUNGGU_KETUA', NULL, NULL, NULL, 'maklumat telah dikemaskini', 'Disemak oleh JKKK: Dokumen Lengkap.', NULL, '2026-04-28 01:25:17', '2026-05-22 16:47:05', NULL, 5, 'RENDAH', '[]'),
(24, 2, 1, 'DITOLAK', 'Bank Islam', '042414255253533', 'BANK_1777893645011_Lab_report5_s71383_cybersecurity.pdf', 'Test A', 'DITOLAK oleh Ketua Kampung: dw', NULL, '2026-05-04 11:20:45', '2026-05-22 16:57:51', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(26, 2, 11, 'LULUS', NULL, NULL, NULL, 'lai', 'DILULUSKAN: Permohonan disokong oleh Ketua Kampung.', NULL, '2026-05-04 16:44:01', '2026-05-22 16:57:51', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(30, 2, 999, 'DIKEMBALIKAN', NULL, NULL, NULL, 'LAIN-LAIN: Biasiswa Yayasan | test', 'IC Kabur', NULL, '2026-05-04 17:12:41', '2026-05-22 16:57:51', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(31, 2, 1, 'DIKEMBALIKAN', 'e', 'ge', 'BANK_1777925546990_Lab_report5_s71383_cybersecurity.pdf', 'fe', 'fe', NULL, '2026-05-04 20:12:26', '2026-05-22 16:57:51', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(32, 2, 1, 'BARU', 'ik', '22444', 'BANK_1777926944490_Lab_report5_s71383_cybersecurity.pdf', 'test b', 'Cuba Lagi', NULL, '2026-05-04 20:35:44', '2026-05-22 16:57:51', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(33, 2, 2, 'BARU', 'ihi', '22444', 'BANK_1777927073162_Lab_report5_s71383_cybersecurity.pdf', 'ef', NULL, NULL, '2026-05-04 20:37:53', '2026-05-22 16:57:51', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(34, 2, 4, 'BARU', 'wf', '22444', 'BANK_1777927520112_Lab_report5_s71383_cybersecurity.pdf', 'Test 10', NULL, NULL, '2026-05-04 20:45:20', '2026-05-22 16:57:51', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(35, 2, 3, 'BARU', 'fef', '22444', 'BANK_1777928178734_Lab_report5_s71383_cybersecurity.pdf', 'Test Baru', 'IC Kabur', NULL, '2026-05-04 20:56:18', '2026-05-22 16:57:51', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(36, 2, 17, 'LULUS', NULL, NULL, NULL, 'Test AB', 'DILULUSKAN: Permohonan disokong oleh Ketua Kampung.', NULL, '2026-05-04 21:05:34', '2026-05-22 16:57:51', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(37, 2, 11, 'BARU', NULL, NULL, NULL, 'Test X', NULL, NULL, '2026-05-05 05:57:09', '2026-05-22 16:57:51', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(38, 2, 1, 'MENUNGGU_KETUA', 'wf', '22444', 'BANK_1778154790290_mykampung_v2_db_(1).pdf', 'Test tak tau', 'Disemak oleh JKKK: Dokumen Lengkap.', NULL, '2026-05-07 11:53:10', '2026-05-22 16:57:51', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(39, 5, 1, 'MENUNGGU_KETUA', 'gwgwege', '042414255253533', 'BANK_1779279938693_Backend_Software_Engineer_Intern___Ant_International___LinkedIn.pdf', 'fsa', 'Disemak oleh AJK: Dokumen Lengkap.', NULL, '2026-05-20 12:25:38', '2026-05-22 16:47:05', NULL, 40, 'SEDERHANA', '[\"PENDAPATAN_RENDAH\",\"IBU_BAPA_TUNGGAL\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(40, 2, 1, 'BARU', 'gwgwege', '042414255253533', 'BANK_1779453373653_Flow_of_Participation_â€“_Student_Research_Day_(SRD2026).pdf', 'test 22/5', NULL, NULL, '2026-05-22 12:36:13', '2026-05-22 16:57:51', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]'),
(41, 2, 1, 'BARU', 'gwgwege', '042414255253533', 'BANK_1779454062744_Flow_of_Participation_â€“_Student_Research_Day_(SRD2026).pdf', 'test 22/5', NULL, NULL, '2026-05-22 12:47:42', '2026-05-22 16:57:51', NULL, 75, 'SEDERHANA', '[\"PENDAPATAN_SANGAT_RENDAH\",\"KERJA_SEKTOR_TIDAK_FORMAL\"]');

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
(22, 2, 2, '2026-04-23', '08:00:00', '22:00:00', 'MENUNGGU', 'test112', NULL, '2026-04-23 05:09:42', '2026-04-23 05:09:42', NULL, NULL),
(23, 1, 4, '2026-04-28', '18:00:00', '20:00:00', 'LULUS', '', NULL, '2026-04-28 09:38:42', '2026-04-28 09:38:42', NULL, NULL),
(24, 1, 4, '2026-04-28', '08:00:00', '14:00:00', 'MENUNGGU', 's', NULL, '2026-04-28 14:16:41', '2026-04-28 14:16:41', NULL, NULL),
(25, 2, 4, '2026-04-29', '20:00:00', '22:00:00', 'LULUS', '', NULL, '2026-04-29 11:50:00', '2026-04-29 11:50:00', NULL, NULL),
(26, 2, 2, '2026-05-09', '08:00:00', '10:00:00', 'LULUS', '', NULL, '2026-05-08 19:36:45', '2026-05-08 19:36:45', NULL, NULL);

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
-- Indexes for table `ahli_keluarga`
--
ALTER TABLE `ahli_keluarga`
  ADD PRIMARY KEY (`id_ahli`),
  ADD KEY `id_pengguna` (`id_pengguna`);

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
-- Indexes for table `bantuan_lampiran`
--
ALTER TABLE `bantuan_lampiran`
  ADD PRIMARY KEY (`id_lampiran`),
  ADD KEY `fk_lampiran_permohonan` (`id_permohonan`);

--
-- Indexes for table `bantuan_rule`
--
ALTER TABLE `bantuan_rule`
  ADD PRIMARY KEY (`rule_key`);

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
-- Indexes for table `laporan_snapshot`
--
ALTER TABLE `laporan_snapshot`
  ADD PRIMARY KEY (`id_snapshot`),
  ADD UNIQUE KEY `unique_tahun_bulan` (`tahun`,`bulan`);

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
  MODIFY `id_aduan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `ahli_keluarga`
--
ALTER TABLE `ahli_keluarga`
  MODIFY `id_ahli` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `bantuan`
--
ALTER TABLE `bantuan`
  MODIFY `id_bantuan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1002;

--
-- AUTO_INCREMENT for table `bantuan_lampiran`
--
ALTER TABLE `bantuan_lampiran`
  MODIFY `id_lampiran` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

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
  MODIFY `id_slot` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `hebahan`
--
ALTER TABLE `hebahan`
  MODIFY `id_hebahan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `jawatan_ajk`
--
ALTER TABLE `jawatan_ajk`
  MODIFY `id_jawatan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `kategori_aduan`
--
ALTER TABLE `kategori_aduan`
  MODIFY `id_kategori_aduan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `laporan_snapshot`
--
ALTER TABLE `laporan_snapshot`
  MODIFY `id_snapshot` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `log_aduan`
--
ALTER TABLE `log_aduan`
  MODIFY `id_log_aduan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `log_aktiviti`
--
ALTER TABLE `log_aktiviti`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `pengguna`
--
ALTER TABLE `pengguna`
  MODIFY `id_pengguna` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `peranan`
--
ALTER TABLE `peranan`
  MODIFY `id_peranan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `permohonan_bantuan`
--
ALTER TABLE `permohonan_bantuan`
  MODIFY `id_permohonan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `tempahan_fasiliti`
--
ALTER TABLE `tempahan_fasiliti`
  MODIFY `id_tempahan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

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
-- Constraints for table `ahli_keluarga`
--
ALTER TABLE `ahli_keluarga`
  ADD CONSTRAINT `ahli_keluarga_ibfk_1` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE CASCADE;

--
-- Constraints for table `ajk_jawatan`
--
ALTER TABLE `ajk_jawatan`
  ADD CONSTRAINT `ajk_jawatan_ibfk_1` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE CASCADE,
  ADD CONSTRAINT `ajk_jawatan_ibfk_2` FOREIGN KEY (`id_jawatan`) REFERENCES `jawatan_ajk` (`id_jawatan`) ON DELETE CASCADE;

--
-- Constraints for table `bantuan_lampiran`
--
ALTER TABLE `bantuan_lampiran`
  ADD CONSTRAINT `fk_lampiran_permohonan` FOREIGN KEY (`id_permohonan`) REFERENCES `permohonan_bantuan` (`id_permohonan`) ON DELETE CASCADE;

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
