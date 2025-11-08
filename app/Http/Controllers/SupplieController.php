<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Http\JsonResponse;

class SupplieController extends Controller
{
    public function index()
    {
        return view('supplies.index');
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'quantity' => ['required', 'integer', 'min:0'],
            'unit' => ['required', 'string', 'max:50'],
            'date' => ['required', 'date'],
            'batch_id' => ['required', 'string'],
        ]);

        DB::table('supplies')->insert([
            'id' => Str::uuid()->toString(),
            'name' => $data['name'],
            'quantity' => $data['quantity'],
            'unit' => $data['unit'],
            'date' => $data['date'],
            'batch_id' => $data['batch_id'],
            'user_id' => $request->session()->get('user')->id,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return response()->json([
            'title' => 'Insumo creado',
            'text' => 'El insumo se ha creado correctamente.'
        ]);
    }

    public function edit(string $id, Request $request)
    {
        $supply = DB::table('supplies')->where('id', $id)->first();
        if (!$supply) {
            return response()->json([
                'title' => 'Error',
                'error' => 'Registro no encontrado.',
            ], 404);
        }

        $batches = DB::connection('mysql_admin')->table('batches')->select('id', 'name')->get();

        $html = view('supplies.partials.modals.components.edit', compact('supply', 'batches'))->render();

        return response()->json([
            'html' => $html,
            'div' => '#edit_modal_content_supply',
        ]);
    }

    public function update(Request $request, string $id): JsonResponse
    {
        $data = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'quantity' => ['required', 'integer', 'min:0'],
            'unit' => ['required', 'string', 'max:50'],
            'date' => ['required', 'date'],
            'batch_id' => ['required', 'string'],
        ]);

        DB::table('supplies')->where('id', $id)->update([
            'name' => $data['name'],
            'quantity' => $data['quantity'],
            'unit' => $data['unit'],
            'date' => $data['date'],
            'batch_id' => $data['batch_id'],
            'updated_at' => now(),
        ]);

        return response()->json([
            'title' => 'Insumo actualizado',
            'text' => 'El insumo se ha actualizado correctamente.'
        ]);
    }

    public function destroy(string $id): JsonResponse
    {
        DB::table('supplies')->where('id', $id)->delete();

        return response()->json([
            'title' => 'Insumo eliminado',
            'text' => 'El insumo se ha eliminado correctamente.'
        ]);
    }

    public function getBatches(Request $request)
    {
        $id_user = $request->session()->get('user')->id;
        $batches = DB::connection('mysql_admin')->table('batches')->where('user_id', $id_user)->select('id', 'name')->orderBy('name', 'asc')->get();

        return response()->json([
            'batches' => $batches,
        ]);
    }
}
