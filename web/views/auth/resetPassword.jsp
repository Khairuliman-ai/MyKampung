<%-- 
    Document   : resetPassword
    Created on : 15 Apr 2026, 4:48:26 pm
    Author     : khayx
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
    String token = request.getParameter("token");
    // Di sini awak kena panggil logic database untuk:
    // 1. Cari user yang ada reset_token == token
    // 2. Semak adakah token_expiry > CURRENT_TIMESTAMP
    
    if (token == null || token.isEmpty()) {
        out.println("Token tidak sah!");
    } else {
        // Paparkan borang tukar password
%>
        <form action="UpdatePasswordServlet" method="POST">
            <input type="hidden" name="_csrf" value="${sessionScope.csrf_token}"/>
            <input type="hidden" name="token" value="<%= token %>">
            <label>Kata Laluan Baru:</label>
            <input type="password" name="newPassword" required>
            <button type="submit">Simpan Kata Laluan</button>
        </form>
<%
    }
%>
    </body>
</html>
