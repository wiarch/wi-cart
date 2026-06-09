<?php

namespace App\Http\Controllers;

use App\Models\Unit;
use App\Support\TableActions;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;
use Yajra\DataTables\Facades\DataTables;

class UnitController extends Controller
{
    public function index(): View
    {
        return view('units.index');
    }

    public function getData(Request $request)
    {
        $units = Unit::query()->where('user_id', $request->user()->id);

        return DataTables::of($units)
            ->addColumn('actions', function ($unit) {
                return TableActions::crud('unit', $unit->id, $unit->name);
            })
            ->rawColumns(['actions'])
            ->make(true);
    }

    public function show(Request $request, Unit $unit): JsonResponse
    {
        $this->authorizeOwner($request, $unit);

        return response()->json(['data' => $unit]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate(['name' => 'required|string|max:255']);

        $unit = Unit::create([
            ...$validated,
            'user_id' => $request->user()->id,
        ]);

        return response()->json([
            'message' => 'Unidad creada.',
            'data' => $unit,
        ], 201);
    }

    public function update(Request $request, Unit $unit): JsonResponse
    {
        $this->authorizeOwner($request, $unit);

        $validated = $request->validate(['name' => 'required|string|max:255']);
        $unit->update($validated);

        return response()->json([
            'message' => 'Unidad actualizada.',
            'data' => $unit,
        ]);
    }

    public function destroy(Request $request, Unit $unit): JsonResponse
    {
        $this->authorizeOwner($request, $unit);
        $unit->delete();

        return response()->json(['message' => 'Unidad eliminada.']);
    }

    private function authorizeOwner(Request $request, Unit $unit): void
    {
        abort_if($unit->user_id !== $request->user()->id, 403);
    }
}
