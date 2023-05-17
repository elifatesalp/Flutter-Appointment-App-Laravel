<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('beauty_centers', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('bc_id')->unique();
            $table->string('category')->nullable();
            $table->unsignedInteger('customers')->nullable();
            $table->unsignedInteger('experience')->nullable();
            $table->longText('bio_data')->nullable();
            $table->string('status')->nullable();
            //this is state that bc_id is refer to id on users table
            $table->foreign('bc_id')->references('id')->on('users')->onDelete('cascade');

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('beauty_centers');
    }
};
