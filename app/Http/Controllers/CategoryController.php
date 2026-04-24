<?php

namespace App\Http\Controllers;

use App\Models\Category;
use Illuminate\Http\Request;
use Yajra\DataTables\Facades\DataTables;

class CategoryController extends Controller
{
    public function index()
    {
        return view('categories.index');
    }

    public function getData()
    {
        $categories = Category::query();

        return DataTables::of($categories)
            ->addColumn('actions', function ($category) {
                return '
                    <div class="flex justify-center items-center gap-2">
                        <a href="' . route('categories.edit', $category) . '" class="p-2 rounded-xl hover:bg-surface-container-high transition-colors no-underline">
                            <i class="fa-solid fa-pen-to-square text-primary-important"></i>
                        </a>
                        <button type="button" onclick="confirmDelete(\'delete-form-' . $category->id . '\', \'¿Deseas eliminar la categoría ' . $category->name . '?\')" class="p-2 rounded-xl hover:bg-error/10 transition-colors border-none bg-transparent cursor-pointer">
                            <i class="fa-solid fa-trash-can text-error-important"></i>
                        </button>
                        <form id="delete-form-' . $category->id . '" action="' . route('categories.destroy', $category) . '" method="POST" class="hidden">
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
        return view('categories.create');
    }

    public function store(Request $request)
    {
        $request->validate(['name' => 'required|string|max:255']);
        Category::create($request->all());

        return redirect()->route('categories.index')->with('status', 'Categoría creada con éxito.');
    }

    public function edit(Category $category)
    {
        return view('categories.edit', compact('category'));
    }

    public function update(Request $request, Category $category)
    {
        $request->validate(['name' => 'required|string|max:255']);
        $category->update($request->all());

        return redirect()->route('categories.index')->with('status', 'Categoría actualizada con éxito.');
    }

    public function destroy(Category $category)
    {
        $category->delete();
        return redirect()->route('categories.index')->with('status', 'Categoría eliminada con éxito.');
    }
}
