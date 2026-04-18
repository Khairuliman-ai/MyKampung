/* Landing Page JS - AJAX Stats & Interactions */

document.addEventListener("DOMContentLoaded", function() {
    
    // 1. Fetch Stats via AJAX
    fetchStats();

    // 2. Smooth Scrolling
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if(target) {
                window.scrollTo({
                    top: target.offsetTop - 80,
                    behavior: 'smooth'
                });
            }
        });
    });

    // 3. Navbar Scroll Effect
    window.addEventListener('scroll', function() {
        const nav = document.querySelector('.landing-navbar');
        if (window.scrollY > 50) {
            nav.classList.add('shadow-sm');
            nav.style.padding = '0.6rem 0';
        } else {
            nav.classList.remove('shadow-sm');
            nav.style.padding = '1rem 0';
        }
    });
});

async function fetchStats() {
    try {
        const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/",2));
        const response = await fetch(`${contextPath}/StatsServlet`);
        const data = await response.json();
        
        if(data) {
            animateValue("stat-pengguna", 0, data.totalPengguna, 2000);
            animateValue("stat-tempahan", 0, data.totalTempahan, 2000);
            animateValue("stat-bantuan", 0, data.totalBantuan, 2000);
        }
    } catch (error) {
        console.error("Error fetching stats:", error);
    }
}

function animateValue(id, start, end, duration) {
    const obj = document.getElementById(id);
    if (!obj) return;
    
    let startTimestamp = null;
    const step = (timestamp) => {
        if (!startTimestamp) startTimestamp = timestamp;
        const progress = Math.min((timestamp - startTimestamp) / duration, 1);
        obj.innerHTML = Math.floor(progress * (end - start) + start);
        if (progress < 1) {
            window.requestAnimationFrame(step);
        }
    };
    window.requestAnimationFrame(step);
}
