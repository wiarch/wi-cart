<script>
    (function($) {
        "use strict";

        // Spinner
        var spinner = function() {
            setTimeout(function() {
                if ($("#spinner").length > 0) {
                    $("#spinner").removeClass("show");
                }
            }, 1);
        };
        spinner();
    })(jQuery);

    // Función para sanitizar claves y evitar problemas con espacios o caracteres especiales
    function sanitizeKey(str) {
        return str
            .trim()
            .toLowerCase()
            .replace(/\s+/g, "_")
            .replace(/[^\w\-]+/g, "");
    }

    function validateRequiredFields($panel) {
        let isValid = true;
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        $panel
            .find("input.required, select.required, textarea.required")
            .each(function() {
                const $field = $(this);
                const value = $field.val();
                const type = $field.attr("type");

                let fieldIsValid = true;
                let message = "Este campo es requerido";

                if (!value || value.trim() === "") {
                    fieldIsValid = false;
                } else if (type === "email" && !emailRegex.test(value.trim())) {
                    fieldIsValid = false;
                    message = "Ingrese un correo electrónico válido";
                }

                // if (!fieldIsValid) {
                //     $field.addClass("is-invalid").attr({
                //         "data-bs-toggle": "tooltip",
                //         "data-bs-placement": "top",
                //         title: message,
                //     });
                //     new bootstrap.Tooltip($field[0]);
                //     isValid = false;
                // } else {
                //     $field.removeClass("is-invalid").removeAttr("data-bs-toggle data-bs-placement title");
                //     if ($field[0]._tooltip) $field[0]._tooltip.dispose();
                // }
            });

        return isValid;
    }

    function markInputWithError(fieldName) {
        const match = fieldName.match(/^(\w+)\.(\d+)$/);

        if (match) {
            const baseName = match[1];
            const index = parseInt(match[2], 10);

            // Busca primero con array name="baseName[]"
            let elements = Array.from(document.querySelectorAll(
                `input[name="${baseName}[]"], select[name="${baseName}[]"]`
            )).filter(el => el.offsetParent !== null);

            // Si no hay elementos con array, busca sin array name="baseName"
            if (elements.length === 0) {
                elements = Array.from(document.querySelectorAll(
                    `input[name="${baseName}"], select[name="${baseName}"]`
                )).filter(el => el.offsetParent !== null);
            }


            if (elements.length > 0) {
                if (index >= 0 && index < elements.length) {
                    addInvalidClass(elements[index]);
                } else {
                    console.warn(`Índice ${index} fuera de rango para elementos con name="${baseName}"`);
                }
            } else {
                console.warn(`No se encontraron elementos visibles para name="${baseName}"`);
            }

        } else {
            // Para campos simples (sin índice)
            let elements = Array.from(document.querySelectorAll(
                `input[name="${fieldName}[]"], select[name="${fieldName}[]"]`
            )).filter(el => el.offsetParent !== null);

            // Si no hay con array, busca sin array
            if (elements.length === 0) {
                elements = Array.from(document.querySelectorAll(
                    `input[name="${fieldName}"], select[name="${fieldName}"]`
                )).filter(el => el.offsetParent !== null);
            }

            if (elements.length > 0) {
                addInvalidClass(elements[0]);
            } else {
                console.warn(`No se encontró elemento visible para name="${fieldName}"`);
            }
        }

        function addInvalidClass(element) {
            element.classList.add('is-invalid');
            // Si es select2, agrega clase al contenedor visual
            if (element.classList.contains('select2-hidden-accessible')) {
                const container = element.nextElementSibling;
                if (container && container.classList.contains('select2-container')) {
                    const selection = container.querySelector('.select2-selection');
                    if (selection) {
                        selection.classList.add('is-invalid');
                    }
                }
            }
        }
    }

    /**
     * Resetea un formulario dinámico dentro de un modal, incluyendo Select2.
     *
     * @param {string} modalSelector - Selector del modal (ej: '#editModal')
     * @param {string} formSelector - Selector del formulario dentro del modal (ej: '#editForm')
     */
    function resetDynamicModalForm(modalSelector, formSelector) {
        const $form = $(formSelector);

        // Resetea el formulario nativo
        if ($form.length) {
            $form[0].reset();
        }

        // Limpiar todos los select2 dentro del formulario
        $form.find('select').each(function() {
            if ($(this).hasClass('select2-hidden-accessible')) {
                $(this).val(null).trigger('change'); // limpia el select2
            }
        });

        // Cierra el modal si existe
        $(modalSelector).modal('hide');
    }


    function formPostAjax(id, route, table = null, modal = null, edit = false) {
        const formElement = document.querySelector(id);
        const formData = new FormData(formElement);

        $.ajax({
            url: formElement.action != null ? formElement.action : route,
            method: 'POST',
            headers: (function() {
                const h = {
                    'Accept': 'application/json'
                };
                if (edit) h['X-HTTP-Method-Override'] = 'PUT';
                return h;
            })(),
            data: formData,
            contentType: false,
            processData: false,

            beforeSend: function() {
                // Mostrar spinner
                $('#spinner').removeClass('hide');
                $('#spinner').addClass('show');
            },

            success: function(data) {

                // Ocultar spinner
                $('#spinner').removeClass('show');
                $('#spinner').addClass('hide');

                document.querySelectorAll('.is-invalid').forEach(el => el.classList.remove('is-invalid'));

                if (data.errors) {
                    for (const fieldName in data.errors) {
                        if (data.errors.hasOwnProperty(fieldName)) {
                            markInputWithError(fieldName);
                        }
                    }
                }

                if (data.error) {
                    dinamicSweetAlert(data.title, data.error, 'error');
                    return;
                }

                dinamicSweetAlert(data.title, data.text, 'success');

                if (data.reload === true) {
                    return setTimeout(() => window.location.reload(), 4000);
                }

                if (table) {
                    $(table).DataTable().ajax.reload();
                }

                if (modal) {
                    resetDynamicModalForm(modal, id);
                }

                if (data.redirect) {
                    return setTimeout(() => window.location.href = data.redirect, 1000);
                }
            },

            error: function(xhr) {

                // Ocultar spinner
                $('#spinner').removeClass('show');
                $('#spinner').addClass('hide');

                // Limpia marcas previas
                document.querySelectorAll('.is-invalid').forEach(el => el.classList.remove('is-invalid'));

                // Manejo específico de validación Laravel (422)
                if (xhr.status === 422 && xhr.responseJSON && xhr.responseJSON.errors) {
                    const errors = xhr.responseJSON.errors;
                    const messages = [];

                    for (const fieldName in errors) {
                        if (!errors.hasOwnProperty(fieldName)) continue;
                        // Marcar campo con error
                        markInputWithError(fieldName);
                        // Acumular mensajes
                        const arr = Array.isArray(errors[fieldName]) ? errors[fieldName] : [errors[
                            fieldName]];
                        arr.forEach(msg => {
                            if (msg) messages.push(msg);
                        });
                    }

                    const summary = messages.length ? messages.join('<br>') : (xhr.responseJSON.message ||
                        'Datos inválidos.');
                    dinamicSweetAlert('Error de validación', summary, 'error');
                    return;
                }

                // Otros errores
                const message = (xhr.responseJSON && xhr.responseJSON.message) ? xhr.responseJSON.message :
                    'Ocurrió un problema al procesar la solicitud.';
                dinamicSweetAlert('Error', message, 'error');
            },

            complete: function() {
                // Ocultar spinner
                $('#spinner').removeClass('show');
                $('#spinner').addClass('hide');
            }
        });
    }

    function formGetAjax(route_get, route_post = null, form = null, btn = null, table = null, modal = null,
        extraDataStr = {}) {

        // 🔹 Procesar parámetro extraData de forma segura
        let extraData = {};
        if (extraDataStr && typeof extraDataStr === 'string') {
            try {
                extraData = JSON.parse(decodeURIComponent(extraDataStr));
            } catch (e) {
                console.warn('Error al parsear extraDataStr:', e, extraDataStr);
            }
        } else if (typeof extraDataStr === 'object' && extraDataStr !== null) {
            extraData = extraDataStr;
        }

        // 🔹 Mostrar indicador de carga (opcional)
        const $btn = $(btn);
        const originalText = $btn.html();
        if ($btn.length) {
            $btn.prop('disabled', true).html('<i class="fa fa-spinner fa-spin"></i> Cargando...');
        }

        $.ajax({
            url: route_get,
            method: 'GET',
            data: extraData,
            success: function(response) {
                // Verifica si el servidor devolvió el formato esperado
                if (response && response.div && response.html) {
                    $(response.div).html(response.html);

                    if (form != null) {
                        convertPlaceholdersToFloatingLabels(form);

                        // Asigna dinámicamente el evento para enviar el formulario
                        $(btn).attr('onclick',
                            `formPostAjax('${form}', '${route_post}', '${table}', '${modal}', true)`
                        );
                        $(form).attr('action', route_post);
                    }
                } else {
                    console.warn('Respuesta inesperada del servidor:', response);
                    dinamicSweetAlert('Error', 'La respuesta del servidor no tiene el formato esperado.',
                        'error');
                }
            },
            error: function(xhr) {
                let message = 'Ocurrió un problema al procesar la solicitud.';
                if (xhr.responseJSON && xhr.responseJSON.message) {
                    message = xhr.responseJSON.message;
                }
                dinamicSweetAlert('Error de red', message, 'error');
            },
            complete: function() {
                // 🔹 Restaurar botón
                if ($btn.length) {
                    $btn.prop('disabled', false).html(originalText);
                }
            }
        });
    }


    async function formDeleteAjax(route, table = null, extraData = {}) {
        const confirmed = await dinamicSweetAlert(
            '¿Desea eliminar este registro?',
            'Esta acción no se puede deshacer',
            'warning',
            null,
            null,
            null,
            true
        );

        if (!confirmed.isConfirmed) return;

        $.ajax({
            url: route,
            method: 'POST',
            data: extraData,
            headers: {
                'X-HTTP-Method-Override': 'DELETE',
                'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            },
            success: function(data) {
                if (data.error) {
                    dinamicSweetAlert(data.title, data.error, 'error');
                    return;
                }

                dinamicSweetAlert(data.title, data.text, 'success');

                if (data.reload === true) {
                    setTimeout(() => window.location.reload(), 2000);
                    return;
                }

                if (table) {
                    $(table).DataTable().ajax.reload();
                }
            },
            error: function() {
                dinamicSweetAlert('Error de red', 'Ocurrió un problema al procesar la solicitud.',
                    'error');
            }
        });
    }

    function convertPlaceholdersToFloatingLabels(scope = document) {
        $(scope).find('input[placeholder]').each(function() {
            const $input = $(this);

            // Evitar aplicar dos veces
            if ($input.parent('.floating-wrapper').length) return;

            // Si el input tiene la clase 'label_none', no hacer nada
            if ($input.hasClass('label_none')) {
                return;
            }

            const placeholder = $input.attr('placeholder');
            $input.removeAttr('placeholder');

            // Envolver input y agregar label flotante
            $input.wrap('<div class="floating-wrapper" style="margin-bottom: 1.5rem;"></div>');
            $input.addClass('floating-input');
            $input.after(`<label class="floating-label">${placeholder}</label>`);

            // Si el input ya tiene valor, mantener label arriba
            if ($input.val().trim() !== '') {
                $input.addClass('not-empty');
            }

            // Eventos para activar/desactivar estado flotante
            $input.on('input change', function() {
                $(this).toggleClass('not-empty', $(this).val().trim() !== '');
            });
        });
    }

    convertPlaceholdersToFloatingLabels('.page-inner');

    function routeReplaceId(route, id, idName = '::id::') {
        return route.replace(idName, id);
    }

    // Función que maneja los checkboxes y acumula IDs
    let selectedIds = [];


    function handleCheckboxClick(checkbox, targetInputSelector, btn = null) {

        const input = $(checkbox);
        const id = input.data('id');

        if (input.is(':checked')) {
            if (!selectedIds.includes(id)) selectedIds.push(id);
        } else {
            selectedIds = selectedIds.filter(item => item !== id);
        }

        // Mostrar/ocultar botón
        if (btn) {
            if (selectedIds.length === 0) $(btn).addClass('d-none');
            else $(btn).removeClass('d-none');
        }

        // Actualiza el input hidden con el array
        const targetInput = $(targetInputSelector);
        if (targetInput.length) {
            targetInput.val(selectedIds); // Mantiene un array que luego se envía como string separado por comas
        }
    }
</script>
