document.addEventListener('DOMContentLoaded', () => {
  // 1. Mobile Menu Toggle
  const toggleBtn = document.querySelector('.mobile-nav-toggle');
  const closeBtn = document.querySelector('.mobile-nav-close');
  const siteNav = document.querySelector('.site-nav');

  if (toggleBtn && siteNav) {
    toggleBtn.addEventListener('click', () => {
      const isOpen = siteNav.classList.toggle('is-open');
      toggleBtn.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
      document.body.style.overflow = isOpen ? 'hidden' : '';
    });
  }

  if (closeBtn && siteNav) {
    closeBtn.addEventListener('click', () => {
      siteNav.classList.remove('is-open');
      if (toggleBtn) {
        toggleBtn.setAttribute('aria-expanded', 'false');
      }
      document.body.style.overflow = '';
    });
  }

  // Close mobile nav when clicking a link
  const navLinks = document.querySelectorAll('.nav-link');
  navLinks.forEach((link) => {
    link.addEventListener('click', () => {
      if (siteNav && siteNav.classList.contains('is-open')) {
        siteNav.classList.remove('is-open');
        if (toggleBtn) {
          toggleBtn.setAttribute('aria-expanded', 'false');
        }
        document.body.style.overflow = '';
      }
    });
  });

  // Close on Escape key
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && siteNav && siteNav.classList.contains('is-open')) {
      siteNav.classList.remove('is-open');
      if (toggleBtn) {
        toggleBtn.setAttribute('aria-expanded', 'false');
      }
      document.body.style.overflow = '';
    }
  });

  // 2. Video Silent Autoplay Reliability
  const indexVideo = document.querySelector('video.index-video');
  if (indexVideo) {
    indexVideo.defaultMuted = true;
    indexVideo.muted = true;
    const playPromise = indexVideo.play();
    if (playPromise !== undefined) {
      playPromise.catch(() => {
        const resumePlayback = () => {
          indexVideo.play();
          window.removeEventListener('touchstart', resumePlayback, { passive: true });
          window.removeEventListener('scroll', resumePlayback, { passive: true });
          window.removeEventListener('click', resumePlayback);
        };
        window.addEventListener('touchstart', resumePlayback, { passive: true, once: true });
        window.addEventListener('scroll', resumePlayback, { passive: true, once: true });
        window.addEventListener('click', resumePlayback, { once: true });
      });
    }
  }
});
