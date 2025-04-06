// 粒子背景效果
function initParticles() {
    const canvas = document.getElementById('particles');
    const ctx = canvas.getContext('2d');
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;

    const particles = [];
    const particleCount = Math.floor(window.innerWidth / 10);

    // 粒子类
    class Particle {
        constructor() {
            this.x = Math.random() * canvas.width;
            this.y = Math.random() * canvas.height;
            this.size = Math.random() * 2 + 1;
            this.speedX = Math.random() * 3 - 1.5;
            this.speedY = Math.random() * 3 - 1.5;
            this.color = `hsl(${Math.random() * 60 + 150}, 100%, 50%)`;
        }

        update() {
            this.x += this.speedX;
            this.y += this.speedY;

            if (this.x < 0 || this.x > canvas.width) this.speedX *= -1;
            if (this.y < 0 || this.y > canvas.height) this.speedY *= -1;
        }

        draw() {
            ctx.beginPath();
            ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
            ctx.fillStyle = this.color;
            ctx.fill();
            ctx.closePath();
        }
    }

    // 初始化粒子
    function init() {
        for (let i = 0; i < particleCount; i++) {
            particles.push(new Particle());
        }
    }

    // 动画循环
    function animate() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        
        // 绘制连接线
        for (let i = 0; i < particles.length; i++) {
            for (let j = i + 1; j < particles.length; j++) {
                const dx = particles[i].x - particles[j].x;
                const dy = particles[i].y - particles[j].y;
                const distance = Math.sqrt(dx * dx + dy * dy);
                
                if (distance < 100) {
                    ctx.beginPath();
                    ctx.strokeStyle = `rgba(0, 255, 157, ${1 - distance / 100})`;
                    ctx.lineWidth = 0.5;
                    ctx.moveTo(particles[i].x, particles[i].y);
                    ctx.lineTo(particles[j].x, particles[j].y);
                    ctx.stroke();
                    ctx.closePath();
                }
            }
            particles[i].update();
            particles[i].draw();
        }
        requestAnimationFrame(animate);
    }

    init();
    animate();

    // 窗口大小调整时重置画布
    window.addEventListener('resize', () => {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
    });
}

// 终端模拟效果
function initTerminal() {
    const terminal = document.querySelector('.cyber-terminal');
    if (!terminal) return;

    const content = terminal.querySelector('.terminal-content');
    const commands = [
        '> 正在初始化BBdownEasy系统...',
        '> 检查网络连接... OK',
        '> 加载核心模块... OK',
        '> 验证用户权限... OK',
        '> 系统准备就绪',
        '> 输入 "help" 获取命令列表'
    ];

    let index = 0;
    const speed = 50; // 打字速度(ms)

    function typeWriter() {
        if (index < commands.length) {
            const command = commands[index];
            let charIndex = 0;
            const p = document.createElement('p');
            content.appendChild(p);

            function typeChar() {
                if (charIndex < command.length) {
                    p.textContent += command.charAt(charIndex);
                    charIndex++;
                    setTimeout(typeChar, speed);
                } else {
                    index++;
                    setTimeout(typeWriter, 500);
                }
            }

            typeChar();
        } else {
            // 添加闪烁的光标
            const cursor = document.createElement('span');
            cursor.className = 'cursor';
            cursor.textContent = '_';
            content.appendChild(cursor);
            
            // 光标闪烁动画
            setInterval(() => {
                cursor.style.visibility = cursor.style.visibility === 'hidden' ? 'visible' : 'hidden';
            }, 500);
        }
    }

    typeWriter();
}

// 霓虹文字悬停效果
function initNeonEffects() {
    const neonTexts = document.querySelectorAll('.neon-text');
    neonTexts.forEach(text => {
        text.addEventListener('mouseenter', () => {
            text.style.animation = 'neonGlow 0.5s ease-in-out infinite alternate';
        });
        text.addEventListener('mouseleave', () => {
            text.style.animation = 'neonGlow 1.5s ease-in-out infinite alternate';
        });
    });
}

// 链接悬停效果
function initLinkEffects() {
    const links = document.querySelectorAll('.cyber-link');
    links.forEach(link => {
        link.addEventListener('mouseenter', () => {
            const glow = link.querySelector('.link-glow');
            if (glow) glow.style.opacity = '1';
        });
        link.addEventListener('mouseleave', () => {
            const glow = link.querySelector('.link-glow');
            if (glow) glow.style.opacity = '0';
        });
    });
}

// 页面加载完成后初始化所有效果
document.addEventListener('DOMContentLoaded', () => {
    initParticles();
    initTerminal();
    initNeonEffects();
    initLinkEffects();
    
    // 控制台日志
    console.log('%cBBdownEasy 已加载', 
        'color: #00ff9d; font-size: 18px; font-family: "Courier New", monospace;');
});