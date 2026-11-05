<?php

namespace App\Http\Controllers;

use App\Services\SyncService;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SyncController extends Controller
{
    /** @var list<string> */
    private const OP_RULE = ['required', 'in:create,update,delete,upsert'];

    public function __construct(private readonly SyncService $sync)
    {
    }

    /**
     * Unified bidirectional sync: apply client mutations then return server delta.
     * POST /api/sync
     */
    public function sync(Request $request): JsonResponse
    {
        $data = $request->validate([
            'device_id' => ['nullable', 'string', 'max:128'],
            'since' => ['nullable', 'date'],
            'mutations' => ['nullable', 'array', 'max:500'],
            'mutations.*.entity' => ['required', 'string'],
            'mutations.*.id' => ['required', 'uuid'],
            'mutations.*.op' => self::OP_RULE,
            'mutations.*.client_updated_at' => ['required', 'date'],
            'mutations.*.payload' => ['nullable', 'array'],
        ]);

        $mutations = $data['mutations'] ?? [];
        if ($mutations !== []) {
            $this->sync->assertKnownEntities($mutations);
        }

        $push = $mutations === []
            ? ['applied' => [], 'rejected' => []]
            : $this->sync->push(
                $request->user(),
                $data['device_id'] ?? null,
                $mutations,
            );

        $since = isset($data['since']) ? Carbon::parse($data['since']) : null;
        $pull = $this->sync->pull($request->user(), $since);

        return response()->json([
            'server_time' => $pull['server_time']->toISOString(),
            'applied' => $push['applied'],
            'rejected' => $push['rejected'],
            'changes' => $pull['changes'],
            'since' => $since?->toISOString(),
        ]);
    }

    public function push(Request $request): JsonResponse
    {
        $data = $request->validate([
            'device_id' => ['nullable', 'string', 'max:128'],
            'mutations' => ['required', 'array', 'max:500'],
            'mutations.*.entity' => ['required', 'string'],
            'mutations.*.id' => ['required', 'uuid'],
            'mutations.*.op' => self::OP_RULE,
            'mutations.*.client_updated_at' => ['required', 'date'],
            'mutations.*.payload' => ['nullable', 'array'],
        ]);

        $this->sync->assertKnownEntities($data['mutations']);

        $result = $this->sync->push(
            $request->user(),
            $data['device_id'] ?? null,
            $data['mutations'],
        );

        return response()->json([
            'server_time' => now()->toISOString(),
            'applied' => $result['applied'],
            'rejected' => $result['rejected'],
        ]);
    }

    public function pull(Request $request): JsonResponse
    {
        $data = $request->validate([
            'since' => ['nullable', 'date'],
        ]);

        $since = isset($data['since']) ? Carbon::parse($data['since']) : null;
        $result = $this->sync->pull($request->user(), $since);

        return response()->json([
            'server_time' => $result['server_time']->toISOString(),
            'since' => $since?->toISOString(),
            'changes' => $result['changes'],
        ]);
    }
}
