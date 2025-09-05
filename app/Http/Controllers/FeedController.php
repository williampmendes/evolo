<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class FeedController extends Controller
{
    public function index()
    {
        $posts = []; // Buscar os posts dos amigos ou seguidores
        return view('pages.feed', compact('posts'));
    }
}
