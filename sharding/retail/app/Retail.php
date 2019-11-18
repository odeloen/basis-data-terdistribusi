<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Jenssegers\Mongodb\Eloquent\Model as Eloquent;

class Retail extends Eloquent
{
    //
    protected $connection = 'mongodb';
    protected $collection = 'retail';    

    protected $fillable = [
        'county', 'license_number'
    ];
}
