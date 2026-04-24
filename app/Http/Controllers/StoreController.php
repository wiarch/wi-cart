<?php

namespace App\Http\Controllers;

use App\Models\Store;
use Illuminate\Http\Request;
use Yajra\DataTables\Facades\DataTables;

class StoreController extends Controller
{
    public function index()
    {
        return view('stores.index');
    }

    public function getData()
    {
        $stores = Store::query();

        return DataTables::of($stores)
            ->addColumn('actions', function ($store) {
                return '
                    <div class="flex justify-center items-center gap-2">
                        <a href="' . route('stores.edit', $store) . '" class="p-2 rounded-xl hover:bg-surface-container-high transition-colors no-underline">
                            <i class="fa-solid fa-pen-to-square text-primary-important"></i>
                        </a>
                        <button type="button" onclick="confirmDelete(\'delete-form-' . $store->id . '\', \'¿Deseas eliminar el negocio ' . $store->name . '?\')" class="p-2 rounded-xl hover:bg-error/10 transition-colors border-none bg-transparent cursor-pointer">
                            <i class="fa-solid fa-trash-can text-error-important"></i>
                        </button>
                        <form id="delete-form-' . $store->id . '" action="' . route('stores.destroy', $store) . '" method="POST" class="hidden">
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
        return view('stores.create');
    }

    public function store(Request $request)
    {
        $request->validate(['name' => 'required|string|max:255']);
        Store::create($request->all());

        return redirect()->route('stores.index')->with('status', 'Negocio creado con éxito.');
    }

    public function edit(Store $store)
    {
        return view('stores.edit', compact('store'));
    }

    public function update(Request $request, Store $store)
    {
        $request->validate(['name' => 'required|string|max:255']);
        $store->update($request->all());

        return redirect()->route('stores.index')->with('status', 'Negocio actualizado con éxito.');
    }

    public function destroy(Store $store)
    {
        $store->delete();
        return redirect()->route('stores.index')->with('status', 'Negocio eliminado con éxito.');
    }
}
