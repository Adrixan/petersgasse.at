document.addEventListener('DOMContentLoaded', () => {
  const navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);
  const nav = document.querySelector('nav');
  const pickers = Array.prototype.slice.call(document.querySelectorAll('.optionswitch__picker'), 0);

  // 1. Hamburger menu toggle
  if (navbarBurgers.length > 0) {
    navbarBurgers.forEach((navbarBurger) => {
      navbarBurger.addEventListener('click', () => {
        const isActive = navbarBurger.classList.toggle('nav--active');
        if (nav) {
          nav.classList.toggle('nav--active');
        }
        navbarBurger.setAttribute('aria-expanded', isActive ? 'true' : 'false');

        // When closing the hamburger menu, also close all open submenus
        if (!isActive) {
          pickers.forEach((p) => {
            p.checked = false;
          });
        }
      });
    });
  }

  // 2. Dropdown behavior: only one open at a time
  pickers.forEach((picker) => {
    picker.addEventListener('change', () => {
      if (picker.checked) {
        pickers.forEach((other) => {
          if (other !== picker) {
            other.checked = false;
          }
        });
      }
    });
  });

  // 3. Close open dropdowns when clicking outside
  document.addEventListener('click', (event) => {
    if (event.target.closest('.optionswitch')) {
      return;
    }
    pickers.forEach((picker) => {
      if (picker.checked) {
        picker.checked = false;
      }
    });
  });

  // 4. Close open dropdowns on Escape key
  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
      pickers.forEach((picker) => {
        picker.checked = false;
      });
    }
  });

  // 5. Close dropdowns when clicking any navigation link inside a dropdown
  const dropdownLinks = document.querySelectorAll('.optionswitch__list a');
  dropdownLinks.forEach((link) => {
    link.addEventListener('click', () => {
      pickers.forEach((picker) => {
        picker.checked = false;
      });
      // On mobile, also close the navbar burger
      if (nav && nav.classList.contains('nav--active')) {
        nav.classList.remove('nav--active');
        navbarBurgers.forEach((burger) => {
          burger.classList.remove('nav--active');
          burger.setAttribute('aria-expanded', 'false');
        });
      }
    });
  });
});
