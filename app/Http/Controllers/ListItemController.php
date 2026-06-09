<?php

namespace App\Http\Controllers;

use App\Models\ListItem;
use App\Models\ShoppingList;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ListItemController extends Controller
{
    public function index(Request $request, ShoppingList $list): JsonResponse
    {
        $this->authorizeList($request, $list);

        $items = $list->items()->with(['category', 'unit'])->orderBy('name')->get();

        return response()->json(['data' => $items]);
    }

    public function store(Request $request, ShoppingList $list): JsonResponse
    {
        $this->authorizeList($request, $list);

        $validated = $this->validated($request);

        $item = $list->items()->create($validated);
        $list->touch();

        return response()->json([
            'message' => 'Artículo agregado.',
            'data' => $item->load(['category', 'unit']),
        ], 201);
    }

    public function update(Request $request, ShoppingList $list, ListItem $item): JsonResponse
    {
        $this->authorizeList($request, $list);
        abort_if($item->shopping_list_id !== $list->id, 404);

        $validated = $this->validated($request);
        $item->update($validated);
        $list->touch();

        return response()->json([
            'message' => 'Artículo actualizado.',
            'data' => $item->load(['category', 'unit']),
        ]);
    }

    public function destroy(Request $request, ShoppingList $list, ListItem $item): JsonResponse
    {
        $this->authorizeList($request, $list);
        abort_if($item->shopping_list_id !== $list->id, 404);

        $item->delete();
        $list->touch();

        return response()->json(['message' => 'Artículo eliminado.']);
    }

    private function validated(Request $request): array
    {
        return $request->validate([
            'name' => 'required|string|max:255',
            'quantity' => 'nullable|numeric|min:0.01',
            'unit_id' => 'nullable|exists:units,id',
            'category_id' => 'nullable|exists:categories,id',
            'price' => 'nullable|numeric|min:0',
            'is_checked' => 'nullable|boolean',
        ]);
    }

    private function authorizeList(Request $request, ShoppingList $list): void
    {
        abort_if($list->user_id !== $request->user()->id, 403);
    }
}
