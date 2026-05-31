# 3. Comparison with PITA Development Practices

## 3.1 Member 1: Muhammad Khairul Iman (S71383) – Code Documentation and Inline Comments

In the context of software evolution and maintenance, code comprehension stands as the single most resource-intensive phase, consuming between 58% and 70% of a developer's time during standard maintenance tasks (Oliveira et al., 2025). For a comprehensive Final Year Project (Projek Ilmiah Tahun Akhir - PITA) such as **MyKampung**, which features a web-based MVC architecture (Java Servlets, JSP, MySQL, and multiple external integrations), ensuring high code understandability is critical. This section presents a comparative analysis between the academic frameworks proposed in **Paper 1 (Majumdar et al., 2022)** and **Paper 2 (Oliveira et al., 2025)** and the hands-on engineering practices adopted during the development and maintenance of the MyKampung system.

---

### A. Comparative Analysis: Academic Models vs. MyKampung Practices

The methodologies proposed in the technical papers offer structural frameworks to evaluate and improve code readability. Table 3.1 contrasts these theoretical approaches with the practical methodologies applied in the MyKampung codebase.

##### **Table 3.1: Methodological Comparison of Academic Models and MyKampung PITA Practices**

| Dimension | Paper 1 (Majumdar et al., 2022) | Paper 2 (Oliveira et al., 2025) | MyKampung PITA Practices |
| :--- | :--- | :--- | :--- |
| **Focus Area** | Automated classification of source code comments into *Useful*, *Partially Useful*, and *Not Useful* using neural networks (CommentProbe). | Empirical study of code understandability smells (e.g., Incomplete Documentation, Bad Identifier) during GitHub peer code reviews. | Manual peer-review code conventions, Git pull request workflows, and standard Java/Tomcat documentation practices. |
| **Quality Criteria** | Textual syntax (length, stop-word ratio) and semantic code-comment correlation using Knowledge Graphs (AST nodes). | Actionability and permanence of reviewers' suggestions (83.9% acceptance rate; <1% reversion rate of applied patches). | Enforcing self-documenting method signatures, JavaDoc standards, and semantic inline comments outlining domain-specific rules. |
| **Detection Method** | Machine Learning classifiers (LSTM combined with Artificial Neural Networks). | Static analysis linters (SpotBugs, PMD, SonarQube, Checkstyle) manually matched against human reviews. | Peer review checklists, NetBeans compiler warnings, and manual refactoring sessions during sprint cycles. |
| **Code Scope** | C-language codebases (focused on low-level memory operations, threads, and algorithms). | Java open-source repositories on GitHub (focusing on object-oriented structures, identifiers, and APIs). | Java Servlet (Jakarta EE), JSP, MySQL data layer, and utility services (Google Gemini AI, JavaMail SMTP). |

##### **1. Comment Quality Assessment: Theoretical Classification vs. PITA Reality**
Majumdar et al. (2022) define a comment as **Useful** if it introduces conceptual knowledge domain details (such as application-specific rules or algorithms) that cannot be easily inferred from the surrounding code structures alone. Conversely, **Not Useful** comments are characterized by redundancy (e.g., translating a standard syntax statement directly into natural language) or inconsistency. 

During the initial phase of the MyKampung project, the development team struggled with "comment pollution." Many classes, particularly Data Access Objects (DAOs) like `AduanDAO.java`, contained noisy inline comments that merely repeated Java JDBC or SQL syntax. By applying the quality principles highlighted by Majumdar et al. (2022), the team shifted from syntactic "what the code does" comments to semantic **"why the code does it"** comments, focusing on documenting business rules, system dependencies, and environment workarounds.

##### **2. Code Review and Understandability Smells**
Oliveira et al. (2025) categorized real-world understandability concerns into eight distinct "smells," identifying **Incomplete or Inadequate Code Documentation (22.3%)**, **Bad Identifier (20.3%)**, and **Complex, Long, or Inadequate Logic (18.2%)** as the most prevalent issues. 

