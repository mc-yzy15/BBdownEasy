// 粒子背景效果
document.addEventListener('DOMContentLoaded', function() {
    // 初始化粒子背景
    const canvas = document.getElementById('particles');
    const ctx = canvas.getContext('2d');
    
    // 设置画布大小为窗口大小
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    
    // 粒子数组
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
            ctx.fillStyle = this.color;
            ctx.beginPath();
            ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
            ctx.fill();
        }
    }
    
    // 创建粒子
    for (let i = 0; i < particleCount; i++) {
        particles.push(new Particle());
    }
    
    // 动画循环
    function animate() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        
        // 更新和绘制粒子
        for (let i = 0; i < particles.length; i++) {
            particles[i].update();
            particles[i].draw();
            
            // 绘制粒子间的连线
            for (let j = i + 1; j < particles.length; j++) {
                const dx = particles[i].x - particles[j].x;
                const dy = particles[i].y - particles[j].y;
                const distance = Math.sqrt(dx * dx + dy * dy);
                
                if (distance < 100) {
                    ctx.strokeStyle = `rgba(0, 255, 157, ${1 - distance / 100})`;
                    ctx.lineWidth = 0.5;
                    ctx.beginPath();
                    ctx.moveTo(particles[i].x, particles[i].y);
                    ctx.lineTo(particles[j].x, particles[j].y);
                    ctx.stroke();
                }
            }
        }
        
        requestAnimationFrame(animate);
    }
    
    animate();
    
    // 终端模拟效果
    const terminal = document.getElementById('terminal');
    const commands = [
        "正在初始化系统...",
        "加载BBDown核心模块...",
        "检查网络连接...",
        "验证API密钥...",
        "准备就绪 >_"
    ];
    
    let i = 0;
    const terminalInterval = setInterval(() => {
        if (i < commands.length) {
            terminal.innerHTML += `<div>${commands[i]}</div>`;
            terminal.scrollTop = terminal.scrollHeight;
            i++;
        } else {
            clearInterval(terminalInterval);
        }
    }, 800);
    
    // 窗口大小调整时重设画布
    window.addEventListener('resize', function() {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
    });
});