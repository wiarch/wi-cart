<?php

namespace App\Traits;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;


trait ValidateFormTrait
{
    public function validateFormInput(Request $request, array $validationData, ?string $title = null): JsonResponse|RedirectResponse|null
    {
        $rules = [];
        $messages = [];
        $attributes = [];

        foreach ($validationData as $field => $definition) {
            $keyInRequest = $definition['json_key'] ?? $field;

            $ruleArray = [];
            if (isset($definition['rules'])) {
                $ruleArray = is_array($definition['rules']) ? $definition['rules'] : explode('|', $definition['rules']);
            }

            $rules[$keyInRequest] = $ruleArray;

            if (isset($definition['messages']) && is_array($definition['messages'])) {
                foreach ($definition['messages'] as $rule => $msg) {
                    $messages["{$keyInRequest}.{$rule}"] = $msg;
                }
            }

            $attributes[$keyInRequest] = $definition['label'] ?? $field;
        }

        $validator = Validator::make($request->all(), $rules, $messages, $attributes);

        if ($validator->fails()) {
            $errorsByField = $validator->errors()->messages();
            $firstError = count($errorsByField) > 0 ? array_values($errorsByField)[0][0] : 'Error de validación';

            return response()->json([
                'title' => $title ?? 'Validación fallida',
                'error' => $firstError,
                'errors' => $errorsByField,
            ]);
        }

        return null;
    }
}
