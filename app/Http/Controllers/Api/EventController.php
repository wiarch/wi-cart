<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\Log;
use App\Models\Death;
use App\Models\Feeding;
use App\Models\Sanitary;
use App\Traits\CharIdTrait;
use Illuminate\Http\Request;

class EventController extends Controller
{
    use CharIdTrait;

    /**
     * Muestra una lista.
     */
    public function index() {}

    /**
     * Muestra la vista.
     */
    public function reproductions() {}

    /**
     * Muestra la vista.
     */
    public function sanitary(Request $request)
    {
        try {
            $sanitary = new Sanitary();
            $sanitary->id = $this->generateUniqueCharId('sanitary', 'id');
            $sanitary->user_id = $request->user->tokenable_id;

            if ($request->stock_id) {
                $stock = DB::connection('mysql_admin')
                    ->table('stocks')
                    ->where('id', $request->stock_id)
                    ->first();
                if ($stock) {
                    $sanitary->stock_id = $request->stock_id;
                    $sanitary->field_id = $stock->field_id;
                    $sanitary->rodeo_id = $stock->rodeo_id;
                }
            } else {
                $rodeo = DB::connection('mysql_admin')
                    ->table('rodeos')
                    ->where('id', $request->rodeo_id)
                    ->first();
                if ($rodeo) {
                    $sanitary->rodeo_id = $request->rodeo_id;
                    $sanitary->field_id = $rodeo->field_id;
                }
            }

            $sanitary->type_animal_id = $request->type_animal_id;
            $sanitary->treatment_code_id = $request->treatment_code_id;
            $sanitary->date = $request->date;
            $sanitary->type_sanitary = $request->type_sanitary;
            $sanitary->dose = $request->dose;
            $sanitary->serial_number = $request->serial_number;
            $sanitary->date_expiration = $request->date_expiration;
            $sanitary->mark = $request->mark;
            $sanitary->retirement = $request->retirement;
            $sanitary->diagnostic = $request->diagnostic;
            $sanitary->observation = $request->observation;
            $sanitary->created_at = now();
            $sanitary->updated_at = now();
            $sanitary->save();

            try {
                $codeId = $sanitary->treatment_code_id;
                $dose = (float) ($sanitary->dose ?? 0);
                if ($codeId && $dose > 0) {
                    $query = DB::table('food_supplies')->where('code_tratment_id', $codeId);
                    if (Schema::hasColumn('food_supplies', 'user_id')) {
                        $query->where('user_id', $sanitary->user_id);
                    }
                    $foodSupply = $query->orderByDesc('created_at')->first();
                    if ($foodSupply) {
                        $consumed = (float) ($foodSupply->consumed ?? 0);
                        $stockInit = (float) ($foodSupply->stock_init ?? 0);
                        $newConsumed = $consumed + $dose;
                        $newStockEnd = $stockInit - $newConsumed;
                        DB::table('food_supplies')
                            ->where('id', $foodSupply->id)
                            ->update([
                                'consumed' => $newConsumed,
                                'stock_end' => $newStockEnd,
                                'updated_at' => now(),
                            ]);
                    }
                }
            } catch (\Throwable $e) {
                Log::warning('API EventController - sanitary stock update failed: ' . $e->getMessage());
            }

            return response()->json(['message' => $sanitary], 200);
        } catch (\Throwable $e) {
            return response()->json(['message' => $e->getMessage()], 500);
        }
    }

    /**
     * Muestra la vista.
     */
    public function deaths(Request $request)
    {
        try {
            $stock = DB::connection('mysql_admin')
                ->table('stocks')
                ->where('id', $request->stock_id)
                ->first();

            $death = new Death();
            $death->id = $this->generateUniqueCharId('deaths', 'id');
            $death->user_id = $request->user->tokenable_id;
            $death->field_id = $stock->field_id;
            $death->rodeo_id = $stock->rodeo_id;
            $death->stock_id = $stock->id;
            $death->type_animal_id = $stock->type_animal_id;
            $death->type_death = $request->type_death;
            $death->date = $request->date;
            $death->guide_number = $request->guide_number;
            $death->date_sale = $request->date_sale;
            $death->diagnostic = $request->diagnostic;
            $death->observation = $request->observation;
            $death->created_at = now();
            $death->updated_at = now();
            $death->save();

            return response()->json(['message' => $death], 200);
        } catch (\Throwable $e) {
            return response()->json(['message' => $e->getMessage()], 500);
        }
    }

    /**
     * Muestra la vista.
     */
    public function feedings(Request $request)
    {
        try {
            $stock = DB::connection('mysql_admin')
                ->table('stocks')
                ->where('id', $request->stock_id)
                ->first();

            $feeding = new Feeding();
            $feeding->id = $this->generateUniqueCharId('feedings', 'id');
            $feeding->user_id = $request->user->tokenable_id;
            $feeding->rodeo_id = $stock->rodeo_id;
            $feeding->stock_id = $stock->id;
            $feeding->date = $request->date;
            $feeding->weight = $request->weight;
            $feeding->created_at = now();
            $feeding->updated_at = now();
            $feeding->save();

            return response()->json(['message' => $feeding], 200);
        } catch (\Throwable $e) {
            return response()->json(['message' => $e->getMessage()], 500);
        }
    }
}
