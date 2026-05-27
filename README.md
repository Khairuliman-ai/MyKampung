<p align="center">
  <img src="https://img.shields.io/badge/Java-Servlet-007396?style=for-the-badge&logo=java&logoColor=white" alt="Java Servlet"/>
  <img src="https://img.shields.io/badge/JSP-Jakarta-E88024?style=for-the-badge" alt="JSP"/>
  <img src="https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white" alt="MySQL"/>
  <img src="https://img.shields.io/badge/Bootstrap-5.3-7952B3?style=for-the-badge&logo=bootstrap&logoColor=white" alt="Bootstrap"/>
  <img src="https://img.shields.io/badge/TailwindCSS-3.x-06B6D4?style=for-the-badge&logo=tailwindcss&logoColor=white" alt="TailwindCSS"/>
  <img src="https://img.shields.io/badge/Apache_Tomcat-9.x-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black" alt="Tomcat"/>
  <img src="https://img.shields.io/badge/Google_Gemini-AI_Assistant-4285F4?style=for-the-badge&logo=googlegemini&logoColor=white" alt="Gemini AI"/>
  <img src="https://img.shields.io/badge/Chart.js-Analytics-FF6384?style=for-the-badge&logo=chartdotjs&logoColor=white" alt="Chart.js"/>
</p>

# 🏘️ MyKampung – Sistem Pengurusan Kampung Danan

**MyKampung** is a comprehensive village management web application built for **Kampung Danan**. It digitalizes the administrative operations of a traditional Malaysian *kampung* (village), providing a centralized platform for residents, the Village Head (*Ketua Kampung*), and committee members (*AJK Kampung*) to manage complaints, facility bookings, aid applications, announcements, and resident profiles.

> Developed as a semester project for **PITA1 – Semester 5** at **Universiti Malaysia Terengganu (UMT)**.

---

## 📋 Table of Contents

