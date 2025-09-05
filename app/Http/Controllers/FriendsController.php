<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class FriendsController extends Controller
{
    public function index()
    {
        $friends = []; // Lista de amigos simulada
        return view('pages.friends', compact('friends'));
    }
}
