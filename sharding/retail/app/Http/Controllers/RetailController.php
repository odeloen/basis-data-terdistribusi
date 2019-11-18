<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Retail;

class RetailController extends Controller
{
    public function list($county){
        $retails = Retail::where('County', $county)->get();

        if ($retails->count() == 0) return response()->json(['message' => 'There is no record about this county']);
        return response()->json(['retails' => $retails]);
    }

    public function create(Request $request){        
        $this->validate($request, [
            'county' => 'required',
            'license_number' => 'required',
        ]);

        $retail = new Retail();
        $retail->County = $request->county;
        $retail->license_number = $request->license_number;
        $retail->save();

        return response()->json(['message' => 'success', 'retail' => $retail]);
    }

    public function update(Request $request){
        $this->validate($request, [
            'county' => 'required',
            'counties' => 'required',
        ]);

        $retails = $retails = Retail::where('County', $request->county)->get();

        if ($retails->count() == 0) return response()->json(['message' => 'There is no record about this county']);

        foreach ($retails as $retail) {
            $retail->Counties = $request->counties;
            $retail->save();
        }

        return response()->json(['message' => 'success']);
    }

    public function delete(Request  $request){
        $this->validate($request, [
            'county' => 'required'
        ]);

        $retails = $retails = Retail::where('County', $request->county)->get();

        if ($retails->count() == 0) return response()->json(['message' => 'There is no record about this county']);

        foreach ($retails as $retail) {
            $retail->delete();
        }

        return response()->json(['message' => 'success']);
    }

    public function count($county){
        $retailCount = Retail::where('County', $county)->count();

        if ($retailCount == 0) return response()->json(['message' => 'There is no record about this county']);
        return response()->json(['County Name' => $county, 'Retail Count' => $retailCount]);
    }

    public function counties(){
        $counties = Retail::distinct('County')->get();
        
        return response()->json(['County Count' => $counties->count() ,'County Names' => $counties]);
    }
}
