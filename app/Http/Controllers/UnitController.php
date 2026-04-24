<?php

namespace App\Http\Controllers;

use App\Models\Unit;
use Illuminate\Http\Request;
use Yajra\DataTables\Facades\DataTables;

class UnitController extends Controller
{
    public function index()
    {
        return view('units.index');
    }

    public function getData()
    {
        $units = Unit::query();

        return DataTables::of($units)
            ->addColumn('actions', function ($unit) {
                return '
                    <div class="flex justify-center items-center gap-2">
                        <a href="' . route('units.edit', $unit) . '" class="p-2 rounded-xl hover:bg-surface-container-high transition-colors no-underline">
                            <i class="fa-solid fa-pen-to-square text-primary-important"></i>
                        </a>
                        <button type="button" onclick="confirmDelete(\'delete-form-' . $unit->id . '\', \'¿Deseas eliminar la unidad ' . $unit->name . '?\')" class="p-2 rounded-xl hover:bg-error/10 transition-colors border-none bg-transparent cursor-pointer">
                            <i class="fa-solid fa-trash-can text-error-important"></i>
                        </button>
                        <form id="delete-form-' . $unit->id . '" action="' . route('units.destroy', $unit) . '" method="POST" class="hidden">
                            ' . csrf_field() . '
                            ' . method_field('DELETE') . '
                        </form>
                    </div>';
            })
            ->rawColumns(['actions'])
            ->make(true);
    }

    public function create()
    {
        return view('units.create');
    }

    public function store(Request $request)
    {
        $request->validate(['name' => 'required|string|max:255']);
        Unit::create($request->all());

        return redirect()->route('units.index')->with('status', 'Unidad de medida creada con éxito.');
    }

    public function edit(Unit $unit)
    {
        return view('units.edit', compact('unit'));
    }

    public function update(Request $request, Unit $unit)
    {
        $request->validate(['name' => 'required|string|max:255']);
        $unit->update($request->all());

        return redirect()->route('units.index')->with('status', 'Unidad de medida actualizada con éxito.');
    }

    public function destroy(Unit $unit)
    {
        $unit->delete();
        return redirect()->route('units.index')->with('status', 'Unidad de medida eliminada con éxito.');
    }
}
