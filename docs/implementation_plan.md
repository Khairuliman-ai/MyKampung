# KampungBot Full Context Injection — Implementation Plan

Enhance the chatbot's `buildSystemPrompt()` in [ChatbotServlet.java](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/src/java/controller/ChatbotServlet.java) to inject live database context for **all modules** and **all user roles**, with strict CIA (Confidentiality, Integrity, Availability) access controls.

## System Roles & Biro Reference

| Role | nama_peranan | Jawatan (Biro) |
|------|-------------|----------------|
| Ketua Kampung | `Ketua Kampung` | Pengerusi |
| AJK Setiausaha | `AJK Kampung` | Setiausaha |
| AJK Biro Keselamatan | `AJK Kampung` | Biro Keselamatan |
| AJK Biro Sukan & Riadah | `AJK Kampung` | Biro Sukan & Riadah |
| AJK Biro Kebajikan & Sosial | `AJK Kampung` | Biro Kebajikan & Sosial |
| AJK Biro Hebahan | `AJK Kampung` | Biro Hebahan |
| Penduduk | `Penduduk` | — |

---

## Proposed Changes

### [MODIFY] [ChatbotServlet.java](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/src/java/controller/ChatbotServlet.java)

All changes happen inside `buildSystemPrompt(Pengguna user)`. We will add **6 new context injection blocks**, each gated by role checks.

---

### Block 1: Personal Data Context (All Users — `Penduduk`, `AJK`, `Ketua`)

> [!NOTE]
> **CIA:** Confidentiality ✅ — Users only see their own data. No cross-user leakage.

**What it injects:** The user's own aduan history, their own bantuan application history, and their own tempahan (booking) history.

**Data Sources:**
- `AduanDAO.getByPenduduk(userId)` → user's own complaints
- `PermohonanBantuanDAO.getByPenduduk(userId)` → user's own aid applications
- `TempahanFasilitiDAO.dapatkanSejarahTempahanPenduduk(userId)` → user's own bookings

**Example prompts the user can ask:**
- *"Berapa banyak aduan saya yang belum selesai?"*
- *"Apa status permohonan bantuan saya?"*
- *"Bilakah tempahan saya yang seterusnya?"*

---

### Block 2: Aduan Module Admin Context (Biro Keselamatan + Ketua Kampung)

> [!NOTE]
> **CIA:** Confidentiality ✅ — Only the AJK responsible for complaints and the Ketua Kampung can see all complaints. Other AJK and Penduduk cannot.

**Access:** `Ketua Kampung` OR `AJK Kampung` with jawatan `Biro Keselamatan`

**What it injects:**
- Summary stats: `AduanDAO.getAduanSummaryStats()` (counts by status)
- List of active/pending complaints: `AduanDAO.getAll()` filtered to non-CLOSED items (tajuk, nama pengadu, status, keutamaan)

**Example prompts:**
- *"Berapa banyak aduan yang belum diselesaikan?"*
- *"Senaraikan aduan berkeutamaan tinggi"*
- *"Siapa yang menghantar aduan tentang jalan berlubang?"*

---

### Block 3: Bantuan Module Admin Context (Biro Kebajikan & Sosial + Setiausaha + Ketua Kampung)

> [!NOTE]
> **CIA:** Confidentiality ✅ — Financial data restricted to welfare biro, Setiausaha, and Ketua only. Other AJK and Penduduk cannot see other people's applications.

**Access:** `Ketua Kampung` OR `AJK Kampung` with jawatan `Setiausaha` OR `Biro Kebajikan & Sosial`

**What it injects:**
- Summary stats: `PermohonanBantuanDAO.getBantuanSummaryStats()` (counts by status)
- Full applicant list: `PermohonanBantuanDAO.getAll()` (nama, KP, bantuan type, status)
- *(This replaces the existing block we already implemented)*

**Example prompts:**
- *"Senarai penduduk yang memohon bantuan kewangan"*
- *"Berapa permohonan bantuan yang menunggu kelulusan?"*
- *"Ada permohonan bantuan baru yang perlu disemak?"*

---

### Block 4: Fasiliti & Tempahan Admin Context (Biro Sukan & Riadah + Ketua Kampung)

> [!NOTE]
> **CIA:** Confidentiality ✅ — Booking management data restricted to sports biro and Ketua. Penduduk only see their own bookings (Block 1).

**Access:** `Ketua Kampung` OR `AJK Kampung` with jawatan `Biro Sukan & Riadah`

**What it injects:**
- Facility list & status: `FasilitiDAO.dapatkanSemuaFasiliti()` (name, status, location)
- Pending bookings count: `TempahanFasilitiDAO.countByStatus("MENUNGGU")`
- Usage stats: `TempahanFasilitiDAO.getFasilitiUsageStats()`

