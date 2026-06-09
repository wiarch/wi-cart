<?php

namespace App\Support;

class TableActions
{
    public static function crud(string $entity, int $id, string $name, array $extra = []): string
    {
        $extraAttrs = '';
        foreach ($extra as $key => $value) {
            $extraAttrs .= ' data-'.$key.'="'.e($value).'"';
        }

        return '
            <div class="web-table-actions">
                <button type="button" data-crud-edit="'.$entity.'" data-id="'.$id.'" data-name="'.e($name).'"'.$extraAttrs.' class="web-table-action web-table-action-edit" title="Editar">
                    <i class="fa-solid fa-pen"></i>
                    <span class="web-table-action-text">Editar</span>
                </button>
                <button type="button" data-crud-delete="'.$entity.'" data-id="'.$id.'" data-name="'.e($name).'" class="web-table-action web-table-action-delete" title="Eliminar">
                    <i class="fa-solid fa-trash-can"></i>
                    <span class="web-table-action-text">Eliminar</span>
                </button>
            </div>';
    }

    public static function list(string $entity, int $id, string $name, array $extra = []): string
    {
        $extraAttrs = '';
        foreach ($extra as $key => $value) {
            $extraAttrs .= ' data-'.$key.'="'.e($value).'"';
        }

        return '
            <div class="web-table-actions">
                <button type="button" data-list-items="'.$id.'" data-name="'.e($name).'" class="web-table-action web-table-action-view" title="Artículos">
                    <i class="fa-solid fa-list"></i>
                    <span class="web-table-action-text">Artículos</span>
                </button>
                <button type="button" data-crud-edit="'.$entity.'" data-id="'.$id.'" data-name="'.e($name).'"'.$extraAttrs.' class="web-table-action web-table-action-edit" title="Editar">
                    <i class="fa-solid fa-pen"></i>
                    <span class="web-table-action-text">Editar</span>
                </button>
                <button type="button" data-crud-delete="'.$entity.'" data-id="'.$id.'" data-name="'.e($name).'" class="web-table-action web-table-action-delete" title="Eliminar">
                    <i class="fa-solid fa-trash-can"></i>
                    <span class="web-table-action-text">Eliminar</span>
                </button>
            </div>';
    }
}
