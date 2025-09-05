<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Post;
use Illuminate\Support\Facades\Auth;

class PostController extends Controller
{
    public function show($id)
    {
        $post = Post::with(\'user\', \'comments.user\') // Carrega o usuário da postagem e o usuário de cada comentário
                      ->find($id);

        if (!$post) {
            abort(404); // Retorna um erro 404 se a postagem não for encontrada
        }

        return view(\'pages.post-view\', compact(\'post\'));
    }

    public function create()
    {
        return view(\'pages.post-create\');
    }

    public function store(Request $request)
    {
        $request->validate([
            \'content\' => \'required|string|max:255\',
            \'image\' => \'nullable|image|max:2048\', // Opcional: validação para imagem
        ]);

        $imagePath = null;
        if ($request->hasFile(\'image\')) {
            $imagePath = $request->file(\'image\')->store(\'posts\', \'public\');
        }

        Post::create([
            \'user_id\' => Auth::id(),
            \'content\' => $request->input(\'content\'),
            \'image_url\' => $imagePath,
        ]);

        return redirect(\'/feed\')->with(\'status\', \'Postagem criada com sucesso!\');
    }
}
