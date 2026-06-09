<div id="modal-simple" class="web-modal hidden">
    <div class="web-modal-backdrop" data-modal-close="modal-simple"></div>
    <div class="web-modal-dialog">
        <div class="web-modal-header">
            <h3 class="web-modal-title" data-modal-title>Nuevo registro</h3>
            <button type="button" class="web-icon-btn" data-modal-close="modal-simple"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <form data-crud-form="category" id="form-simple-category" class="hidden web-form-grid">
            <div>
                <label class="web-label">Nombre</label>
                <input type="text" name="name" class="web-input" required maxlength="255">
            </div>
            <div class="web-modal-footer">
                <button type="button" class="btn-secondary" data-modal-close="modal-simple">Cancelar</button>
                <button type="submit" class="btn-primary">Guardar</button>
            </div>
        </form>
        <form data-crud-form="store" id="form-simple-store" class="hidden web-form-grid">
            <div>
                <label class="web-label">Nombre</label>
                <input type="text" name="name" class="web-input" required maxlength="255">
            </div>
            <div>
                <label class="web-label">Ubicación</label>
                <input type="text" name="location" class="web-input" maxlength="255">
            </div>
            <div>
                <label class="web-label">Contacto</label>
                <input type="text" name="contact" class="web-input" maxlength="255">
            </div>
            <div class="web-modal-footer">
                <button type="button" class="btn-secondary" data-modal-close="modal-simple">Cancelar</button>
                <button type="submit" class="btn-primary">Guardar</button>
            </div>
        </form>
        <form data-crud-form="unit" id="form-simple-unit" class="hidden web-form-grid">
            <div>
                <label class="web-label">Nombre</label>
                <input type="text" name="name" class="web-input" required maxlength="255">
            </div>
            <div class="web-modal-footer">
                <button type="button" class="btn-secondary" data-modal-close="modal-simple">Cancelar</button>
                <button type="submit" class="btn-primary">Guardar</button>
            </div>
        </form>
    </div>
</div>

<div id="modal-list" class="web-modal hidden">
    <div class="web-modal-backdrop" data-modal-close="modal-list"></div>
    <div class="web-modal-dialog">
        <div class="web-modal-header">
            <h3 class="web-modal-title" data-modal-title>Nueva lista</h3>
            <button type="button" class="web-icon-btn" data-modal-close="modal-list"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <form data-crud-form="list" class="web-form-grid">
            <div>
                <label class="web-label">Nombre</label>
                <input type="text" name="name" class="web-input" required maxlength="255">
            </div>
            <div>
                <label class="web-label">Estado</label>
                <select name="status" class="web-input">
                    <option value="active">Activa</option>
                    <option value="archived">Archivada</option>
                </select>
            </div>
            <div>
                <label class="web-label">Notas</label>
                <textarea name="notes" class="web-input" rows="3" maxlength="1000"></textarea>
            </div>
            <div class="web-modal-footer">
                <button type="button" class="btn-secondary" data-modal-close="modal-list">Cancelar</button>
                <button type="submit" class="btn-primary">Guardar</button>
            </div>
        </form>
    </div>
</div>

