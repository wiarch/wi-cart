(() => {
    const csrf = document.querySelector('meta[name="csrf-token"]')?.content;

    const toast = (message, icon = 'success') => {
        if (typeof AppSwal !== 'undefined') {
            AppSwal.fire({
                icon,
                title: icon === 'success' ? 'Listo' : 'Error',
                text: message,
                timer: 2500,
                showConfirmButton: false,
                toast: true,
                position: 'top-end',
            });
        }
    };

    const request = async (url, method, body = null) => {
        const options = {
            method,
            headers: {
                Accept: 'application/json',
                'X-CSRF-TOKEN': csrf,
                'X-Requested-With': 'XMLHttpRequest',
            },
        };

        if (body && !(body instanceof FormData)) {
            options.headers['Content-Type'] = 'application/json';
            options.body = JSON.stringify(body);
        } else if (body instanceof FormData) {
            options.body = body;
        }

        const response = await fetch(url, options);
        const data = await response.json().catch(() => ({}));

        if (!response.ok) {
            const message = data.message || Object.values(data.errors || {}).flat().join(' ') || 'Error en la operación.';
            throw new Error(message);
        }

        return data;
    };

    const reloadTable = (selector) => {
        const table = $(selector).DataTable();
        if (table) {
            table.ajax.reload(null, false);
        }
    };

    const openModal = (id) => {
        document.getElementById(id)?.classList.remove('hidden');
        document.body.style.overflow = 'hidden';
    };

    const closeModal = (id) => {
        document.getElementById(id)?.classList.add('hidden');
        document.body.style.overflow = '';
    };

    document.querySelectorAll('[data-modal-close]').forEach((el) => {
        el.addEventListener('click', () => closeModal(el.dataset.modalClose));
    });

    const entities = {
        category: {
            modal: 'modal-simple',
            titleCreate: 'Nueva categoría',
            titleEdit: 'Editar categoría',
            table: '#categories-table',
            store: '/categories',
            field: 'name',
        },
        store: {
            modal: 'modal-simple',
            titleCreate: 'Nuevo negocio',
            titleEdit: 'Editar negocio',
            table: '#stores-table',
            store: '/stores',
            field: 'name',
        },
        unit: {
            modal: 'modal-simple',
            titleCreate: 'Nueva unidad',
            titleEdit: 'Editar unidad',
            table: '#units-table',
            store: '/units',
            field: 'name',
        },
        list: {
            modal: 'modal-list',
            titleCreate: 'Nueva lista',
            titleEdit: 'Editar lista',
            table: '#lists-table',
            store: '/lists',
        },
        product: {
            modal: 'modal-product',
            titleCreate: 'Nuevo producto',
            titleEdit: 'Editar producto',
            table: '#products-table',
            store: '/products',
        },
    };

    let currentEntity = null;
    let currentId = null;

    const openSimpleModal = (entityKey, data = null) => {
        const config = entities[entityKey];
        if (!config) return;

        currentEntity = entityKey;
        currentId = data?.id || null;

        const modal = document.getElementById(config.modal);
        if (!modal) return;

        modal.querySelector('[data-modal-title]').textContent = currentId ? config.titleEdit : config.titleCreate;

        if (['category', 'store', 'unit'].includes(entityKey)) {
            document.querySelectorAll('#modal-simple [data-crud-form]').forEach((form) => form.classList.add('hidden'));
            const form = modal.querySelector(`[data-crud-form="${entityKey}"]`);
            form?.classList.remove('hidden');
            form?.querySelector('[name="name"]').value = data?.name || '';
            if (entityKey === 'store') {
                form.querySelector('[name="location"]').value = data?.location || '';
                form.querySelector('[name="contact"]').value = data?.contact || '';
            }
        } else if (entityKey === 'list') {
            modal.querySelector('[name="name"]').value = data?.name || '';
            modal.querySelector('[name="status"]').value = data?.status || 'active';
            modal.querySelector('[name="notes"]').value = data?.notes || '';
        } else if (entityKey === 'product') {
            modal.querySelector('[name="name"]').value = data?.name || '';
            modal.querySelector('[name="category_id"]').value = data?.category_id || '';
            modal.querySelector('[name="unit_id"]').value = data?.unit_id || '';
            modal.querySelector('[name="store_id"]').value = data?.store_id || '';
            modal.querySelector('[name="price"]').value = data?.price ?? '';
        }

        openModal(config.modal);
    };

    document.addEventListener('click', async (event) => {
        const editBtn = event.target.closest('[data-crud-edit]');
        if (editBtn) {
            const entityKey = editBtn.dataset.crudEdit;
            const config = entities[entityKey];
            if (!config) return;

            if (entityKey === 'product') {
                const data = await request(`${config.store}/${editBtn.dataset.id}`, 'GET');
                openSimpleModal(entityKey, { id: editBtn.dataset.id, ...data.data });
                return;
            }

            openSimpleModal(entityKey, {
                id: editBtn.dataset.id,
                name: editBtn.dataset.name,
                location: editBtn.dataset.location,
                contact: editBtn.dataset.contact,
                status: editBtn.dataset.status,
                notes: editBtn.dataset.notes,
            });
            return;
        }

        const deleteBtn = event.target.closest('[data-crud-delete]');
        if (deleteBtn) {
            const entityKey = deleteBtn.dataset.crudDelete;
            const config = entities[entityKey];
            if (!config) return;

            const name = deleteBtn.dataset.name || 'este elemento';
            const confirmed = await AppSwal.fire({
                title: 'Confirmar',
                text: `¿Eliminar ${name}?`,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Eliminar',
                cancelButtonText: 'Cancelar',
                reverseButtons: true,
            });

            if (!confirmed.isConfirmed) return;

            try {
                const data = await request(`${config.store}/${deleteBtn.dataset.id}`, 'DELETE');
                toast(data.message);
                if ($(config.table).length && $.fn.DataTable.isDataTable(config.table)) {
                    reloadTable(config.table);
                } else {
                    window.location.reload();
                }
            } catch (error) {
                toast(error.message, 'error');
            }
        }

        const createBtn = event.target.closest('[data-crud-create]');
        if (createBtn) {
            currentId = null;
            openSimpleModal(createBtn.dataset.crudCreate);
        }
    });

    document.querySelectorAll('[data-crud-form]').forEach((form) => {
        form.addEventListener('submit', async (event) => {
            event.preventDefault();
            const entityKey = form.dataset.crudForm;
            const config = entities[entityKey];
            if (!config) return;

            const formData = new FormData(form);
            const payload = Object.fromEntries(formData.entries());

            if (entityKey === 'product' && payload.price === '') {
                payload.price = null;
            }

            Object.keys(payload).forEach((key) => {
                if (payload[key] === '') payload[key] = null;
            });

            try {
                const url = currentId ? `${config.store}/${currentId}` : config.store;
                const method = currentId ? 'PUT' : 'POST';
                const data = await request(url, method, payload);
                toast(data.message);
                closeModal(config.modal);
                if ($(config.table).length && $.fn.DataTable.isDataTable(config.table)) {
                    reloadTable(config.table);
                } else {
                    window.location.reload();
                }
                form.reset();
                currentId = null;
            } catch (error) {
                toast(error.message, 'error');
            }
        });
    });

    // List items modal
    let activeListId = null;
    let activeListName = '';

    const renderListItems = (items) => {
        window._listItemsCache = items;
        const container = document.getElementById('list-items-body');
        if (!container) return;

        if (!items.length) {
            container.innerHTML = '<p class="text-sm" style="color: var(--on-surface-muted);">Sin artículos en esta lista.</p>';
            return;
        }

        container.innerHTML = items.map((item) => `
            <div class="web-list-item">
                <div>
                    <div class="font-semibold">${item.name}</div>
                    <div class="text-sm" style="color: var(--on-surface-muted);">
                        Cant: ${item.quantity}${item.unit ? ' ' + item.unit.name : ''}
                        ${item.price ? ' · ' + Number(item.price).toFixed(2) : ''}
                        ${item.is_checked ? ' · <span class="text-success">Comprado</span>' : ''}
                    </div>
                </div>
                <div class="flex gap-2">
                    <button type="button" class="web-icon-btn" data-item-edit="${item.id}" title="Editar">
                        <i class="fa-solid fa-pen-to-square"></i>
                    </button>
                    <button type="button" class="web-icon-btn" data-item-delete="${item.id}" title="Eliminar">
                        <i class="fa-solid fa-trash-can text-danger"></i>
                    </button>
                </div>
            </div>
        `).join('');
    };

    const loadListItems = async () => {
        const data = await request(`/lists/${activeListId}/items`, 'GET');
        renderListItems(data.data);
    };

    document.addEventListener('click', async (event) => {
        const openItemsBtn = event.target.closest('[data-list-items]');
        if (openItemsBtn) {
            activeListId = openItemsBtn.dataset.listItems;
            activeListName = openItemsBtn.dataset.name;
            document.getElementById('list-items-title').textContent = `Artículos · ${activeListName}`;
            document.getElementById('list-item-form').reset();
            document.getElementById('list-item-form').dataset.itemId = '';
            openModal('modal-list-items');
            try {
                await loadListItems();
            } catch (error) {
                toast(error.message, 'error');
            }
            return;
        }

        const editItemBtn = event.target.closest('[data-item-edit]');
        if (editItemBtn) {
            const item = (window._listItemsCache || []).find((row) => String(row.id) === editItemBtn.dataset.itemEdit);
            if (!item) return;
            const form = document.getElementById('list-item-form');
            form.dataset.itemId = item.id;
            form.name.value = item.name;
            form.quantity.value = item.quantity;
            form.unit_id.value = item.unit_id || '';
            form.category_id.value = item.category_id || '';
            form.price.value = item.price ?? '';
            form.is_checked.checked = !!item.is_checked;
        }

        const deleteItemBtn = event.target.closest('[data-item-delete]');
        if (deleteItemBtn && activeListId) {
            const confirmed = await AppSwal.fire({
                title: 'Confirmar',
                text: '¿Eliminar este artículo?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Eliminar',
                cancelButtonText: 'Cancelar',
            });

            if (!confirmed.isConfirmed) return;

            try {
                const data = await request(`/lists/${activeListId}/items/${deleteItemBtn.dataset.itemDelete}`, 'DELETE');
                toast(data.message);
                await loadListItems();
                reloadTable('#lists-table');
            } catch (error) {
                toast(error.message, 'error');
            }
        }
    });

    const listItemForm = document.getElementById('list-item-form');
    if (listItemForm) {
        listItemForm.addEventListener('submit', async (event) => {
            event.preventDefault();
            if (!activeListId) return;

            const formData = new FormData(listItemForm);
            const payload = Object.fromEntries(formData.entries());
            payload.is_checked = listItemForm.is_checked.checked;

            Object.keys(payload).forEach((key) => {
                if (payload[key] === '') payload[key] = null;
            });

            const itemId = listItemForm.dataset.itemId;
            const url = itemId
                ? `/lists/${activeListId}/items/${itemId}`
                : `/lists/${activeListId}/items`;
            const method = itemId ? 'PUT' : 'POST';

            try {
                const data = await request(url, method, payload);
                toast(data.message);
                listItemForm.reset();
                listItemForm.dataset.itemId = '';
                await loadListItems();
                reloadTable('#lists-table');
            } catch (error) {
                toast(error.message, 'error');
            }
        });
    }

    const profileForm = document.getElementById('profile-form');
    if (profileForm) {
        profileForm.addEventListener('submit', async (event) => {
            event.preventDefault();
            const formData = new FormData(profileForm);
            try {
                const data = await request('/settings/profile', 'PUT', Object.fromEntries(formData.entries()));
                toast(data.message);
                closeModal('modal-profile');
                document.querySelectorAll('.web-user-name').forEach((el) => {
                    el.textContent = data.data.name;
                });
            } catch (error) {
                toast(error.message, 'error');
            }
        });
    }

    document.querySelectorAll('[data-open-profile]').forEach((btn) => {
        btn.addEventListener('click', () => {
            const name = btn.dataset.currentName || '';
            document.querySelector('#profile-form [name="name"]').value = name;
            openModal('modal-profile');
        });
    });

    window.WebCrud = { openSimpleModal, reloadTable, toast };
})();
