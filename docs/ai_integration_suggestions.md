# 🤖 Cadangan Integrasi AI Merentas Sistem MyKampung V2

## Sistem Sedia Ada

Berdasarkan semakan penuh kod sumber, sistem MyKampung V2 mempunyai **6 modul utama** dan sudah mempunyai infrastruktur AI yang kukuh:

| Komponen | Fail Utama | Status AI |
|---|---|---|
| Chatbot (KampungBot) | [ChatbotServlet.java](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/src/java/controller/ChatbotServlet.java), [GeminiUtil.java](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/src/java/util/GeminiUtil.java) | ✅ Sudah ada |
| Aduan & Cadangan | [AduanServlet.java](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/src/java/controller/AduanServlet.java) | ❌ Tiada AI |
| Permohonan Bantuan | [BantuanServlet.java](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/src/java/controller/BantuanServlet.java) | ❌ Tiada AI |
| Tempahan Fasiliti | [FasilitiServlet.java](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/src/java/controller/FasilitiServlet.java) | ❌ Tiada AI |
| Info & Hebahan | [HebahanServlet.java](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/src/java/controller/HebahanServlet.java) | ❌ Tiada AI |
| Pengurusan Penduduk | [UrusPendudukServlet.java](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/src/java/controller/UrusPendudukServlet.java) | ❌ Tiada AI |
| Dashboard | [DashboardServlet.java](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/src/java/controller/DashboardServlet.java) | ❌ Tiada AI |

---

## 📋 Cadangan AI Mengikut Modul

### 1. 📢 Modul Aduan & Cadangan — *AI-Powered Complaint Triage*

#### 1A. Auto-Kategorisasi & Keutamaan Aduan ⭐ (Disyorkan)
**Apa:** Apabila penduduk menaip tajuk dan keterangan aduan, AI secara automatik mencadangkan **kategori** dan **tahap keutamaan** (Rendah/Sederhana/Tinggi/Kritikal).

**Contoh:** Penduduk taip *"Lubang jalan besar depan masjid, kereta sudah rosak"* → AI cadangkan Kategori: **Infrastruktur**, Keutamaan: **TINGGI**

**Fail terlibat:**
- [AduanServlet.java](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/src/java/controller/AduanServlet.java) — Tambah endpoint `/ai/categorize`
- [aduanPenduduk.jsp](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/web/views/aduan/aduanPenduduk.jsp) — Tambah butang "Cadangan AI" pada borang
- [GeminiUtil.java](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/src/java/util/GeminiUtil.java) — Guna semula `chat()` method sedia ada

**Tahap Kesukaran:** 🟢 Mudah

---

#### 1B. AI Ringkasan Aduan untuk AJK
**Apa:** Apabila AJK/Ketua membuka senarai aduan, AI jana ringkasan pantas semua aduan aktif — contoh: *"5 aduan baru minggu ini, 3 berkaitan jalan raya, 2 kritikal belum ditangani."*

**Fail terlibat:**
- [urusAduanAJK.jsp](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/web/views/aduan/urusAduanAJK.jsp) — Papar ringkasan AI di bahagian atas
- [AduanServlet.java](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/src/java/controller/AduanServlet.java) — Endpoint `/ai/summary`

**Tahap Kesukaran:** 🟡 Sederhana

---

#### 1C. Pengesanan Aduan Duplikasi
**Apa:** Sebelum penduduk hantar aduan baru, AI semak aduan sedia ada dan maklumkan jika isu serupa sudah dilaporkan. Elak aduan berulang.

**Contoh:** *"Aduan serupa telah dihantar oleh penduduk lain pada 15 Mei — 'Lampu jalan depan surau padam'. Adakah anda mahu teruskan?"*

**Tahap Kesukaran:** 🟡 Sederhana

---

### 2. 💰 Modul Permohonan Bantuan — *AI Eligibility Checker*