In MyKampung, these smells directly manifested in our MVC routing controller layer. Vague parameter bindings between JSP views and Servlets (e.g., in the facility booking flow `TempahanFasilitiDAO.java`) initially caused severe cognitive load during debugging. Establishing strict code conventions—specifically targeted at naming attributes and variables to reflect their exact business logic domain—dramatically improved review cycles, mirroring Oliveira et al.'s findings that developers overwhelmingly adopt naming and documentation enhancements during collaborative code reviews.

---

### B. Impact of Documentation and Review Practices on Maintenance and Evolution

Adopting systematic documentation rules and addressing code understandability smells significantly enhanced the long-term maintainability and evolutionary capacity of the MyKampung system across five key areas:

#### **1. Bug Fixing**
In a multi-role administrative system, bugs in status transitions (e.g., advanced routing of community aid applications or complaints) are common. By documenting state variables inside `StatusConstant.java` with explicit descriptions of their business contexts, tracing failed transitions became trivial. Developers did not need to query the database schema manually to understand role limitations; instead, inline annotations explained the operational logic clearly, minimizing time-to-repair metrics.

#### **2. Feature Enhancement**
When integrating advanced features late in the development cycle—such as the **KampungBot AI Chatbot** using Google Gemini API or the **Bantuan Eligibility Scoring Engine**—a clean and well-documented codebase was essential. The implementation of SSL global bypass logic inside `GeminiUtil.java` was highly complex and prone to breaking. A highly useful, semantic comment was left in the static initializer block explaining *why* a global bypass was necessary (compensating for older local student JDK setups lacking updated Google root certificates). Without this contextual documentation, subsequent developers working on standard network modules might have mistakenly removed this bypass, causing the entire AI chatbot to crash on local Tomcat runs.

#### **3. Code Refactoring**
Refactoring critical systems, such as the encryption layer within the user registration flow (`RegisterServlet.java`) or JDBC connections in `DBUtil.java`, carries high regression risks. Enforcing self-documenting code (using descriptive method names like `calculateEligibilityScore()` instead of generic abbreviations) combined with clear, grammar-checked JavaDocs outlining the mathematical weights utilized by the scoring logic enabled developers to safely optimize backend rule weights without corrupting existing database bindings.

#### **4. Performance Optimization**
Complex nested loops or duplicate queries in database fetching procedures are major bottlenecks in Tomcat JSP containers. In accordance with Oliveira et al.'s "Unnecessary Code" classification, the team conducted code-review sweeps to clean up unused variables, redundant SQL connections, and commented-out code segments. Streamlining data calls in `AnalyticsService.java` by documenting precise SQL aggregated outputs dramatically reduced page load times for the Ketua Kampung's administrative analytics dashboard.

#### **5. System Documentation**
The transition towards structured documentation extended beyond source files into active system configuration. Documenting local path mappings (such as `DATA_DIR` in `AppConfig.java`) and API credentials inside `config.properties` acted as the system's "operational manual." This approach ensured that team members could deploy the application across different host computers seamlessly during staging handovers, preventing localized file-saving directory crashes.

---

### C. Technical Evidence: Code Examples from MyKampung

To demonstrate the real-world application of these software maintenance principles, the following examples illustrate the transformation of "noisy" code into clean, understandable, and highly maintainable components.

#### **Example 1: Redundant vs. Semantically Rich Comments**

In early iterations of our database fetching logic, comments simply repeated syntax actions. During refactoring, these were replaced with high-value domain explanations detailing the business rationale, directly matching the "Useful" criteria defined by Majumdar et al. (2022).

##### **Before: Redundant / Not Useful Comments (Noisy Syntax Duplication)**
```java
// Create SQL query string to select all records from pengguna table
String sql = "SELECT * FROM pengguna WHERE peranan_id = ?";

// Prepare statement with connection
PreparedStatement ps = conn.prepareStatement(sql);

// Set peranan_id integer parameter
ps.setInt(1, roleId);

// Execute query and store in result set
ResultSet rs = ps.executeQuery();
```
*Critique based on Paper 1:* These comments are useless for maintenance. They merely duplicate standard Java and JDBC API details, creating unnecessary clutter and increasing cognitive reading time.

