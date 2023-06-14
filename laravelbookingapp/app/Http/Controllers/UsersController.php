<?php

namespace App\Http\Controllers;

#use Dotenv\Exception\ValidationException;
use App\Models\Appointments;
use App\Models\UserDetails;
use Illuminate\Validation\ValidationException;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Models\User;
use App\Models\BeautyCenter;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\JsonResponse;

class UsersController extends Controller
{
    /**
     * Display a listing of the resource 
     * @return \Illuminate\Http\Response
     */
    public function index() : Response{
        $user = array(); //this will return a set of user and beauty center data 
        $user = Auth::user();
        $beautycenter = User::where('type','beautycenter')->get();
        $details = $user->user_details;
        $beautycenterData = BeautyCenter::all();
        //return today appointment together with user data
        //this is the date format without leading 
        $date = now()->format('n/j/Y'); //n/j/Y yerine d/m/Y olucak. change date format to suit the format in database

        //make this appointment filter only status is "upcoming"
        $appointment = Appointments::where('status','upcoming')->where('date',$date)->first(); //add status filter

        //collect user data and all beautycenter details
        foreach($beautycenterData as $data){
            //sorting beauty center name and beauty center details
            foreach($beautycenter as $info){
                if($data['bc_id']==$info['id']){
                    $data['beautycenter_name']=$info['name'];
                    $data['beautycenter_profile']=$info['profile_photo_url'];
                    if(isset($appointment) && $appointment['bc_id'] == $info['id']){
                        $data['appointments'] = $appointment;
                    }
                }
            }
        }
        $user['beautycenter'] = $beautycenterData;
        $user['details'] = $details; //return user details here together with beautycenter list
        return new Response ($user); //return all data
    }

    public function login(Request $request)
    {
        //create a controller to handle income request
        //and return some data
        //validate incoming inputs
        $request -> validate([
            'email'=>'required|email',
            'password'=>'required',
        ]);
        //check matching user
        $user = User::where('email', $request->email)->first();

        //check password
        if(!$user || ! Hash::check($request->password, $user->password)){
            throw ValidationException::withMessages([
                'email'=> ['The provided credentials are incorrect'],
            ]);
        }
        //then return generated token
        return $user->createToken($request->email)->plainTextToken;
    }

    /**
     * register.
     *
     * @return \Illuminate\Http\Response
     */
    public function register(Request $request)
    {
        //validate incoming inputs
        $request->validate([
            'name'=>'required|string',
            'email'=>'required|email',
            'password'=>'required',
        ]);

        $user = User::create([
            'name'=>$request->name,
            'email'=>$request->email,
            'type'=>'user',
            'password'=>Hash::make($request->password),
        ]);

        $userInfo = UserDetails::create([
            'user_id'=>$user->id,
            'status'=>'active',
        ]);

        return $user;
    }

    /**
     * logout
     * @return \Illuminate\Http\Response
     */
    public function logout() : JsonResponse{
        $user=Auth::user();
        $user->currentAccessToken()->delete();

        return response()->json([
            'success'=>'Logout succesfully',
        ],200);
    }


        /**
     * update favorite beautycenter list
     * 
     */
    public function storeFavBc(Request $request): JsonResponse{

        $saveFav = UserDetails::where('user_id',Auth::user()->id)->first();
        $bcList = json_encode($request->get('favList'));
        //update fav list into database
        $saveFav->fav = $bcList; //and remember update this as well
        $saveFav->save();

        return response()->json([
            'success'=>'The favorite list is updated',
        ],200);
    }
}
