<?php

namespace App\Traits;

trait RuleArrayTrait
{
    /**
     * Genera reglas de validación para campos que pueden ser arrays o simples.
     *
     * @param string $key Nombre del campo en el request
     * @param array $rulesElemento Reglas para el valor simple (o para cada elemento si es array)
     * @param string $label Nombre amigable para mensajes
     * @param bool $esArray Indica si se espera un array o valor simple
     * @param int|null $size (Opcional) Si es array, valida que tenga exactamente este tamaño
     * @return array Arreglo de reglas para usar en validator
     */
    public function rulesArray(string $key, array $rulesElemento, string $label, bool $esArray = false, ?int $size = null): array
    {
        if ($esArray) {
            $rules = [
                $key => ['required', 'array'],
                "{$key}.*" => $rulesElemento,
            ];

            if ($size !== null) {
                $rules[$key][] = "size:{$size}";
            }

            return [
                $key => [
                    'json_key' => $key,
                    'rules' => $rules[$key],
                    'label' => $label,
                ],
                "{$key}.*" => [
                    'json_key' => "{$key}.*",
                    'rules' => $rules["{$key}.*"],
                    'label' => $label,
                ],
            ];
        } else {
            return [
                $key => [
                    'json_key' => $key,
                    'rules' => $rulesElemento,
                    'label' => $label,
                ],
            ];
        }
    }
}
