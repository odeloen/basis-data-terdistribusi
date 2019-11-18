<?php

use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::get('/retails/{county}', 'RetailController@list');
Route::get('/retails/{county}/count', 'RetailController@count');
Route::post('/retails/create', 'RetailController@create');
Route::post('/retails/update', 'RetailController@update');
Route::post('/retails/delete', 'RetailController@delete');

Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});
