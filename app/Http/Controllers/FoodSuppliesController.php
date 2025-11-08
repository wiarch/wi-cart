<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\View;
use Illuminate\Support\Str;

class FoodSuppliesController extends Controller
{
    public function index()
    {
        return view('foodSupplies.index');
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'code_tratment_id' => 'required|uuid',
            'stock_init' => 'required|numeric|min:0',
            'stock_end' => 'required|numeric|min:0',
            'consumed' => 'required|numeric|min:0',
            'batch_id' => 'required|uuid',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Errores de validación',
                'errors' => $validator->errors(),
            ], 422);
        }

        $data = $validator->validated();
        $data['id'] = (string) Str::uuid();
        $data['created_at'] = now();
        $data['updated_at'] = now();

        DB::table('food_supplies')->insert($data);

        return response()->json(['message' => 'Insumo alimentario creado con éxito']);
    }

    public function edit(string $id)
    {
        $foodSupply = DB::table('food_supplies')->where('id', $id)->first();
        if (!$foodSupply) {
            return response()->json(['message' => 'Registro no encontrado'], 404);
        }

        // Obtener lotes
        $batches = DB::connection('mysql_admin')->table('batches')->get();

        $html = View::make('foodSupplies.partials.modals.components.edit', [
            'foodSupply' => $foodSupply,
            'batches' => $batches,
        ])->render();

        return response()->json([
            'div' => '#edit_modal_content_food_supply',
            'html' => $html,
        ]);
    }

    public function update(Request $request, string $id)
    {
        $validator = Validator::make($request->all(), [
            'code_tratment_id' => 'required|uuid',
            'stock_init' => 'required|numeric|min:0',
            'stock_end' => 'required|numeric|min:0',
            'consumed' => 'required|numeric|min:0',
            'batch_id' => 'required|uuid',
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

        DB::table('food_supplies')->where('id', $id)->update([
            'code_tratment_id' => $request->code_tratment_id,
            'stock_init' => $request->stock_init,
            'stock_end' => $request->stock_end,
            'consumed' => $request->consumed,
            'batch_id' => $request->batch_id,
            'updated_at' => now(),
        ]);

        return response()->json(['message' => 'Insumo alimentario actualizado con éxito']);
    }

    public function destroy(string $id)
    {
        DB::table('food_supplies')->where('id', $id)->delete();
        return response()->json(['message' => 'Insumo alimentario eliminado con éxito']);
    }
}
