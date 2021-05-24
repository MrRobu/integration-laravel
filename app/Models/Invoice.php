<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Invoice extends Model
{
    use HasFactory;

    public $primaryKey = 'invoice_id';

    public $table = 'invoice';

    public $timestamps = false;

    protected $dates = [
        'invoice_date',
    ];

    public function prescriptions(): HasMany
    {
        return $this->hasMany(Prescription::class, 'invoice_invoice_id', 'invoice_id');
    }
}
