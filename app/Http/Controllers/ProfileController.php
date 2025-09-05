<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ProfileController extends Controller
{
    public function show($username)
    {
        $user = (object)[
            'username' => $username,
            'name' => 'Usuário Exemplo',
            'avatar_url' => '/images/default-avatar.png',
            'bio' => 'Esta é uma bio de exemplo.',
            'posts' => []
        ];
        return view('pages.profile', compact('user'));
    }
}
