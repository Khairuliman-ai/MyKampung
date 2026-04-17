<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Urus Fasiliti - MyKampung</title>
    <link href="${pageContext.request.contextPath}/assets/css/auth.css" rel="stylesheet"> 
</head>
<body>
    <%@include file="../common/header.jsp" %>
    <%@include file="../common/navbar.jsp" %>

    <div class="container" style="margin-top: 30px;">
        <h2>Pengurusan Inventori Fasiliti & Aset</h2>
        
        <c:if test="${not empty mesejSukses}">
            <div style="color: green; padding: 10px; border: 1px solid green; margin-bottom: 15px;">
                ${mesejSukses}
            </div>
        </c:if>
        <c:if test="${not empty mesejRalat}">
            <div style="color: red; padding: 10px; border: 1px solid red; margin-bottom: 15px;">
                ${mesejRalat}
            </div>
        </c:if>

        <div style="display: flex; gap: 20px;">
            <div style="flex: 1; border: 1px solid #ccc; padding: 20px; border-radius: 8px;">
                <h3>Daftar Fasiliti Baru</h3>
                <form action="${pageContext.request.contextPath}/UrusFasilitiServlet" method="POST">
                    
                    <div style="margin-bottom: 15px;">
                        <label>Nama Fasiliti / Aset:</label><br>
                        <input type="text" name="nama_fasiliti" required style="width: 100%; padding: 8px;" placeholder="Cth: Dewan Seri Kenangan">
                    </div>

                    <div style="margin-bottom: 15px;">
                        <label>Kategori:</label><br>
                        <select name="kategori" required style="width: 100%; padding: 8px;">
                            <option value="">-- Sila Pilih --</option>
                            <option value="Dewan">Dewan / Bangunan</option>
                            <option value="Sukan">Padang / Sukan</option>
                            <option value="Peralatan">Peralatan (Khemah/PA System)</option>
                        </select>
                    </div>

                    <div style="margin-bottom: 15px;">
                        <label>Kapasiti (Biarkan kosong jika tiada):</label><br>
                        <input type="number" name="kapasiti" style="width: 100%; padding: 8px;" placeholder="Cth: 500">
                    </div>

                    <div style="margin-bottom: 15px;">
                        <label>Status Ketersediaan:</label><br>
                        <select name="ketersediaan" required style="width: 100%; padding: 8px;">
                            <option value="true">Tersedia / Boleh Ditempah</option>
                            <option value="false">Sedang Diselenggara / Rosak</option>
                        </select>
                    </div>

                    <button type="submit" style="padding: 10px 20px; background-color: #28a745; color: white; border: none; cursor: pointer; border-radius: 5px;">
                        Simpan Rekod
                    </button>
                </form>
            </div>

            <div style="flex: 2;">
                <h3>Senarai Inventori Semasa</h3>
                <table border="1" style="width: 100%; border-collapse: collapse; text-align: left;">
                    <thead>
                        <tr style="background-color: #f2f2f2;">
                            <th style="padding: 8px;">ID</th>
                            <th style="padding: 8px;">Nama Fasiliti</th>
                            <th style="padding: 8px;">Kategori</th>
                            <th style="padding: 8px;">Kapasiti</th>
                            <th style="padding: 8px;">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty senaraiFasiliti}">
                                <tr>
                                    <td colspan="5" style="text-align: center; padding: 15px;">Tiada rekod fasiliti dijumpai.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="f" items="${senaraiFasiliti}">
                                    <tr>
                                        <td style="padding: 8px;">FAS-${f.id_fasiliti}</td>
                                        <td style="padding: 8px;">${f.nama_fasiliti}</td>
                                        <td style="padding: 8px;">${f.kategori}</td>
                                        <td style="padding: 8px;">${f.kapasiti != null ? f.kapasiti : 'N/A'}</td>
                                        <td style="padding: 8px;">
                                            <c:choose>
                                                <c:when test="${f.ketersediaan}">
                                                    <span style="color: green; font-weight: bold;">Tersedia</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: red;">Diselenggara</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <%@include file="../common/footer.jsp" %>
</body>
</html>