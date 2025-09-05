<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ChatController extends Controller
{
    public function index(Request $request)
    {
        $conversations = [];
        $activeConversation = null;

        if ($request->has('user')) {
            $activeConversation = (object)[
                'user' => (object)['id' => $request->user, 'name' => 'Contato Exemplo'],
                'messages' => []
            ];
        }

        return view('pages.chat', compact('conversations', 'activeConversation'));
    }

    public function send(Request $request)
    {
        // Aqui futuramente será salvo a mensagem
        return back()->with('status', 'Mensagem enviada!');
    }
}

