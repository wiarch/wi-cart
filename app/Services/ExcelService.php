<?php

namespace App\Services;

use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Facades\Excel;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\ToModel;
use Illuminate\Database\Eloquent\Model;

class ExcelService
{
    /**
     * Exportar datos dinámicos desde DB
     */
    public function downloadFromDB($connection, $table, array $selectColumns, array $headings, $fileName, array $where = [])
    {
        $export = new class ($connection, $table, $selectColumns, $headings, $where) implements FromCollection, WithHeadings {
            protected $connection, $table, $columns, $headings, $where;

            public function __construct($connection, $table, $columns, $headings, $where)
            {
                $this->connection = $connection;
                $this->table = $table;
                $this->columns = $columns;
                $this->headings = $headings;
                $this->where = $where;
            }

            public function collection()
            {
                $query = DB::connection($this->connection)->table($this->table)->select($this->columns);

                // Aplicar condiciones si existen
                foreach ($this->where as $column => $value) {
                    $query->where($column, $value);
                }

                $data = $query->get();

                // Si no hay datos, devolver una fila vacía para mantener encabezados
                if ($data->isEmpty()) {
                    $emptyRow = array_fill(0, count($this->columns), null);
                    return collect([$emptyRow]);
                }

                return $data;
            }

            public function headings(): array
            {
                return $this->headings;
            }
        };

        return Excel::download($export, $fileName);
    }

    public function downloadFromCollection($collection, array $headings, $fileName)
    {
        $export = new class ($collection, $headings) implements \Maatwebsite\Excel\Concerns\FromCollection, \Maatwebsite\Excel\Concerns\WithHeadings, \Maatwebsite\Excel\Concerns\WithStyles, \Maatwebsite\Excel\Concerns\ShouldAutoSize {
            protected $collection;
            protected $headings;

            public function __construct($collection, $headings)
            {
                $this->collection = $collection;
                $this->headings = $headings;
            }

            public function collection()
            {
                return $this->collection;
            }

            public function headings(): array
            {
                return $this->headings;
            }

            // Esta función se ejecuta si implementa WithStyles
            public function styles(\PhpOffice\PhpSpreadsheet\Worksheet\Worksheet $sheet)
            {
                return [
                    // fila 1 = encabezados
                    1 => [
                        'font' => [
                            'bold' => true,
                            'color' => ['rgb' => 'FFFFFF'],
                            'size' => 12,
                        ],
                        'fill' => [
                            'fillType' => \PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID,
                            'startColor' => ['rgb' => '4CAF50'],
                        ],
                        'alignment' => [
                            'horizontal' => \PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_CENTER,
                            'vertical' => \PhpOffice\PhpSpreadsheet\Style\Alignment::VERTICAL_CENTER,
                        ],
                    ],
                ];
            }
        };

        return Excel::download($export, $fileName);
    }

    /**
     * Importar datos dinámicos hacia DB
     */
    public function importToDB($connection, $table, $columns, $file)
    {
        $import = new class ($connection, $table, $columns) implements ToModel {
            protected $connection, $table, $columns;

            public function __construct($connection, $table, $columns)
            {
                $this->connection = $connection;
                $this->table = $table;
                $this->columns = $columns;
            }

            public function model(array $row)
            {
                $data = [];
                foreach ($this->columns as $index => $column) {
                    $data[$column] = $row[$index] ?? null;
                }

                // Validar que no exista el código antes de insertar
                $exists = DB::connection($this->connection)
                    ->table($this->table)
                    ->where('codigo', $data['codigo'] ?? '')
                    ->exists();

                if (!$exists && !empty($data['codigo'])) {
                    DB::connection($this->connection)->table($this->table)->insert($data);
                }

                return null; // No usa Eloquent
            }
        };

        return Excel::import($import, $file);
    }
}
