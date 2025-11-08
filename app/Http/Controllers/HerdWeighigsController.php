<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class HerdWeighigsController extends Controller
{
    public function index()
    {
        return view('herdWeighings.index');
    }
    public function calculateGDP($herdName)
    {
        $summaries = DB::table('herd_weighings')->where('herd_name', $herdName)
            ->orderBy('weighing_date')
            ->get();

        foreach ($summaries as $index => $current) {
            if ($index === 0) continue;

            $previous = $summaries[$index - 1];
            $days = $previous->weighing_date->diffInDays($current->weighing_date);

            $gdp = ($current->avg_weight - $previous->avg_weight) / $days;

            DB::table('herd_weighings')->where('id', $current->id)->update([
                'gdp' => $gdp,
                'days_diff' => $days,
                'previous_date' => $previous->weighing_date,
            ]);
        }
    }
}
