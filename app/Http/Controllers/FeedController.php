<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Post;
use Illuminate\Support\Facades\Auth;

class FeedController extends Controller
{
    public function index()
    {
        $user = Auth::user();

        // Obter IDs dos amigos aceitos
        $friendIds = $user->friends()->pluck('id')->toArray();

        // Incluir o próprio ID do usuário para ver suas postagens no feed
        $allRelevantUserIds = array_merge([$user->id], $friendIds);

        // Buscar os posts dos amigos ou seguidores e do próprio usuário
        $posts = Post::whereIn('user_id', $allRelevantUserIds)
                     ->with('user') // Carrega os dados do usuário que fez a postagem
                     ->latest() // Ordena pelas postagens mais recentes
                     ->paginate(10); // Paginação para melhor performance

        return view('pages.feed', compact('posts'));
    }
}
