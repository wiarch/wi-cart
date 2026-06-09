<?php

namespace App\Http\Controllers;

use App\Models\ShoppingList;
use App\Support\TableActions;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;
use Yajra\DataTables\Facades\DataTables;

class ShoppingListController extends Controller
{
    public function index(Request $request): View
    {
        return view('lists.index', [
            'categories' => $request->user()->categories()->orderBy('name')->get(),
            'units' => $request->user()->units()->orderBy('name')->get(),
        ]);
    }

    public function getData(Request $request)
    {
        $lists = ShoppingList::query()
            ->where('user_id', $request->user()->id)
            ->withCount(['items', 'items as pending_items_count' => fn ($q) => $q->where('is_checked', false)]);

        return DataTables::of($lists)
            ->editColumn('status', function ($list) {
                $label = $list->status === 'archived' ? 'Archivada' : 'Activa';
                $class = $list->status === 'archived' ? 'web-table-badge web-table-badge-muted' : 'web-table-badge web-table-badge-success';

                return '<span class="'.$class.'">'.$label.'</span>';
            })
            ->editColumn('updated_at', fn ($list) => $list->updated_at?->format('d/m/Y H:i') ?? '—')
            ->addColumn('actions', function ($list) {
                return TableActions::list('list', $list->id, $list->name, [
                    'status' => $list->status,
                    'notes' => $list->notes ?? '',
                ]);
            })
            ->rawColumns(['status', 'actions'])
            ->make(true);
    }

    public function show(Request $request, ShoppingList $list): JsonResponse
    {
        $this->authorizeOwner($request, $list);

        return response()->json(['data' => $list->loadCount('items')]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $this->validated($request);

        $list = ShoppingList::create([
            ...$validated,
            'user_id' => $request->user()->id,
        ]);

        return response()->json([
            'message' => 'Lista creada.',
            'data' => $list,
        ], 201);
    }

    public function update(Request $request, ShoppingList $list): JsonResponse
    {
        $this->authorizeOwner($request, $list);

        $validated = $this->validated($request);
        $list->update($validated);

        return response()->json([
            'message' => 'Lista actualizada.',
            'data' => $list,
        ]);
    }

    public function destroy(Request $request, ShoppingList $list): JsonResponse
    {
        $this->authorizeOwner($request, $list);
        $list->delete();

        return response()->json(['message' => 'Lista eliminada.']);
    }

    private function validated(Request $request): array
    {
        return $request->validate([
            'name' => 'required|string|max:255',
            'status' => 'required|in:active,archived',
            'notes' => 'nullable|string|max:1000',
        ]);
    }

    private function authorizeOwner(Request $request, ShoppingList $list): void
    {
        abort_if($list->user_id !== $request->user()->id, 403);
    }
}
