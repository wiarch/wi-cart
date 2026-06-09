<?php

if (! function_exists('vasset')) {
    function vasset(string $path): string
    {
        $fullPath = public_path($path);

        if (! is_file($fullPath)) {
            return asset($path);
        }

        return asset($path).'?v='.filemtime($fullPath);
    }
}