**Example prompts:**
- *"Fasiliti mana yang paling kerap ditempah?"*
- *"Ada berapa tempahan yang menunggu kelulusan?"*
- *"Apakah status Gelanggang Futsal?"*

---

### Block 5: Hebahan Context (Biro Hebahan + Ketua Kampung)

> [!NOTE]
> **CIA:** Confidentiality ✅ — Published hebahan is public, but draft/archived stats are admin-only. Penduduk can only ask about published announcements.

**Access for Admin Stats:** `Ketua Kampung` OR `AJK Kampung` with jawatan `Biro Hebahan`

**What it injects (Admin):**
- Draft count: `HebahanDAO.countByStatus("Draft")`
- Published count: `HebahanDAO.countByStatus("Published")`
- Recent published titles: top 5 from `HebahanDAO.getPublished("DESC")`

**What it injects (All Users):**
- Latest 3 published announcements titles and dates (already semi-public info)

**Example prompts:**
- Admin: *"Berapa hebahan yang belum diterbitkan?"*
- Penduduk: *"Apa hebahan terbaru kampung?"*

---

### Block 6: Dashboard & Population Stats (Ketua Kampung + Setiausaha only)

> [!NOTE]
> **CIA:** Confidentiality ✅ — Aggregate demographics (income distribution, age distribution) are sensitive socioeconomic data. Restricted to top management only.

**Access:** `Ketua Kampung` OR `AJK Kampung` with jawatan `Setiausaha`

**What it injects:**
- Total residents: `PenggunaDAO.countAll()`
- Average income: `PenggunaDAO.getAverageIncome()`
- Pending registrations count: `PenggunaDAO.getPendingPenduduk().size()`
- Aduan stats summary: `AduanDAO.getAduanSummaryStats()`
- Bantuan stats summary: `PermohonanBantuanDAO.getBantuanSummaryStats()`

**Example prompts:**
- *"Berapa jumlah penduduk kampung?"*
- *"Apakah purata pendapatan penduduk?"*
- *"Ada berapa pendaftaran baru yang menunggu kelulusan?"*

---

## CIA Access Control Matrix

| Context Block | Penduduk | Biro Keselamatan | Biro Sukan | Biro Kebajikan | Biro Hebahan | Setiausaha | Ketua Kampung |
|---|---|---|---|---|---|---|---|
| 1. Own Data | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 2. Aduan Admin | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ |
| 3. Bantuan Admin | ❌ | ❌ | ❌ | ✅ | ❌ | ✅ | ✅ |
| 4. Fasiliti Admin | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ✅ |
| 5. Hebahan Admin | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ✅ |
| 5. Hebahan Public | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 6. Dashboard Stats | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ |

---

## Open Questions

> [!IMPORTANT]
> **Data Volume Limit:** The Gemini API has token limits. If there are hundreds of aduan/bantuan records, injecting all of them will exceed the context window. Should we limit each list to the **most recent 20 records** to keep the prompt efficient, or do you want a higher/lower limit?

> [!IMPORTANT]
> **Setiausaha Scope:** You confirmed Setiausaha can see bantuan data. Should Setiausaha also see the aduan admin context (Block 2), or is that strictly for Biro Keselamatan + Ketua only?

---

## Implementation Approach

All changes are in a **single file**: [ChatbotServlet.java](file:///c:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampung_V2/src/java/controller/ChatbotServlet.java) — specifically inside the `buildSystemPrompt()` method.

We refactor the method to call 6 private helper methods:
1. `appendPersonalContext(sb, user)` — Block 1
2. `appendAduanAdminContext(sb, user)` — Block 2
3. `appendBantuanAdminContext(sb, user)` — Block 3 (replaces existing code)
4. `appendFasilitiAdminContext(sb, user)` — Block 4
5. `appendHebahanContext(sb, user)` — Block 5
6. `appendDashboardContext(sb, user)` — Block 6

Each helper method internally checks role/jawatan before appending anything, ensuring **defense-in-depth** at the method level.

No new DAOs or database tables are needed — we reuse existing DAO methods throughout.

## Verification Plan

### Manual Verification
1. Log in as **Penduduk** → ask *"status aduan saya"* → should see own data only
2. Log in as **Ketua Kampung** → ask *"senarai pemohon bantuan"* → should see full list
3. Log in as **AJK Biro Keselamatan** → ask *"senarai aduan terkini"* → should see aduan list; ask *"senarai pemohon bantuan"* → should NOT see bantuan data
4. Log in as **AJK Biro Sukan** → ask *"tempahan menunggu kelulusan"* → should see booking data
5. Verify no cross-role data leakage occurs
