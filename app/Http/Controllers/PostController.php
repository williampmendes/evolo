<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class PostController extends Controller
{
    public function show($id)
    {
        $post = (object)[
            'id' => $id,
            'content' => 'Conteúdo de exemplo.',
            'user' => (object)[
                'name' => 'Autor Exemplo',
                'avatar_url' => '/images/default-avatar.png'
            ],
            'created_at' => now(),
            'image_url' => null,
            'comments' => []
        ];

        return view('pages.post-view', compact('post'));
    }

    public function create()
    {
        return view('pages.post-create');
    }

    public function store(Request $request)
    {
        // Aqui futuramente salvará a postagem no banco
        return redirect('/feed')->with('status', 'Postagem criada com sucesso!');
    }
}
