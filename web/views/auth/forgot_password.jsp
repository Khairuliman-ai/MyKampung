<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Lupa Kata Laluan</title>
</head>
<body>

    <div class="container" style="margin-top: 50px; text-align: center;">
        
        <%-- 1. Paparkan mesej notifikasi jika ada --%>
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

        <%-- 2. Borang Utama --%>
      <form action="${pageContext.request.contextPath}/ForgotPassServlet" method="POST">
          <input type="hidden" name="_csrf" value="${sessionScope.csrf_token}"/>
            <h3>Set Semula Kata Laluan</h3>
            <p>Masukkan emel akaun anda untuk menerima pautan set semula.</p>
            
            <input type="email" name="email" required placeholder="nama@emel.com" 
                   style="padding: 10px; width: 250px;">
            
            <br><br>
            
            <button type="submit" style="padding: 10px 20px; cursor: pointer;">
                Hantar Pautan
            </button>
        </form>

        <br>
        <a href="views/auth/auth.jsp" style="text-decoration: none; color: #0D9488;">Kembali ke Log Masuk</a>
    </div>

</body>
</html>