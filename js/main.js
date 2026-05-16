    // Scroll fade-up
    const obs = new IntersectionObserver(entries => {
      entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
    }, { threshold: 0.15 });
    document.querySelectorAll('.fade-up').forEach(el => obs.observe(el));

    const allNavLinks = document.querySelectorAll('.nav-links a, .hero-ctas a');
    const pages = document.querySelectorAll('.page-view');

    function activatePage(id) {
      pages.forEach(page => page.classList.toggle('active', page.id === id));
      allNavLinks.forEach(link => link.classList.toggle('active', link.getAttribute('href') === `#${id}`));
      const activePage = document.getElementById(id);
      if (activePage) {
        activePage.scrollTop = 0;
      }
    }

    allNavLinks.forEach(link => {
      link.addEventListener('click', event => {
        event.preventDefault();
        const targetId = link.getAttribute('href').slice(1);
        if (document.getElementById(targetId)) {
          activatePage(targetId);
          history.replaceState(null, '', `#${targetId}`);
        }
      });
    });

    window.addEventListener('hashchange', () => {
      const hash = window.location.hash.slice(1);
      if (hash && document.getElementById(hash)) {
        activatePage(hash);
      }
    });

    const initialHash = window.location.hash.slice(1) || 'hero';
    activatePage(initialHash);

    // Typing effect
    const roles = ['Analista de Datos', 'Físico y Matemático', 'Narrador de datos'];
    let ri = 0, ci = 0, del = false;
    const span = document.querySelector('.hero-role span');
    function type() {
      const cur = roles[ri];
      if (!del) {
        span.textContent = cur.slice(0, ++ci);
        if (ci === cur.length) { del = true; setTimeout(type, 1800); return; }
      } else {
        span.textContent = cur.slice(0, --ci);
        if (ci === 0) { del = false; ri = (ri + 1) % roles.length; setTimeout(type, 400); return; }
      }
      setTimeout(type, del ? 45 : 80);
    }
    setTimeout(type, 800);