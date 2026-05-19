<%@ page pageEncoding="UTF-8" %>
<%
    // Ensure we have contextual user info if authenticated
    model.Pengguna chatUser = (model.Pengguna) session.getAttribute("currentUser");
    String chatUserName = (chatUser != null) ? chatUser.getNama_penuh() : "Penduduk";
%>
<!-- KampungBot Floating Chat Widget -->
<div id="kampungBotContainer" class="fixed bottom-6 right-6 z-[9999] font-sans">
    
    <!-- Floating Action Button (FAB) -->
    <button id="chatbotToggleBtn" onclick="toggleChatWindow()" 
            class="flex items-center justify-center w-14 h-14 bg-gradient-to-r from-brand-purple to-brand-secondary text-white rounded-full shadow-2xl hover:scale-110 active:scale-95 transition-all duration-300 relative group focus:outline-none">
        
        <!-- Animated glow background pulse -->
        <span class="absolute inset-0 rounded-full bg-brand-purple opacity-40 animate-ping group-hover:animate-none"></span>
        
        <!-- Standard Chat Icon -->
        <i id="chatbotIconChat" class="fas fa-comment-dots text-2xl transition-all duration-300"></i>
        
        <!-- Close Icon (Hidden by default) -->
        <i id="chatbotIconClose" class="fas fa-times text-2xl absolute opacity-0 scale-50 transition-all duration-300"></i>
        
        <!-- Tooltip -->
        <span class="absolute right-16 bg-gray-900 text-white text-xs font-bold px-3 py-1.5 rounded-xl shadow-lg opacity-0 pointer-events-none group-hover:opacity-100 transition-opacity duration-300 whitespace-nowrap hidden md:block">
            Tanya KampungBot 🤖
        </span>
    </button>

    <!-- Chat Window Container -->
    <div id="chatbotWindow" 
         class="absolute bottom-20 right-0 w-[360px] md:w-[400px] h-[550px] bg-white/95 backdrop-blur-md rounded-[2.5rem] shadow-2xl border border-gray-100 flex flex-col overflow-hidden transition-all duration-500 transform translate-y-10 opacity-0 pointer-events-none origin-bottom-right">
        
        <!-- Chat Header -->
        <div class="p-6 bg-gradient-to-r from-brand-purple to-brand-secondary text-white flex items-center justify-between shadow-lg relative overflow-hidden flex-shrink-0">
            <!-- Decorative circle shape -->
            <div class="absolute -right-6 -top-6 w-24 h-24 bg-white/10 rounded-full blur-xl pointer-events-none"></div>
            
            <div class="flex items-center gap-3 relative z-10">
                <div class="w-10 h-10 bg-white/20 rounded-2xl flex items-center justify-center border border-white/20">
                    <span class="text-xl">🤖</span>
                </div>
                <div>
                    <h3 class="font-bold text-sm leading-tight">KampungBot</h3>
                    <p class="text-[10px] text-brand-accent/80 flex items-center gap-1">
                        <span class="w-1.5 h-1.5 bg-green-400 rounded-full animate-pulse"></span>
                        Pembantu Maya Danan
                    </p>
                </div>
            </div>
            
            <button onclick="toggleChatWindow()" class="text-white/80 hover:text-white transition focus:outline-none p-1 rounded-full hover:bg-white/10">
                <i class="fas fa-chevron-down text-sm"></i>
            </button>
        </div>

        <!-- Messages Area -->
        <div id="chatbotMessages" class="flex-1 p-6 overflow-y-auto space-y-4 bg-gray-50/50 custom-scrollbar">
            
            <!-- Default Welcome Message from KampungBot -->
            <div class="flex items-start gap-2.5 max-w-[85%]">
                <div class="w-8 h-8 rounded-xl bg-brand-accent border border-brand-secondary/20 flex items-center justify-center text-sm flex-shrink-0">🤖</div>
                <div class="bg-white p-4 rounded-3xl rounded-tl-sm shadow-sm border border-gray-100 text-xs text-gray-700 leading-relaxed">
                    <p class="font-bold text-gray-900 mb-2">Assalamualaikum <%= chatUserName %>! 👋</p>
                    <p class="mb-3">Saya **KampungBot**, pembantu kecerdasan buatan anda. Ada sebarang pertanyaan mengenai sistem MyKampung atau Kampung Danan?</p>
                    <p class="mb-2 font-semibold text-gray-900">Anda boleh bertanyakan mengenai:</p>
                    <ul class="space-y-1 list-disc list-inside text-gray-600 pl-1">
                        <li>Cara menghantar **Aduan & Cadangan**</li>
                        <li>Syarat & kelayakan **Mohon Bantuan**</li>
                        <li>Prosedur tempahan **Fasiliti Kampung**</li>
                        <li>Aktiviti atau **Info & Hebahan** terkini</li>
                    </ul>
                </div>
            </div>
            
        </div>

        <!-- Chat Input Form -->
        <div class="p-4 bg-white border-t border-gray-100 flex-shrink-0">
            <form id="chatbotForm" onsubmit="handleChatSubmit(event)" class="flex gap-2 items-center">
                <input type="text" id="chatbotInput" 
                       class="flex-1 px-4 py-3 bg-[#F7F7F9] rounded-2xl border-none focus:ring-2 focus:ring-brand-purple text-xs placeholder-gray-400 focus:outline-none" 
                       placeholder="Tulis mesej anda di sini..." autocomplete="off">
                
                <button type="submit" 
                        class="w-10 h-10 rounded-2xl bg-brand-purple text-white flex items-center justify-center shadow-md hover:bg-brand-purpleHover active:scale-95 transition-all focus:outline-none flex-shrink-0">
                    <i class="fas fa-paper-plane text-xs"></i>
                </button>
            </form>
            <div class="text-[9px] text-gray-400 text-center mt-2.5 flex items-center justify-center gap-1">
                <i class="fas fa-magic text-[8px] text-brand-purple"></i> Dijana oleh Gemini AI
            </div>
        </div>

    </div>
