        document.querySelectorAll('nav button').forEach(btn => {
            btn.classList.remove('border-[#6C5DD3]', 'text-[#6C5DD3]', 'font-bold');
            btn.classList.add('border-transparent', 'text-gray-500', 'font-medium');
        });

        // Active Tab Style
        const activeTab = document.getElementById('tab-' + tabName);
        activeTab.classList.add('border-[#6C5DD3]', 'text-[#6C5DD3]', 'font-bold');
        activeTab.classList.remove('border-transparent', 'text-gray-500', 'font-medium');

        // Toggle Content
        document.getElementById('content-proses').classList.add('hidden');
        document.getElementById('content-sejarah').classList.add('hidden');
        
        document.getElementById('content-' + tabName).classList.remove('hidden');
    }

    // 1. OPEN DETAIL MODAL LOGIC
    function openDetailModal(nama, tarikh, status, catatan, ulasan) {
        document.getElementById('detNama').innerText = nama;
        document.getElementById('detTarikh').innerText = tarikh;
        document.getElementById('detCatatan').innerText = (catatan && catatan !== "null") ? catatan : "Tiada maklumat.";
        document.getElementById('detUlasan').innerText = (ulasan && ulasan !== "null") ? ulasan : "Belum ada ulasan.";
        
        // Reset Steps
        const steps = ['step1', 'step2', 'step3', 'step4'];
        const lines = ['line1', 'line2', 'line3'];
        
        steps.forEach(s => {
            const el = document.getElementById(s);
            el.className = "w-10 h-10 rounded-full flex items-center justify-center text-white font-bold shadow-lg transition-all duration-500 bg-gray-200";
            el.innerHTML = s.replace('step', '');
        });
        lines.forEach(l => document.getElementById(l).style.width = "0%");

        let activeStep = 1;
        let mainColor = "bg-[#6C5DD3]";
        
        if (status === "MENUNGGU_KETUA") activeStep = 3;
        else if (status === "LULUS" || status === "DITOLAK") activeStep = 4;
        else if (status === "DIKEMBALIKAN") mainColor = "bg-orange-500";

        // Animate Steps
        setTimeout(() => {
            for(let i=1; i<=activeStep; i++) {
                const el = document.getElementById('step'+i);
                el.classList.remove('bg-gray-200');
                el.classList.add(mainColor);
                if(i < activeStep) el.innerHTML = "✓";
                
                if(i < activeStep && i <= 3) {
                    document.getElementById('line'+i).style.width = "100%";
                    if(mainColor !== "bg-[#6C5DD3]") document.getElementById('line'+i).classList.replace('bg-[#6C5DD3]', 'bg-orange-500');
                }
            }
            
            // Special color for decision
            if(activeStep === 4) {
                const lastStep = document.getElementById('step4');
                lastStep.classList.remove('bg-[#6C5DD3]');
                lastStep.classList.add(status === "LULUS" ? "bg-green-500" : "bg-red-500");
                lastStep.innerHTML = "✓";
            }
        }, 100);

        openModal('modalDetail');
    }

    // 2. OPEN TEXT MODAL LOGIC
    function openTextModal(title, text) {
        document.getElementById('modalTextTitle').innerText = title;
        document.getElementById('modalTextContent').innerText = (text && text.trim() !== "") ? text : "Tiada maklumat.";
        document.getElementById('modalText').classList.remove('hidden');
    }

    // 2. STANDARD MODAL LOGIC
    function openModal(modalId) {
        document.getElementById(modalId).classList.remove('hidden');
        if(modalId === 'modalPilihan') {
            goToStep1(); // Always start wizard at step 1
        }
    }

    function closeModal(modalId) {
        document.getElementById(modalId).classList.add('hidden');
    }

    // --- WIZARD LOGIC ---
    function selectBantuan(id, nama, syaratStr) {
        // Set hidden input
        document.getElementById('hiddenJenisBantuan').value = id;
        
        // Set Label
        document.getElementById('lblBantuanTerpilih').innerText = nama;
        
        // Parse & Set Syarat
        const ul = document.getElementById('lblSyaratDokumen');
        ul.innerHTML = "";
        if (syaratStr && syaratStr.trim() !== "") {
            const syaratArray = syaratStr.split(',');
            syaratArray.forEach(s => {
                if(s.trim().length > 0) {
                    ul.innerHTML += "<li>" + s.trim() + "</li>";
                }
            });
        } else {
             ul.innerHTML = "<li>Tiada syarat khusus dinyatakan.</li>";
        }

        // Handle Lain-lain
        const inputLain = document.getElementById('inputJenisBantuanLain');
        const divLain = document.getElementById('lainBantuanInputDiv');
        if(id === "999") {
            divLain.classList.remove('hidden');
            inputLain.required = true;
        } else {
            divLain.classList.add('hidden');
            inputLain.required = false;
            inputLain.value = "";
        }

        // Move to Step 2
        document.getElementById('wizard-step-1').classList.add('hidden');
        document.getElementById('wizard-step-2').classList.remove('hidden');
    }

    function goToStep1() {
        document.getElementById('wizard-step-2').classList.add('hidden');
        document.getElementById('wizard-step-1').classList.remove('hidden');
    }

    // 3. FILTER LOGIC
    function filterData() {
        const searchVal = document.getElementById("searchInput").value.toLowerCase();
        const dateVal = document.getElementById("dateFilter").value;
        const rows = document.querySelectorAll(".data-row");
        
        rows.forEach(row => {
            const rowDate = row.getAttribute("data-date");
            let textContent = "";
            row.querySelectorAll(".search-col").forEach(col => textContent += col.innerText.toLowerCase() + " ");
            
            let showRow = true;
            if (dateVal !== "" && rowDate !== dateVal) showRow = false;
            if (searchVal !== "" && !textContent.includes(searchVal)) showRow = false;
            
            row.style.display = showRow ? "" : "none";
        });
    }



<%@ include file="/views/common/footer.jsp" %>
