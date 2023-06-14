<?php

namespace App\Http\Controllers;

use App\Models\Appointments;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\JsonResponse;
use App\Models\User;

class AppointmentsController extends Controller
{


    /**
     * Store a newly created resource in storage.
     *
     * @return \Illuminate\Http\Response
     */

    public function index(){
        //retrieve all appointments from the user
        $appointment = Appointments::where('user_id',Auth::user()->id)->get();
        $beautycenter = User::where('type','beautycenter')->get();

        //sorting appointment and beautycenter details
        //and get all related appointment 
        foreach($appointment as $data){
            foreach($beautycenter as $info){
                $details = $info->beautycenter;
                if($data['bc_id']==$info['id']){
                    $data['beautycenter_name']=$info['name'];
                    $data['beautycenter_profile']=$info['profile_photo_url'];
                    $data['category']=$details['category'];
                }
            }
        }
        return $appointment;
    }


    public function store(Request $request)
    {
        //this controller is to store booking details post from mobile app
        $appointment = new Appointments();
        $appointment -> user_id = Auth::user()->id;
        $appointment -> bc_id = $request->get('beautycenter_id');
        $appointment -> date = $request->get('date');
        $appointment -> day = $request->get('day');
        $appointment -> time = $request->get('time');
        $appointment -> status = 'upcoming'; //new appointment will be saves as 'upcoming' by default
        $appointment -> save();

        //if succesfully, return status code 200
        return response()->json([
            'success'=>'New Appointment has been made successfully',
        ], 200);
    }



}
