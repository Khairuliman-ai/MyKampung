<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Pengguna" %>

<div class="container-fluid px-4 mt-4">
    <h4 class="fw-bold text-dark mb-4">Pengesahan Penduduk Baharu</h4>

    <div class="card border-0 shadow-sm rounded-4">
        <div class="card-body p-0">
            <table class="table table-hover align-middle mb-0">
                <thead class="bg-light">
                    <tr>
                        <th class="ps-4 py-3">Nama Penuh</th>
                        <th>No. KP</th>
                        <th>Alamat</th>
                        <th>No. Telefon</th>
                        <th class="text-center">Tindakan</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    List<Pengguna> list = (List<Pengguna>) request.getAttribute("pendingList");
                    if (list != null && !list.isEmpty()) {
                        for (Pengguna p : list) {
                    %>
                    <tr>
                        <td class="ps-4 fw-bold text-primary"><%= p.getNamaLengkap() %></td>
                        <td><%= p.getNomborKP() %></td>
                        <td class="small text-muted"><%= p.getAlamat() %></td>
                        <td><%= p.getNomborTelefon() %></td>
                        <td class="text-center">
                            <form action="<%= request.getContextPath() %>/penduduk/approve" method="post" class="d-inline">
                                <input type="hidden" name="idPengguna" value="<%= p.getIdPengguna() %>">
                                <button class="btn btn-success btn-sm rounded-pill px-3 fw-bold"><i class="bi bi-check-lg"></i> Lulus</button>
                            </form>
                            <form action="<%= request.getContextPath() %>/penduduk/reject" method="post" class="d-inline ms-1">
                                <input type="hidden" name="idPengguna" value="<%= p.getIdPengguna() %>">
                                <button class="btn btn-outline-danger btn-sm rounded-pill px-3"><i class="bi bi-x-lg"></i> Tolak</button>
                            </form>
                        </td>
                    </tr>
                    <% 
                        }
                    } else { 
                    %>
                    <tr>
                        <td colspan="5" class="text-center py-5 text-muted">
                            <i class="bi bi-person-check fs-1 d-block mb-2 opacity-50"></i>
                            Tiada pendaftaran baharu untuk disemak.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="/views/common/footer.jsp" %>