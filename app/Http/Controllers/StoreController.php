<?php

namespace App\Http\Controllers;

use App\Models\Store;
use App\Support\TableActions;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;
use Yajra\DataTables\Facades\DataTables;

class StoreController extends Controller
{
    public function index(): View
    {
        return view('stores.index');
    }

    public function getData(Request $request)
    {
        $stores = Store::query()->where('user_id', $request->user()->id);

        return DataTables::of($stores)
            ->addColumn('actions', function ($store) {
                return TableActions::crud('store', $store->id, $store->name, [
                    'location' => $store->location ?? '',
                    'contact' => $store->contact ?? '',
                ]);
            })
            ->rawColumns(['actions'])
            ->make(true);
    }

    public function show(Request $request, Store $store): JsonResponse
    {
        $this->authorizeOwner($request, $store);

        return response()->json(['data' => $store]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'location' => 'nullable|string|max:255',
            'contact' => 'nullable|string|max:255',
        ]);

        $store = Store::create([
            ...$validated,
            'user_id' => $request->user()->id,
        ]);

        return response()->json([
            'message' => 'Negocio creado.',
            'data' => $store,
        ], 201);
    }

    public function update(Request $request, Store $store): JsonResponse
    {
        $this->authorizeOwner($request, $store);

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'location' => 'nullable|string|max:255',
            'contact' => 'nullable|string|max:255',
        ]);
        $store->update($validated);

        return response()->json([
            'message' => 'Negocio actualizado.',
            'data' => $store,
        ]);
    }

    public function destroy(Request $request, Store $store): JsonResponse
    {
        $this->authorizeOwner($request, $store);
        $store->delete();

        return response()->json(['message' => 'Negocio eliminado.']);
    }

    private function authorizeOwner(Request $request, Store $store): void
    {
        abort_if($store->user_id !== $request->user()->id, 403);
    }
}