#### 2A. Semakan Kelayakan Bantuan secara AI ⭐ (Disyorkan)
**Apa:** Sebelum penduduk isi borang permohonan bantuan, AI tanya beberapa soalan ringkas dan cadangkan bantuan yang paling sesuai berdasarkan profil mereka.

**Contoh:** Penduduk klik "Mohon Bantuan" → AI tanya: *"Berapakah pendapatan isi rumah? Ada tanggungan OKU? Sila nyatakan keperluan utama."* → AI cadangkan: **Bantuan Sara Hidup (BSH)** dan **Bantuan OKU**

**Fail terlibat:**
- [BantuanServlet.java](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/src/java/controller/BantuanServlet.java) — Endpoint `/ai/checkEligibility`
- [jenisBantuan.jsp](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/web/views/bantuan/jenisBantuan.jsp) — Tambah seksyen "Semak Kelayakan AI"
- [BantuanDAO.java](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/src/java/dao/BantuanDAO.java) — Ambil senarai bantuan & syarat

**Tahap Kesukaran:** 🟡 Sederhana

---

#### 2B. AI Semakan Kesempurnaan Dokumen
**Apa:** Selepas penduduk muat naik dokumen sokongan (PDF), AI semak dan maklumkan jika dokumen tidak lengkap — *"Penyata bank tidak dikesan. Sila muat naik salinan penyata bank terkini."*

> [!NOTE]
> Ini memerlukan Gemini Vision API atau parsing PDF, yang mungkin lebih kompleks.

**Tahap Kesukaran:** 🔴 Kompleks

---

#### 2C. AI Auto-Draft Ulasan AJK
**Apa:** Apabila AJK menyemak permohonan, AI sediakan draf ulasan berdasarkan maklumat pemohon — *"Pemohon: Ahmad, T40, ada 3 anak sekolah, pendapatan RM2,500. Cadangan: LAYAK untuk Bantuan Sara Hidup."*

**Fail terlibat:**
- [urusBantuanAJK.jsp](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/web/views/bantuan/urusBantuanAJK.jsp) — Butang "Jana Draf Ulasan AI"

**Tahap Kesukaran:** 🟢 Mudah

---

### 3. 🏟️ Modul Tempahan Fasiliti — *Smart Booking Assistant*

#### 3A. Cadangan Slot Masa Pintar ⭐ (Disyorkan)
**Apa:** Berdasarkan sejarah tempahan, AI cadangkan slot masa yang paling sesuai — *"Padang Bola biasanya kurang sibuk pada Selasa pagi. Slot 8:00-10:00 AM tersedia."*

**Fail terlibat:**
- [FasilitiServlet.java](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/src/java/controller/FasilitiServlet.java) — Endpoint `/ai/suggestSlot`
- [tempahanPenduduk.jsp](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/web/views/fasiliti/tempahanPenduduk.jsp) — Papar cadangan AI

**Tahap Kesukaran:** 🟡 Sederhana

---

#### 3B. AI Pengesanan Konflik & Cadangan Alternatif
**Apa:** Apabila slot sudah penuh, bukan sekadar papar "Slot tidak tersedia", tetapi AI cadangkan alternatif — *"Dewan Kampung penuh pada Sabtu ini. Cadangan: Gunakan Gelanggang Futsal (tersedia 2pm-4pm) atau cuba Ahad depan."*

**Tahap Kesukaran:** 🟢 Mudah

---

### 4. 📰 Modul Info & Hebahan — *AI Content Generator*

#### 4A. AI Auto-Generate Draf Hebahan ⭐ (Disyorkan)
**Apa:** AJK Biro Hebahan masukkan maklumat ringkas (contoh: tarikh, aktiviti, lokasi), dan AI janakan draf hebahan penuh dengan bahasa formal dan menarik.

**Contoh:** AJK taip: *"Gotong-royong, 25 Mei, 8 pagi, Padang Bola"* → AI jana:

