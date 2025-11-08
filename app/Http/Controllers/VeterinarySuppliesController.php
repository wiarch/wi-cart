<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\View;
use Illuminate\Support\Str;

class VeterinarySuppliesController extends Controller
{
    public function index()
    {
        return view('veterinarySupplies.index');
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'code_tratment_id' => 'required|uuid',
            'stock_init' => 'required|numeric|min:0',
            // 'stock_end' y 'consumed' no se muestran en el formulario actualmente
            // 'stock_end' => 'nullable|numeric|min:0',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Errores de validación',
                'errors' => $validator->errors(),
            ], 422);
        }

        $data = $validator->validated();
        $id = (string) Str::uuid();

        // Insert principal (selección simple). Si no viene stock_end, usar stock_init; consumed inicia en 0
        DB::table('food_supplies')->insert([
            'id' => $id,
            'code_tratment_id' => $data['code_tratment_id'],
            'stock_init' => $data['stock_init'],
            'stock_end' => $data['stock_init'], //$data['stock_end'] ?? $data['stock_init'],
            'consumed' => 0,
            'user_id' => $request->session()->get('user')->id,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return response()->json(['message' => 'Insumo veterinario creado con éxito']);
    }

    public function edit(string $id)
    {
        $record = DB::table('food_supplies')->where('id', $id)->first();
        if (!$record) {
            return response()->json(['message' => 'Registro no encontrado'], 404);
        }

        $html = View::make('veterinarySupplies.partials.modals.components.edit', [
            'veterinarySupply' => $record,
        ])->render();

        return response()->json([
            'div' => '#edit_modal_content_veterinary_supply',
            'html' => $html,
        ]);
    }

    public function update(Request $request, string $id)
    {
        $validator = Validator::make($request->all(), [
            'code_tratment_id' => 'required|uuid',
            'stock_init' => 'required|numeric|min:0',
            //'stock_end' => 'nullable|numeric|min:0',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Errores de validación',
                'errors' => $validator->errors(),
            ], 422);
        }

        $exists = DB::table('food_supplies')->where('id', $id)->exists();
        if (!$exists) {
            return response()->json(['message' => 'Registro no encontrado'], 404);
        }

        $data = $validator->validated();

        // Construir update sin tocar stock_end si no viene
        $update = [
            'code_tratment_id' => $data['code_tratment_id'],
            'stock_init' => $data['stock_init'],
            'updated_at' => now(),
        ];
        if (array_key_exists('stock_end', $data)) {
            $update['stock_end'] = $data['stock_end'];
        }

        DB::table('food_supplies')->where('id', $id)->update($update);

        return response()->json(['message' => 'Insumo veterinario actualizado con éxito']);
    }

    public function destroy(string $id)
    {
        DB::table('food_supplies')->where('id', $id)->delete();
        return response()->json(['message' => 'Insumo veterinario eliminado con éxito']);
    }
}
