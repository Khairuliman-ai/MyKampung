<%-- Global JS Utilities --%>
<script>
    // Centralized modal open/close — digunakan oleh semua JSP
    function openModal(id) { 
        const modal = document.getElementById(id);
        if (modal) {
            modal.classList.remove('hidden');
            document.body.style.overflow = 'hidden';
        }
    }
    function closeModal(id) { 
        const modal = document.getElementById(id);
        if (modal) {
            modal.classList.add('hidden');
            // Restore scroll if no other modals are visible
            const openModals = document.querySelectorAll('.fixed.inset-0:not(.hidden)');
            if (openModals.length === 0) {
                document.body.style.overflow = 'auto';
            }
        }
    }
</script>

<%-- Menutup tag <main> yang dibuka di dalam navbar.jsp --%>
</main> 

<%-- Menutup tag <div class="flex h-screen"> yang dibuka di dalam header.jsp --%>
</div> 

</body>
</html>