##### **After: Clean, Self-Documenting Code with Useful Semantic Comments**
```java
// Extracting dynamic socioeconomic priority thresholds based on poverty line parameters.
// This is critical because the government's poverty index (KKM) shifts annually, 
// requiring our eligibility engine to dynamically adapt weights without code updates.
String sql = "SELECT weight FROM bantuan_rule WHERE rule_key = 'POVERTY_LINE'";
try (Connection conn = DBUtil.getConnection();
     PreparedStatement ps = conn.prepareStatement(sql);
     ResultSet rs = ps.executeQuery()) {
    if (rs.next()) {
        return rs.getDouble("weight");
    }
}
```
*Critique based on Paper 1:* This comment explains **why** a dynamic DB query is used rather than hardcoding poverty values. It references external domain requirements (government KKM index changes) and explains the downstream dependency (the eligibility engine), making it highly valuable for future maintainers.

---

#### **Example 2: Fixing "Bad Identifier" and "Complex Logic" Smells**

The following code illustrates how we resolved a combination of the "Bad Identifier" and "Complex, Long Logic" smells inside our aid eligibility service, aligning with the remediation patches discussed in Oliveira et al. (2025).

##### **Before: Unclear Identifiers and Obfuscated Logic (Low Understandability)**
```java
// Complex logic checking status for target scoring
double s = 0.0;
String st = pb.getStatus_keluarga();
if (st != null) {
    st = st.trim().toUpperCase();
    if (st.contains("IBU TUNGGAL") || st.contains("BAPA TUNGGAL") || st.contains("OKU")) {
        s = 100.0;
        flags.add("FLAG_1"); // Vague flag identifier
    } else if (st.contains("BERKAHWIN")) {
        s = 60.0;
    } else {
        s = 20.0;
    }
}
```
*Critique based on Paper 2:* Features poor identifiers (`s`, `st`, `FLAG_1`) that fail to communicate purpose. The logical structure is fragile and nested, increasing the risk of bugs during subsequent policy adaptations.

##### **After: High-Quality Identifiers and Structured Logic (High Understandability)**
```java
double familyStatusScore = 0.0;
String rawFamilyStatus = pb.getStatus_keluarga();

if (rawFamilyStatus != null) {
    String familyStatus = rawFamilyStatus.trim().toUpperCase();

    // Prioritize high-vulnerability categories (Single Parents & Disabled (OKU) residents).
    // These groups qualify automatically for the highest eligibility priority tier.
    if (familyStatus.contains("IBU TUNGGAL") || familyStatus.contains("BAPA TUNGGAL")) {
        familyStatusScore = 100.0;
        flags.add("IBU_BAPA_TUNGGAL");
    } else if (familyStatus.contains("OKU")) {
        familyStatusScore = 100.0;
        flags.add("OKU");
    } else if (familyStatus.contains("BERKAHWIN")) {
        familyStatusScore = 60.0;
    } else {
        familyStatusScore = 20.0;
    }
}
```
*Critique based on Paper 2:* Variable names were refactored to express exact semantic intent (`familyStatusScore`, `rawFamilyStatus`). The ambiguous flag was renamed to `IBU_BAPA_TUNGGAL` and `OKU` to match business domain contexts. Precise, structured comments were added to explain logic thresholds, immediately eliminating code smells and facilitating hassle-free software evolution.

---

### **[Screenshot Placeholder Instructions]**
In the final printed report, insert the following screenshots to visually validate these practices:
1. **Figure 3.1:** A screenshot showing a clean, well-commented method within your Java repository—specifically targeting the `EligibilityService.java` where dynamic rule thresholds and detailed inline explanations are implemented.
2. **Figure 3.2:** A screenshot showcasing the `GeminiUtil.java` global SSL bypass method, highlighting the inline comment documenting the JVM/Tomcat environment workaround to assist future project maintainers.
