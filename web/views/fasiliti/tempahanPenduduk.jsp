<%@page import="model.Pengguna"%>
<%
    // Pastikan session menggunakan kunci yang betul iaitu "currentUser"
    Pengguna pDetail = (Pengguna) session.getAttribute("currentUser");

    if (pDetail == null) {
        // Jika session kosong, tendang balik ke page login
        response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
        return;
    }
%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tempahan Fasiliti Kampung - MyKampung</title>
    <link href="${pageContext.request.contextPath}/assets/css/auth.css" rel="stylesheet"> 
</head>
<body>
    <%@include file="../common/header.jsp" %>
    <%@include file="../common/navbar.jsp" %>

    <div class="container" style="margin-top: 30px;">
        <h2>Permohonan Tempahan Fasiliti & Aset</h2>
        
        <c:if test="${not empty mesejSukses}">
            <div style="color: green; padding: 10px; border: 1px solid green; margin-bottom: 15px; border-radius: 5px; background-color: #e6fffa;">
                ${mesejSukses}
            </div>
        </c:if>
        <c:if test="${not empty mesejRalat}">
            <div style="color: red; padding: 10px; border: 1px solid red; margin-bottom: 15px; border-radius: 5px; background-color: #fff5f5;">
                ${mesejRalat}
            </div>
        </c:if>

        <div style="display: flex; gap: 20px; align-items: flex-start;">
            <div style="flex: 1; border: 1px solid #ccc; padding: 20px; border-radius: 8px; background-color: #f9f9f9;">
                <h3>Borang Tempahan Baru</h3>
                <form action="${pageContext.request.contextPath}/TempahanServlet" method="POST">
                    
                    <div style="margin-bottom: 15px;">
                        <label>Pilih Fasiliti / Aset:</label><br>
                        <select name="id_fasiliti" required style="width: 100%; padding: 8px;">
    <option value="">-- Sila Pilih --</option>
    <c:forEach var="fas" items="${senaraiFasiliti}">
        <%-- TUKAR 'Aktif' kepada 'AKTIF' --%>
        <c:if test="${fas.status == 'AKTIF'}">
            <option value="${fas.id_fasiliti}">${fas.nama_fasiliti} (${fas.lokasi})</option>
        </c:if>
    </c:forEach>
</select>
                    </div>

                    <div style="margin-bottom: 15px;">
                        <label>Tarikh & Masa Mula:</label><br>
                        <input type="datetime-local" name="tarikh_mula" required style="width: 100%; padding: 8px; border-radius: 4px; border: 1px solid #ccc;">
                    </div>

                    <div style="margin-bottom: 15px;">
                        <label>Tarikh & Masa Tamat:</label><br>
                        <input type="datetime-local" name="tarikh_tamat" required style="width: 100%; padding: 8px; border-radius: 4px; border: 1px solid #ccc;">
                    </div>

                    <div style="margin-bottom: 15px;">
                        <label>Tujuan Tempahan:</label><br>
                        <textarea name="tujuan" rows="3" required style="width: 100%; padding: 8px; border-radius: 4px; border: 1px solid #ccc;" placeholder="Contoh: Kenduri Kesyukuran..."></textarea>
                    </div>

                    <button type="submit" style="padding: 10px 20px; background-color: #0056b3; color: white; border: none; cursor: pointer; border-radius: 5px; width: 100%;">Hantar Tempahan</button>
                </form>
            </div>

            <div style="flex: 2;">
                <h3>Status Tempahan Anda</h3>
                <table style="width: 100%; border-collapse: collapse; text-align: left; border: 1px solid #ddd;">
                    <thead>
                        <tr style="background-color: #f2f2f2;">
                            <th style="padding: 12px; border-bottom: 2px solid #ddd;">Fasiliti</th>
                            <th style="padding: 12px; border-bottom: 2px solid #ddd;">Tarikh Mula</th>
                            <th style="padding: 12px; border-bottom: 2px solid #ddd;">Tarikh Tamat</th>
                            <th style="padding: 12px; border-bottom: 2px solid #ddd;">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty senaraiTempahan}">
                                <tr>
                                    <td colspan="4" style="text-align: center; padding: 20px; color: #666;">Tiada rekod tempahan dijumpai.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="t" items="${senaraiTempahan}">
                                    <tr style="border-bottom: 1px solid #eee;">
                                        <td style="padding: 12px;">${t.nama_fasiliti}</td>
                                        <td style="padding: 12px;"><fmt:formatDate value="${t.tarikh_mula}" pattern="dd/MM/yyyy h:mm a" /></td>
                                        <td style="padding: 12px;"><fmt:formatDate value="${t.tarikh_tamat}" pattern="dd/MM/yyyy h:mm a" /></td>
                                        <td style="padding: 12px;">
                                            <span style="font-weight: bold; padding: 4px 8px; border-radius: 4px; font-size: 0.9em;
                                                  background-color: ${t.status_tempahan == 'Diluluskan' ? '#d4edda' : (t.status_tempahan == 'Ditolak' ? '#f8d7da' : '#fff3cd')};
                                                  color: ${t.status_tempahan == 'Diluluskan' ? '#155724' : (t.status_tempahan == 'Ditolak' ? '#721c24' : '#856404')};">
                                                ${t.status_tempahan}
                                            </span>
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