> *"Jemputan Gotong-Royong Perdana Kampung Danan! 🌿 Marilah kita bersama-sama membersihkan kawasan kampung tercinta. Tarikh: 25 Mei 2026, Masa: 8:00 pagi, Tempat: Padang Bola Kampung Danan. Semua penduduk dialu-alukan!"*

**Fail terlibat:**
- [HebahanServlet.java](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/src/java/controller/HebahanServlet.java) — Endpoint `/ai/generateDraft`
- [urusHebahanAJK.jsp](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/web/views/hebahan/urusHebahanAJK.jsp) — Butang "Jana Hebahan AI ✨"

**Tahap Kesukaran:** 🟢 Mudah

---

#### 4B. Ringkasan Hebahan untuk Penduduk
**Apa:** Hebahan yang panjang secara automatik dijana ringkasan 2-3 ayat oleh AI supaya penduduk boleh imbas pantas.

**Fail terlibat:**
- [hebahanPenduduk.jsp](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/web/views/hebahan/hebahanPenduduk.jsp) — Papar "Ringkasan AI" di kad hebahan

**Tahap Kesukaran:** 🟢 Mudah

---

### 5. 📊 Modul Dashboard — *AI Insights & Analytics*

#### 5A. Dashboard Insight Pintar untuk Ketua Kampung ⭐ (Disyorkan)
**Apa:** Di [ketuaDashboard.jsp](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/web/views/dashboard/ketuaDashboard.jsp), AI janakan ringkasan eksekutif mingguan:

> *"Minggu ini: 12 aduan baru (↑40% vs minggu lepas), 3 permohonan bantuan menunggu kelulusan anda, Dewan Kampung 85% penuh pada hujung minggu. Isu utama: Lampu jalan di Lorong 3 sudah 2 minggu belum diselesaikan."*

**Fail terlibat:**
- [DashboardServlet.java](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/src/java/controller/DashboardServlet.java) — Kumpul data statistik dan hantar ke AI
- Semua dashboard JSP

**Tahap Kesukaran:** 🟡 Sederhana

---

#### 5B. AI Greeting Peribadi di Dashboard Penduduk
**Apa:** Bukan sekadar "Selamat Datang, Ahmad", tetapi AI beri greeting kontekstual: *"Selamat petang, Ahmad! Aduan anda tentang longkang tersumbat sudah dikemas kini — AJK sedang menanganinya. Juga, ada gotong-royong esok di Padang Bola."*

**Fail terlibat:**
- [pendudukDashboard.jsp](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/web/views/dashboard/pendudukDashboard.jsp)
- [DashboardServlet.java](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/src/java/controller/DashboardServlet.java)

**Tahap Kesukaran:** 🟡 Sederhana

---

### 6. 👥 Modul Pengurusan Penduduk — *Smart Admin Tools*

#### 6A. AI Carian Pintar Penduduk
**Apa:** AJK/Ketua boleh cari penduduk menggunakan bahasa semula jadi: *"Senaraikan semua penduduk berumur 60 tahun ke atas yang belum mohon bantuan"* — AI terjemahkan ke query yang sesuai.

**Fail terlibat:**
- [UrusPendudukServlet.java](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/src/java/controller/UrusPendudukServlet.java)
- [urusPendudukKetua.jsp](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/web/views/maklumatPenduduk/urusPendudukKetua.jsp)

**Tahap Kesukaran:** 🔴 Kompleks

---

### 7. 🔐 Modul Auth & Profil

#### 7A. AI Bantuan Pengisian Borang Pendaftaran
**Apa:** Chatbot khas di halaman pendaftaran ([auth.jsp](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/web/views/auth/auth.jsp)) yang membantu warga emas atau pengguna kurang celik IT untuk mendaftar — membimbing langkah demi langkah.

**Tahap Kesukaran:** 🟡 Sederhana

---

## 🎯 Matriks Keutamaan

