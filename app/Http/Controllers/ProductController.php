<?php

namespace App\Http\Controllers;

use App\Models\Product;
use App\Support\TableActions;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;
use Yajra\DataTables\Facades\DataTables;

class ProductController extends Controller
{
    public function index(Request $request): View
    {
        $userId = $request->user()->id;

        return view('products.index', [
            'categories' => $request->user()->categories()->orderBy('name')->get(),
            'units' => $request->user()->units()->orderBy('name')->get(),
            'stores' => $request->user()->stores()->orderBy('name')->get(),
        ]);
    }

    public function getData(Request $request)
    {
        $products = Product::query()
            ->where('user_id', $request->user()->id)
            ->with(['category', 'unit', 'store']);

        return DataTables::of($products)
            ->addColumn('category_name', fn ($product) => $product->category?->name ?? '—')
            ->addColumn('unit_name', fn ($product) => $product->unit?->name ?? '—')
            ->addColumn('store_name', fn ($product) => $product->store?->name ?? '—')
            ->editColumn('price', fn ($product) => $product->price !== null ? number_format((float) $product->price, 2) : '—')
            ->addColumn('actions', function ($product) {
                return TableActions::crud('product', $product->id, $product->name);
            })
            ->rawColumns(['actions'])
            ->make(true);
    }

    public function show(Request $request, Product $product): JsonResponse
    {
        $this->authorizeOwner($request, $product);

        return response()->json(['data' => $product->load(['category', 'unit', 'store'])]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $this->validated($request);

        $product = Product::create([
            ...$validated,
            'user_id' => $request->user()->id,
        ]);

        return response()->json([
            'message' => 'Producto creado.',
            'data' => $product->load(['category', 'unit', 'store']),
        ], 201);
    }

    public function update(Request $request, Product $product): JsonResponse
    {
        $this->authorizeOwner($request, $product);

        $validated = $this->validated($request);
        $product->update($validated);

        return response()->json([
            'message' => 'Producto actualizado.',
            'data' => $product->load(['category', 'unit', 'store']),
        ]);
    }

    public function destroy(Request $request, Product $product): JsonResponse
    {
        $this->authorizeOwner($request, $product);
        $product->delete();

        return response()->json(['message' => 'Producto eliminado.']);
    }

    private function validated(Request $request): array
    {
        return $request->validate([
            'name' => 'required|string|max:255',
            'category_id' => 'nullable|exists:categories,id',
            'unit_id' => 'nullable|exists:units,id',
            'store_id' => 'nullable|exists:stores,id',
            'price' => 'nullable|numeric|min:0',
        ]);
    }

    private function authorizeOwner(Request $request, Product $product): void
    {
        abort_if($product->user_id !== $request->user()->id, 403);
    }
}