</div>

<style>
    /* Premium Scrollbar for Chat widget */
    .custom-scrollbar::-webkit-scrollbar {
        width: 4px;
    }
    .custom-scrollbar::-webkit-scrollbar-track {
        background: transparent;
    }
    .custom-scrollbar::-webkit-scrollbar-thumb {
        background: #E2E8F0;
        border-radius: 10px;
    }
    .custom-scrollbar::-webkit-scrollbar-thumb:hover {
        background: #CBD5E1;
    }

    /* Message formatting styling */
    #chatbotMessages strong, #chatbotMessages b {
        color: #111827;
        font-weight: 700;
    }
    #chatbotMessages p {
        margin-bottom: 0.5rem;
    }
    #chatbotMessages p:last-child {
        margin-bottom: 0;
    }
</style>

<script>
    let isChatOpen = false;

    function toggleChatWindow() {
        const chatWindow = document.getElementById('chatbotWindow');
        const iconChat = document.getElementById('chatbotIconChat');
        const iconClose = document.getElementById('chatbotIconClose');
        const toggleBtn = document.getElementById('chatbotToggleBtn');
        const chatInput = document.getElementById('chatbotInput');

        isChatOpen = !isChatOpen;

        if (isChatOpen) {
            // Open window animation
            chatWindow.classList.remove('translate-y-10', 'opacity-0', 'pointer-events-none');
            chatWindow.classList.add('translate-y-0', 'opacity-100');
            
            // Toggle FAB icons
            iconChat.classList.add('opacity-0', 'scale-50');
            iconClose.classList.remove('opacity-0', 'scale-50');
            iconClose.classList.add('opacity-100', 'scale-100');
            
            // FAB Active styling
            toggleBtn.classList.add('rotate-90');
            
            // Auto focus input
            setTimeout(() => chatInput.focus(), 300);
        } else {
            // Close window animation
            chatWindow.classList.remove('translate-y-0', 'opacity-100');
            chatWindow.classList.add('translate-y-10', 'opacity-0', 'pointer-events-none');
            
            // Toggle FAB icons
            iconClose.classList.add('opacity-0', 'scale-50');
            iconChat.classList.remove('opacity-0', 'scale-50');
            iconChat.classList.add('opacity-100', 'scale-100');
            
            // FAB Normal styling
            toggleBtn.classList.remove('rotate-90');
        }
    }

    function formatMarkdown(text) {
        if (!text) return "";
        try {
            let formatted = text
                // Escape HTML entities to prevent XSS
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                // Bold (**text** or *text*)
                .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
                .replace(/\*(.*?)\*/g, '<strong>$1</strong>')
                // Bullet list items
                .replace(/^\s*-\s+(.*?)$/gm, '<li class="ml-2 list-disc">$1</li>')
                .replace(/^\s*\*\s+(.*?)$/gm, '<li class="ml-2 list-disc">$1</li>')
                // Paragraph formatting by newline split
                .split('\n').map(p => {
                    p = p.trim();
                    if (p.startsWith('<li')) return p;
                    return p ? '<p>' + p + '</p>' : "";
                }).join('');

            // Wrap loose lists safely
            formatted = formatted.replace(/(<li.*<\/li>)/g, '<ul class="space-y-1 pl-1 mb-2">$1</ul>');
            return formatted;
        } catch (e) {
            console.error("formatMarkdown error:", e);
            return text;
        }
    }

    function appendMessage(sender, text, isAI) {
        try {
            const messagesContainer = document.getElementById('chatbotMessages');
            if (!messagesContainer) {
                console.error("Messages container not found!");
                return;
            }
            
            const wrapper = document.createElement('div');
            wrapper.className = 'flex items-start gap-2.5 max-w-[85%] ' + (!isAI ? 'ml-auto justify-end' : '');

            let formattedText = formatMarkdown(text);

            let iconMarkup = isAI 
                ? '<div class="w-8 h-8 rounded-xl bg-brand-accent border border-brand-secondary/20 flex items-center justify-center text-sm flex-shrink-0">🤖</div>'
                : '';
                
            let bubbleClass = isAI
                ? 'bg-white text-gray-700 rounded-3xl rounded-tl-sm shadow-sm border border-gray-100'
                : 'bg-brand-purple text-white rounded-3xl rounded-tr-sm shadow-md';

            wrapper.innerHTML = iconMarkup +
                '<div class="' + bubbleClass + ' p-4 text-xs leading-relaxed">' +
                    formattedText +
                '</div>';

            messagesContainer.appendChild(wrapper);
            messagesContainer.scrollTop = messagesContainer.scrollHeight;
        } catch (err) {
            console.error("Error in appendMessage:", err);
            alert("Ralat Paparan Chatbot: " + err.message);
        }
    }

    function showTypingIndicator() {
        try {
            const messagesContainer = document.getElementById('chatbotMessages');
            if (!messagesContainer) return;
            
            const indicator = document.createElement('div');
            indicator.id = 'chatbotTypingIndicator';
            indicator.className = 'flex items-start gap-2.5 max-w-[85%] animate-pulse';
            
            indicator.innerHTML = 
                '<div class="w-8 h-8 rounded-xl bg-brand-accent border border-brand-secondary/20 flex items-center justify-center text-sm flex-shrink-0">🤖</div>' +
                '<div class="bg-white p-4 rounded-3xl rounded-tl-sm shadow-sm border border-gray-100 text-xs text-gray-500 flex items-center gap-1.5">' +
                    '<span class="w-1.5 h-1.5 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 0ms"></span>' +
                    '<span class="w-1.5 h-1.5 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 150ms"></span>' +
                    '<span class="w-1.5 h-1.5 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 300ms"></span>' +
                '</div>';
            
            messagesContainer.appendChild(indicator);
            messagesContainer.scrollTop = messagesContainer.scrollHeight;
        } catch (err) {
            console.error("Error showing typing indicator:", err);
        }
    }

    function removeTypingIndicator() {
        const indicator = document.getElementById('chatbotTypingIndicator');
        if (indicator) {
            indicator.remove();
        }
    }

    function handleChatSubmit(event) {
        try {
            event.preventDefault();
            
            const input = document.getElementById('chatbotInput');
            const message = input.value.trim();
            
            if (!message) return;

            // Clear input field
            input.value = '';

            // Display user message in UI
            appendMessage('user', message, false);

            // Show AI typing indicator
            showTypingIndicator();

            // Perform AJAX Fetch POST request to backend ChatbotServlet
            const params = new URLSearchParams();
            params.append('message', message);

            fetch('<%= request.getContextPath() %>/chatbot/ask', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                },
                body: params.toString()
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Respons rangkaian ralat: status ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                removeTypingIndicator();
                appendMessage('model', data.reply, true);
            })
            .catch(error => {
                console.error('Chatbot error:', error);
                removeTypingIndicator();
                appendMessage('model', '⚠️ <strong>Masalah Sambungan Dikesan:</strong><br>' + 
                              'Sila pastikan anda telah melakukan <strong>Clean & Build</strong> dan **Restart Server (Tomcat)** selepas perubahan web.xml.<br><br>' +
                              '<small class="text-gray-400">Ralat: ' + error.message + '</small>', true);
            });
        } catch (err) {
            console.error("Error in handleChatSubmit:", err);
            alert("Ralat JavaScript Chatbot: " + err.message);
        }
    }
</script>
