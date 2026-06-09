<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Support\TableActions;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;
use Yajra\DataTables\Facades\DataTables;

class CategoryController extends Controller
{
    public function index(): View
    {
        return view('categories.index');
    }

    public function getData(Request $request)
    {
        $categories = Category::query()->where('user_id', $request->user()->id);

        return DataTables::of($categories)
            ->addColumn('actions', function ($category) {
                return TableActions::crud('category', $category->id, $category->name);
            })
            ->rawColumns(['actions'])
            ->make(true);
    }

    public function show(Request $request, Category $category): JsonResponse
    {
        $this->authorizeOwner($request, $category);

        return response()->json(['data' => $category]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate(['name' => 'required|string|max:255']);

        $category = Category::create([
            ...$validated,
            'user_id' => $request->user()->id,
        ]);

        return response()->json([
            'message' => 'Categoría creada.',
            'data' => $category,
        ], 201);
    }

    public function update(Request $request, Category $category): JsonResponse
    {
        $this->authorizeOwner($request, $category);

        $validated = $request->validate(['name' => 'required|string|max:255']);
        $category->update($validated);

        return response()->json([
            'message' => 'Categoría actualizada.',
            'data' => $category,
        ]);
    }

    public function destroy(Request $request, Category $category): JsonResponse
    {
        $this->authorizeOwner($request, $category);
        $category->delete();

        return response()->json(['message' => 'Categoría eliminada.']);
    }

    private function authorizeOwner(Request $request, Category $category): void
    {
        abort_if($category->user_id !== $request->user()->id, 403);
    }
}