| # | Ciri AI | Impak | Kesukaran | **Cadangan Utama** |
|---|---------|-------|-----------|:---:|
| 4A | Auto-Generate Draf Hebahan | ⭐⭐⭐ | 🟢 Mudah | ✅ |
| 1A | Auto-Kategorisasi Aduan | ⭐⭐⭐ | 🟢 Mudah | ✅ |
| 2C | Auto-Draft Ulasan AJK (Bantuan) | ⭐⭐⭐ | 🟢 Mudah | ✅ |
| 3B | Cadangan Alternatif Konflik | ⭐⭐ | 🟢 Mudah | ✅ |
| 4B | Ringkasan Hebahan | ⭐⭐ | 🟢 Mudah | ✅ |
| 5A | Dashboard Insight Ketua | ⭐⭐⭐⭐ | 🟡 Sederhana | ✅ |
| 2A | Semakan Kelayakan Bantuan | ⭐⭐⭐ | 🟡 Sederhana | |
| 5B | AI Greeting Peribadi | ⭐⭐ | 🟡 Sederhana | |
| 1B | Ringkasan Aduan untuk AJK | ⭐⭐ | 🟡 Sederhana | |
| 3A | Cadangan Slot Pintar | ⭐⭐ | 🟡 Sederhana | |
| 1C | Pengesanan Duplikasi Aduan | ⭐⭐ | 🟡 Sederhana | |
| 7A | AI Bantuan Pendaftaran | ⭐ | 🟡 Sederhana | |
| 6A | AI Carian Pintar Penduduk | ⭐⭐⭐ | 🔴 Kompleks | |
| 2B | AI Semakan Dokumen PDF | ⭐⭐⭐ | 🔴 Kompleks | |

---

## 🏗️ Pelan Pelaksanaan Dicadangkan

### Fasa 1 — Quick Wins (1-2 minggu)
Guna `GeminiUtil.chat()` sedia ada, hanya perlu tambah endpoint baru dan butang di JSP:
1. **4A** — AI Auto-Generate Draf Hebahan
2. **1A** — Auto-Kategorisasi Aduan
3. **2C** — Auto-Draft Ulasan AJK
4. **4B** — Ringkasan Hebahan
5. **3B** — Cadangan Alternatif Slot

### Fasa 2 — Core Enhancements (2-3 minggu)
Perlu kumpul data dari pelbagai DAO dan bina prompt yang lebih kompleks:
1. **5A** — Dashboard Insight Ketua Kampung
2. **2A** — Semakan Kelayakan Bantuan AI
3. **5B** — AI Greeting Peribadi Dashboard

### Fasa 3 — Advanced (pilihan)
1. **1C** — Pengesanan Duplikasi Aduan
2. **6A** — AI Carian Natural Language
3. **2B** — AI Semakan Dokumen PDF

---

## 🔧 Pendekatan Teknikal

> [!IMPORTANT]
> Semua ciri AI di atas boleh dibina menggunakan **infrastruktur sedia ada** — iaitu [GeminiUtil.java](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/src/java/util/GeminiUtil.java) dan Gemini API. Tidak perlu tambah library baru.

**Corak Pelaksanaan (Pattern):**
```
JSP (Butang "AI ✨") → AJAX fetch() → Servlet (endpoint /ai/xxx) → GeminiUtil.chat() → JSON response → JSP papar hasil
```

Setiap ciri AI hanya memerlukan:
1. **Satu endpoint baru** dalam Servlet sedia ada (contoh: `/aduan/ai/categorize`)
2. **Satu system prompt** yang disesuaikan untuk tugas spesifik
3. **Satu butang/seksyen** di JSP untuk trigger dan papar hasil

---

## ❓ Soalan untuk Anda

1. Antara ciri-ciri di atas, **yang mana anda paling berminat** untuk dimulakan dahulu?
2. Adakah anda mahu saya **terus implement** mana-mana ciri dari Fasa 1 (Quick Wins)?
3. Adakah terdapat **modul lain** atau ciri tambahan yang anda fikirkan?
