<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Sahkan OTP & Tukar Kata Laluan</title>
</head>
<body>

    <div class="container" style="margin-top: 50px; text-align: center;">
        
        <%-- Paparkan mesej notifikasi jika ada --%>
        <%
            String status = (String) request.getAttribute("notifikasi");
            if (status != null) {
        %>
            <div style="color: blue; margin-bottom: 20px; padding: 10px; border: 1px solid blue; display: inline-block;">
                <%= status %>
            </div>
        <%
            }
        %>

        <%-- Borang Semakan OTP --%>
        <form action="${pageContext.request.contextPath}/UpdatePasswordServlet" method="POST">
            <h3>Sahkan Kod OTP</h3>
            <p>Sila masukkan kod OTP yang dihantar ke emel anda beserta kata laluan baru.</p>
            
            <%-- Ambil email dari attribute yang di-set dalam ForgotPassServlet / UpdatePasswordServlet --%>
            <%
                String email = (String) request.getAttribute("email");
                if(email == null) email = "";
            %>
            
            <input type="hidden" name="email" value="<%= email %>">
            
            <div style="margin-bottom: 10px;">
                <input type="text" name="otp" required placeholder="Kod OTP 6-Digit" 
                       maxlength="6" style="padding: 10px; width: 250px; text-align: center; letter-spacing: 5px; font-size: 18px;">
            </div>
            
            <div style="margin-bottom: 20px;">
                <input type="password" name="newPassword" required placeholder="Kata Laluan Baru" 
                       style="padding: 10px; width: 250px;">
            </div>
            
            <button type="submit" style="padding: 10px 20px; cursor: pointer; background: #10b981; color: white; border: none; font-weight: bold; border-radius: 5px;">
                Sahkan & Tukar Kata Laluan
            </button>
        </form>

        <br>
        <a href="${pageContext.request.contextPath}/views/auth/auth.jsp" style="text-decoration: none; color: #6C5DD3;">Kembali ke Log Masuk</a>
    </div>

</body>
</html>
