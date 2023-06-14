<?php

use App\Http\Controllers\AppointmentsController;
use App\Http\Controllers\BeautyCentersController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UsersController;

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

//this is the endpoint with prefix /api
Route::post('/login', [UsersController::class,'login']);
Route::post('/register',[UsersController::class,'register']);

Route::middleware('auth:sanctum')->group(function(){
    Route::get('/user',[UsersController::class,'index']);
    Route::post('/fav',[UsersController::class,'storeFavBc']);
    Route::post('/logout',[UsersController::class, 'logout']);
    Route::post('/book',[AppointmentsController::class,'store']);
    Route::post('/reviews',[BeautyCentersController::class,'store']);
    Route::get('/appointments',[AppointmentsController::class,'index']);
    
});

