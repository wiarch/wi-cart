<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class ProductImageController extends Controller
{
    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'product_id' => ['required', 'uuid'],
            'image' => ['required', 'image', 'max:5120'],
            'client_updated_at' => ['required', 'date'],
        ]);

        /** @var Product|null $product */
        $product = Product::withTrashed()
            ->where('user_id', $request->user()->id)
            ->where('id', $data['product_id'])
            ->first();

        if (! $product) {
            return response()->json(['message' => 'Product not found'], 404);
        }

        $incomingAt = \Carbon\Carbon::parse($data['client_updated_at']);
        if ($product->client_updated_at && $product->client_updated_at->gt($incomingAt)) {
            return response()->json([
                'message' => 'lww_keep_server',
                'product' => $product,
            ], 409);
        }

        $ext = $request->file('image')->getClientOriginalExtension() ?: 'jpg';
        $path = $request->file('image')->storeAs(
            'products/'.$request->user()->id,
            $data['product_id'].'_'.Str::lower(Str::random(8)).'.'.$ext,
            'public'
        );

        if ($product->image_path) {
            Storage::disk('public')->delete($product->image_path);
        }

        $product->forceFill([
            'image_path' => $path,
            'image_pending' => false,
            'client_updated_at' => $incomingAt,
        ])->save();

        return response()->json([
            'product' => $product->fresh(),
            'url' => Storage::disk('public')->url($path),
        ]);
    }
}
