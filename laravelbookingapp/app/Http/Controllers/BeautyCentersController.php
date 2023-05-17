<?php

namespace App\Http\Controllers;

use App\Models\Appointments;
use App\Models\Reviews;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\JsonResponse;

class BeautyCentersController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //get beauty center's appointment, customers and displat on dashboard
        $beautycenter = Auth::user();
        $appointment = Appointments::where('bc_id',$beautycenter->id)->where('status','upcoming')->get();
        $reviews = Reviews::where('bc_id',$beautycenter->id)->where('status','active')->get();

        //return all data to dashboard
        return view('dashboard')->with(['beautycenter'=>$beautycenter,'appointments'=>$appointment, 'reviews'=>$reviews]);
    }

    /**
     * Store a newly created resource in storage
     * 
     */
    public function store(Request $request): JsonResponse{
        //this controller is to store booking details post from mobile app
        $reviews = new Reviews();
        //this is to update to appointment status from "upcoming" to "complete"
        $appointment = Appointments::where('id',$request->get('appointment_id'))->first();

        //save the ratings and reviews for user
        $reviews->user_id=Auth::user()->id;
        $reviews->bc_id = $request->get('beautycenter_id');
        $reviews->ratings = $request->get('ratings');
        $reviews->reviews = $request->get('reviews');
        $reviews->reviewed_by=Auth::user()->name;
        $reviews->status='active';
        $reviews->save();

        //change appointment status
        $appointment->status = 'complete';
        $appointment->save();

        return response()->json([
            'success'=>'The appointment has been completed and reviewed successfully',
        ],200);
    }

    
}