- [Features](#-features)
- [System Roles](#-system-roles)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Database Setup](#-database-setup)
- [Configuration](#%EF%B8%8F-configuration)
- [How to Run](#-how-to-run)
- [Module Breakdown](#-module-breakdown)
- [Screenshots](#-screenshots)
- [Contributors](#-contributors)

---

## ✨ Features

| Module | Description |
|---|---|
| 🔐 **Authentication** | Login, Register (with IC-based DOB extraction), Forgot Password via OTP email, BCrypt password hashing |
| 📊 **Role-Based Dashboard** | Personalized dashboards for Penduduk, Ketua Kampung, Setiausaha, and Biro-specific AJK (Kebajikan, Sukan, Keselamatan, Hebahan) |
| 📢 **Hebahan (Announcements)** | CRUD for announcements with image uploads. Residents view published announcements; admins manage drafts and publishing |
| 📝 **Aduan (Complaints)** | Residents submit complaints with image evidence. Auto-assigned to Biro Keselamatan AJK. Status tracking with audit trail (Log Aduan) |
| 🏟️ **Fasiliti (Facility Booking)** | Browse facilities, book time slots (2-hour / Half-Day / Full-Day), conflict detection, blackout dates, approval workflow |
| 🤝 **Bantuan & Kelayakan** | Apply for Rasmi & Komuniti aid with multi-step wizard. Includes an **advanced rule-based eligibility engine** that auto-assigns scores (0-100), categorization tiers, and socioeconomic risk flags |
| 🤖 **KampungBot AI Chatbot** | Interactive floating AI assistant powered by **Google Gemini** to help residents with village rules, announcements, and navigation |
| 📈 **Laporan & Analitik** | Executive executive statistics dashboard with interactive **Chart.js** data visualization showing trends for complaints, facility bookings, and aid programs |
| 👥 **Pengurusan Penduduk** | Admin views for Ketua Kampung and AJK to manage resident profiles, approve registrations, and assign roles |
| 👨‍👩‍👧‍👦 **Profil & Ahli Keluarga** | Residents update their profile, upload profile photos, manage family member records, and view activity logs |
| 📍 **Google Maps Integration** | Location preview for resident addresses and facility locations |
| 📧 **Email Notifications** | OTP delivery for password reset via JavaMail (SMTP) |

---

## 👤 System Roles

| Role | Malay Name | Access Level |
|---|---|---|
| **Village Head** | Ketua Kampung | Full administrative access — approve registrations, final decision on aid, view all complaints & bookings, view full reporting analytics |
| **Committee Member** | AJK Kampung | Bureau-specific access — manage complaints (Keselamatan), aid (Kebajikan), facilities (Sukan), announcements (Hebahan), or act as Secretary (Setiausaha) |
| **Resident** | Penduduk | Submit complaints, book facilities, apply for aid, view announcements, interact with KampungBot, manage profile & family |

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| **AI Integration** | Google Gemini API (Java HTTP client integration) |
| **Backend** | Java Servlet (Jakarta EE), JSP, Service Layer (Eligibility, Analytics) |
| **Frontend** | JSP, Bootstrap 5.3, TailwindCSS, Chart.js (Analytics graphs), SweetAlert2, Animate.css |
| **Database** | MySQL 8.0 (`mykampung_v2_db`) |
| **Server** | Apache Tomcat 9.x |
| **Build Tool** | Apache Ant (`build.xml`) |
| **IDE** | Apache NetBeans |
| **Security** | BCrypt (jBCrypt) for password hashing, Global SSL bypass for Google API requests |
| **Email** | JavaMail API (SMTP via Gmail, configurable in `config.properties`) |
| **Typography** | Google Fonts (Inter, Outfit) |

---

## 📁 Project Structure

```
MyKampung_V2/
├── src/java/
│   ├── controller/          # 21 Servlets (MVC Controllers)
│   │   ├── LoginServlet.java
│   │   ├── RegisterServlet.java
│   │   ├── DashboardServlet.java
│   │   ├── AduanServlet.java
│   │   ├── BantuanServlet.java
│   │   ├── BantuanConfigServlet.java  # Configure aid eligibility weights
│   │   ├── ChatbotServlet.java        # Handles Gemini AI chatbot calls
│   │   ├── LaporanServlet.java        # Generates analytical snapshots
│   │   └── ... (+ 13 more)
│   ├── dao/                 # 17 Data Access Objects
│   │   ├── PenggunaDAO.java
│   │   ├── AduanDAO.java
│   │   ├── PermohonanBantuanDAO.java
│   │   ├── LaporanSnapshotDAO.java    # Analytical snapshots DB access
│   │   └── ... (+ 13 more)
│   ├── model/               # 19 POJOs (Data Models)
│   │   ├── Pengguna.java
│   │   ├── Aduan.java
│   │   ├── PermohonanBantuan.java
│   │   ├── BantuanRule.java           # Eligibility scoring rules model
│   │   ├── LaporanSnapshot.java       # Reporting snapshots model
│   │   └── ... (+ 14 more)
│   ├── service/             # Business Logic & Services
│   │   ├── EligibilityService.java    # Rule-based socioeconomic priority evaluation
│   │   └── AnalyticsService.java      # Dashboard snapshots & analytics aggregator
│   └── util/                # Utility Classes
│       ├── AppConfig.java       # File path constants
│       ├── DBUtil.java          # JDBC connection manager
│       ├── EmailUtil.java       # SMTP email sender
│       ├── FileUploadUtil.java  # File upload helper
│       ├── GeminiUtil.java      # Google Gemini AI connection & API calls
│       └── StatusConstant.java  # Status & role constants
│
├── web/
│   ├── WEB-INF/
│   │   └── web.xml          # Servlet mappings
│   ├── assets/
│   │   ├── css/             # Custom stylesheets
│   │   └── img/             # Static images
│   └── views/
│       ├── auth/            # Login, Register, Forgot Password, OTP
│       ├── dashboard/       # 7 role-specific dashboard JSPs
│       ├── aduan/           # Complaint views & modals
│       ├── bantuan/         # Aid application views & admin config UI
│       ├── fasiliti/        # Facility booking & management
│       ├── hebahan/         # Announcement views
│       ├── laporan/         # LaporanAnalitik.jsp dashboard
│       ├── maklumatPenduduk/  # Resident management & profile
│       ├── common/          # Shared navbar, header, footer (with global chatWidget.jsp)
│       └── landing/         # Public landing page with components
│
├── db/
│   └── mykampung_v2_db.sql  # Full database dump (schema + seed data)
│
├── build.xml                # Ant build script
└── .gitignore
```

---

## 🗄 Database Setup

1. **Create the database** in MySQL:
   ```sql
   CREATE DATABASE mykampung_v2_db;
   ```

2. **Import the SQL dump** located at:
   ```
   db/mykampung_v2_db.sql
   ```

3. **Import facility slot data** (optional):
   ```
   db/init_fasiliti_slots.sql
   ```

### Key Tables

| Table | Purpose |
|---|---|
| `pengguna` | User accounts & profiles |
| `peranan` | Roles (Ketua Kampung, AJK Kampung, Penduduk) |
| `jawatan` | AJK bureau positions (Keselamatan, Kebajikan, Sukan, Hebahan, Setiausaha) |
| `aduan` | Complaints |
| `log_aduan` | Complaint audit trail |
| `kategori_aduan` | Complaint categories |
| `bantuan` | Aid program types |
| `bantuan_rule` | Stores configurable weight parameters and thresholds for the eligibility scoring engine |
| `permohonan_bantuan` | Aid applications (with eligibility scores, tiers, and flags) |
| `bantuan_lampiran` | Aid document attachments |
| `fasiliti` | Facility records |
| `fasiliti_slot` | Booking time slots |
| `fasiliti_sekatan` | Facility blackout dates |
| `tempahan_fasiliti` | Facility bookings |
| `hebahan` | Announcements |
| `ahli_keluarga` | Family member records |
| `laporan_snapshot` | Stores monthly reporting snapshots of village demographics, complaints, and bookings |
| `activity_log` | System activity logs |

---

## ⚙️ Configuration

### Application Settings File

A single `src/java/config.properties` contains credentials and options for external integrations:

```properties
# Email Configuration (SMTP)
smtp.email=your-email@gmail.com
smtp.password=your-app-specific-password

# Google Gemini AI Configuration
gemini.api.key=YOUR_GEMINI_API_KEY
gemini.model=gemini-2.5-flash-lite
```

### Database Connection

Edit `src/java/util/DBUtil.java` to match your local credentials:

```java
private static final String URL  = "jdbc:mysql://localhost:3306/mykampung_v2_db?useSSL=false";
private static final String USER = "root";
private static final String PASS = "";   // Set your MySQL password
```

### File Upload Directories

Edit `src/java/util/AppConfig.java` and update the `DATA_DIR` to match your local environment:

```java
public static final String DATA_DIR = "C:\\path\\to\\your\\MyKampungData";
```

The system will automatically create subdirectories for all document and image uploads.

---

## 🚀 How to Run

### Prerequisites

- **JDK** 8 or higher (contains a global SSL bypass utility to prevent JVM handshake errors on older JDKs during Google API calls)
- **Apache Tomcat** 9.x
- **MySQL** 8.0
- **Apache NetBeans** (recommended IDE)
- **MySQL Connector/J** (JDBC driver)
- **jBCrypt** library

### Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Khairuliman-ai/MyKampung.git
   cd MyKampung
   ```

2. **Import the database** (see [Database Setup](#-database-setup))

3. **Update configuration files:**
   - `src/java/config.properties` — Gmail SMTP and Gemini API key details
   - `DBUtil.java` — database credentials
   - `AppConfig.java` — file storage path

4. **Open in NetBeans:**
   - Open as an existing project
   - Resolve library dependencies (add JARs to project libraries)

5. **Deploy to Tomcat** and run:
   ```
   http://localhost:8080/MyKampung_V2/
   ```

---

## 📦 Module Breakdown

### 🔐 Authentication (`/views/auth/`)
- **Login** — IC number + password, BCrypt verification
- **Register** — Multi-field form with IC upload, auto DOB extraction, pending approval by Ketua Kampung
- **Forgot Password** — Email OTP verification → password reset

### 📊 Dashboard (`/views/dashboard/`)
- **Penduduk** — Personal stats (complaints, bookings, aid), latest announcements, AJK contact list
- **Ketua Kampung** — Administrative overview, direct link to high-end reporting analytics
- **AJK (5 bureaus)** — Bureau-specific dashboards (Setiausaha, Kebajikan, Sukan, Keselamatan, Hebahan)

### 📝 Aduan (`/aduan/*`)
- Submit complaints with category, priority, description & image
- Auto-assignment to Biro Keselamatan AJK
- Status flow: `BARU` → `DALAM_SIASATAN` → `RESOLVED` / `REJECTED`
- Full audit trail with log timeline modal

### 🤝 Bantuan & Kelayakan (`/bantuan/*`)
- **Rasmi** — Official government aid programs
- **Komuniti** — Community-based aid (custom "Lain-lain" option)
- **Eligibility Engine (`EligibilityService.java`)** — Automatically evaluates socioeconomic priority scores out of 100 based on income vs. poverty line, family size, disability or single-parent status, and employment type
- **Visual Insights** — Progress bars and risk flags highlight vulnerable applicants during AJK review
- **Weight Control Admin (`urusBantuanConfig.jsp`)** — Allows AJK/Ketua Kampung to customize rule weights and adjust the poverty threshold line dynamically

### 🤖 KampungBot AI Chatbot (`/views/common/chatWidget.jsp`)
- **Interactive Helper** — Embedded globally in the footer as a beautiful glassmorphism floating chat widget
- **Tomcat-Safe SSL Connection** — Features an automated internal trust manager to prevent JVM network handshake failures
- **Contextual Assistance** — Leverages Google Gemini to answer questions regarding local procedures, open hours, announcements, and general help

### 📈 Laporan & Analitik (`/views/laporan/laporanAnalitik.jsp`)
- **Interactive Visual Graphs** — Powered by Chart.js, rendering trends for monthly resident registrations, aid requests vs. approvals, and solved complaints
- **Demographics Overview** — Calculates average household income and distribution of single parents or OKU residents in the village
- **Administrative Control** — Provides Ketua Kampung with actionable metrics to monitor bureau workloads and aid distribution velocity

### 👥 Pengurusan Penduduk (`/views/maklumatPenduduk/`)
- Profile update with family member management
- Resident directory for admins (Ketua & AJK)
- Registration approval workflow

---

## 📸 Screenshots

> *Screenshots coming soon — deploy the application to see the modern glassmorphism UI in action!*

---

## 👥 Contributors

| Name | Role |
|---|---|
| **Khairul Iman** | Full-Stack Developer |

---

## 📄 License

This project is developed for academic purposes as part of the PITA1 coursework at **Universiti Malaysia Terengganu (UMT)**. All rights reserved.

---

<p align="center">
  <i>Built with ❤️ for Kampung Danan</i>
</p>
