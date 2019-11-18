<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Retail;

class RetailController extends Controller
{
    public function list(){
        $retails = Retail::where('County', 'Albany')->get();

        return response()->json(['retails' => $retails]);
    }
}
