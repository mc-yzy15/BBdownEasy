// script.js
// 粒子背景
function initParticles() {
    const canvas = document.getElementById('particles');
    const ctx = canvas.getContext('2d');
    
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;

    const particles = [];
    class Particle {
        constructor() {
            this.reset();
        }
        reset() {
            this.x = Math.random() * canvas.width;
            this.y = Math.random() * canvas.height;
            this.vx = (Math.random() - 0.5) * 0.5;
            this.vy = (Math.random() - 0.5) * 0.5;
            this.alpha = Math.random() * 0.5 + 0.5;
        }
        draw() {
            ctx.beginPath();
            ctx.arc(this.x, this.y, 2, 0, Math.PI*2);
            ctx.fillStyle = `rgba(0, 243, 255, ${this.alpha})`;
            ctx.fill();
        }
        update() {
            this.x += this.vx;
            this.y += this.vy;
            if(this.x < 0 || this.x > canvas.width || 
               this.y < 0 || this.y > canvas.height) this.reset();
        }
    }

    // 初始化粒子
    for(let i=0; i<100; i++) particles.push(new Particle());

    function animate() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        particles.forEach(p => {
            p.update();
            p.draw();
        });
        requestAnimationFrame(animate);
    }
    animate();
}

// 终端模拟效果
function initTerminal() {
    const terminal = document.getElementById('terminal');
    const commands = [
        '> 正在初始化系统... [OK]',
        '> 检测到BBDown v1.6.3',
        '> 准备下载资源...',
        '> 连接B站服务器... [成功]'
    ];

    let index = 0;
    function typeText() {
        if(index < commands.length) {
            terminal.innerHTML += `<span class="command">${commands[index]}</span><br>`;
            terminal.scrollTop = terminal.scrollHeight;
            index++;
            setTimeout(typeText, 1000);
        }
    }
    typeText();
}

// 初始化
window.addEventListener('load', () => {
    initParticles();
    initTerminal();
    
    // 滚动动画
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if(entry.isIntersecting) {
                entry.target.style.opacity = 1;
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, { threshold: 0.1 });

    document.querySelectorAll('.cyber-card').forEach(card => {
        card.style.opacity = 0;
        card.style.transform = 'translateY(50px)';
        observer.observe(card);
    });
});

// 窗口大小变化时重置canvas
window.addEventListener('resize', () => {
    const canvas = document.getElementById('particles');
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
});