<div id="modal-product" class="web-modal hidden">
    <div class="web-modal-backdrop" data-modal-close="modal-product"></div>
    <div class="web-modal-dialog web-modal-dialog-lg">
        <div class="web-modal-header">
            <h3 class="web-modal-title" data-modal-title>Nuevo producto</h3>
            <button type="button" class="web-icon-btn" data-modal-close="modal-product"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <form data-crud-form="product" class="web-form-grid web-form-grid-2">
            <div style="grid-column: 1 / -1;">
                <label class="web-label">Nombre</label>
                <input type="text" name="name" class="web-input" required maxlength="255">
            </div>
            <div>
                <label class="web-label">Categoría</label>
                <select name="category_id" class="web-input">
                    <option value="">Sin categoría</option>
                    @foreach(($catalogCategories ?? []) as $category)
                        <option value="{{ $category->id }}">{{ $category->name }}</option>
                    @endforeach
                </select>
            </div>
            <div>
                <label class="web-label">Unidad</label>
                <select name="unit_id" class="web-input">
                    <option value="">Sin unidad</option>
                    @foreach(($catalogUnits ?? []) as $unit)
                        <option value="{{ $unit->id }}">{{ $unit->name }}</option>
                    @endforeach
                </select>
            </div>
            <div>
                <label class="web-label">Negocio</label>
                <select name="store_id" class="web-input">
                    <option value="">Sin negocio</option>
                    @foreach(($catalogStores ?? []) as $store)
                        <option value="{{ $store->id }}">{{ $store->name }}</option>
                    @endforeach
                </select>
            </div>
            <div>
                <label class="web-label">Precio</label>
                <input type="number" name="price" class="web-input" min="0" step="0.01">
            </div>
            <div class="web-modal-footer" style="grid-column: 1 / -1;">
                <button type="button" class="btn-secondary" data-modal-close="modal-product">Cancelar</button>
                <button type="submit" class="btn-primary">Guardar</button>
            </div>
        </form>
    </div>
</div>

<div id="modal-list-items" class="web-modal hidden">
    <div class="web-modal-backdrop" data-modal-close="modal-list-items"></div>
    <div class="web-modal-dialog web-modal-dialog-lg">
        <div class="web-modal-header">
            <h3 class="web-modal-title" id="list-items-title">Artículos</h3>
            <button type="button" class="web-icon-btn" data-modal-close="modal-list-items"><i class="fa-solid fa-xmark"></i></button>
        </div>

        <form id="list-item-form" class="web-form-grid web-form-grid-2" style="margin-bottom: 1.25rem; padding-bottom: 1.25rem; border-bottom: 1px solid var(--border);">
            <div style="grid-column: 1 / -1;">
                <label class="web-label">Artículo</label>
                <input type="text" name="name" class="web-input" required maxlength="255">
            </div>
            <div>
                <label class="web-label">Cantidad</label>
                <input type="number" name="quantity" class="web-input" min="0.01" step="0.01" value="1">
            </div>
            <div>
                <label class="web-label">Precio unitario</label>
                <input type="number" name="price" class="web-input" min="0" step="0.01">
            </div>
            <div>
                <label class="web-label">Unidad</label>
                <select name="unit_id" class="web-input">
                    <option value="">—</option>
                    @foreach(($catalogUnits ?? []) as $unit)
                        <option value="{{ $unit->id }}">{{ $unit->name }}</option>
                    @endforeach
                </select>
            </div>
            <div>
                <label class="web-label">Categoría</label>
                <select name="category_id" class="web-input">
                    <option value="">—</option>
                    @foreach(($catalogCategories ?? []) as $category)
                        <option value="{{ $category->id }}">{{ $category->name }}</option>
                    @endforeach
                </select>
            </div>
            <div style="display:flex; align-items:center; gap:0.5rem;">
                <input type="checkbox" name="is_checked" id="list-item-checked" value="1">
                <label for="list-item-checked" class="web-label" style="margin:0;">Comprado</label>
            </div>
            <div class="web-modal-footer" style="grid-column: 1 / -1;">
                <button type="submit" class="btn-primary">Guardar artículo</button>
            </div>
        </form>

        <div id="list-items-body"></div>
    </div>
</div>

<div id="modal-profile" class="web-modal hidden">
    <div class="web-modal-backdrop" data-modal-close="modal-profile"></div>
    <div class="web-modal-dialog">
        <div class="web-modal-header">
            <h3 class="web-modal-title">Mi perfil</h3>
            <button type="button" class="web-icon-btn" data-modal-close="modal-profile"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <form id="profile-form" class="web-form-grid">
            <div>
                <label class="web-label">Nombre</label>
                <input type="text" name="name" class="web-input" required maxlength="255">
            </div>
            <div class="web-modal-footer">
                <button type="button" class="btn-secondary" data-modal-close="modal-profile">Cancelar</button>
                <button type="submit" class="btn-primary">Guardar</button>
            </div>
        </form>
    </div>
</div>
