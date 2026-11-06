<?php

namespace App\Http\Controllers;

use App\Services\ListShareService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ListShareController extends Controller
{
    public function __construct(private readonly ListShareService $share)
    {
    }

    public function store(Request $request, string $listId): JsonResponse
    {
        $data = $request->validate([
            'username' => ['required', 'string', 'min:3', 'max:32'],
        ]);

        $list = $this->share->share($request->user(), $listId, $data['username']);

        return response()->json([
            'ok' => true,
            'list_name' => $list->name,
        ]);
    }

    public function shareStore(Request $request, string $storeId): JsonResponse
    {
        $data = $request->validate([
            'username' => ['required', 'string', 'min:3', 'max:32'],
        ]);

        $store = $this->share->shareStore($request->user(), $storeId, $data['username']);

        return response()->json([
            'ok' => true,
            'store_name' => $store->name,
        ]);
    }
}
