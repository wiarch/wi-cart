(() => {
    const input = document.getElementById('global-search-input');
    const clearBtn = document.getElementById('global-search-clear');
    const dropdown = document.getElementById('global-search-results');
    const wrapper = document.getElementById('global-search');

    if (!input || !dropdown || !wrapper) return;

    let debounceTimer = null;
    let activeController = null;
    let dropdownOpen = false;

    const badgeClass = (badge) => ({
        purple: 'web-search-badge-purple',
        blue: 'web-search-badge-blue',
        green: 'web-search-badge-green',
        orange: 'web-search-badge-orange',
        teal: 'web-search-badge-teal',
    }[badge] || 'web-search-badge-purple');

    const iconClass = (icon, badge) => ({
        purple: 'web-search-icon-purple',
        blue: 'web-search-icon-blue',
        green: 'web-search-icon-green',
        orange: 'web-search-icon-orange',
        teal: 'web-search-icon-teal',
    }[badge] || 'web-search-icon-purple');

    const hideDropdown = () => {
        dropdown.classList.add('hidden');
        dropdown.innerHTML = '';
        dropdownOpen = false;
    };

    const showDropdown = () => {
        dropdown.classList.remove('hidden');
        dropdownOpen = true;
    };

    const closeSearch = () => {
        hideDropdown();
        input.blur();
    };

    const escapeHtml = (value) => String(value)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');

    const renderResults = (items) => {
        if (!items.length) {
            dropdown.innerHTML = '<div class="web-search-empty">Sin resultados</div>';
            showDropdown();
            return;
        }

        dropdown.innerHTML = items.map((item) => `
            <a href="${escapeHtml(item.url)}" class="web-search-result">
                <div class="web-search-result-icon ${iconClass(item.icon, item.badge)}">
                    <i class="fa-solid ${escapeHtml(item.icon)}"></i>
                </div>
                <div class="web-search-result-body">
                    <div class="web-search-result-title">${escapeHtml(item.title)}</div>
                    <div class="web-search-result-subtitle">${escapeHtml(item.subtitle)}</div>
                </div>
                <span class="web-search-badge ${badgeClass(item.badge)}">${escapeHtml(item.type)}</span>
            </a>
        `).join('');

        showDropdown();
    };

    const search = async (term) => {
        if (activeController) {
            activeController.abort();
        }

        if (term.length < 1) {
            hideDropdown();
            clearBtn?.classList.add('hidden');
            return;
        }

        clearBtn?.classList.remove('hidden');
        activeController = new AbortController();

        try {
            const response = await fetch(`/search?q=${encodeURIComponent(term)}`, {
                headers: {
                    Accept: 'application/json',
                    'X-Requested-With': 'XMLHttpRequest',
                },
                signal: activeController.signal,
            });

            const data = await response.json();
            renderResults(data.data || []);
        } catch (error) {
            if (error.name !== 'AbortError') {
                hideDropdown();
            }
        }
    };

    input.addEventListener('input', () => {
        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(() => search(input.value.trim()), 200);
    });

    input.addEventListener('focus', () => {
        if (input.value.trim().length >= 1) {
            search(input.value.trim());
        }
    });

    clearBtn?.addEventListener('click', (event) => {
        event.stopPropagation();
        input.value = '';
        clearBtn.classList.add('hidden');
        hideDropdown();
        input.focus();
    });

    document.addEventListener('mousedown', (event) => {
        if (!dropdownOpen) return;
        if (!wrapper.contains(event.target)) {
            closeSearch();
        }
    }, true);

    document.addEventListener('touchstart', (event) => {
        if (!dropdownOpen) return;
        if (!wrapper.contains(event.target)) {
            closeSearch();
        }
    }, true);

    input.addEventListener('keydown', (event) => {
        if (event.key === 'Escape') {
            closeSearch();
        }
    });
})();
