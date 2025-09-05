@extends('layouts.app')

@section('title', 'Mensagens')

@section('content')
    <h2 class="text-3xl font-semibold mb-4">💬 Mensagens</h2>

    <div class="flex">
        <aside class="w-1/3 bg-gray-800 p-4 rounded mr-4">
            <h3 class="text-lg font-bold mb-2">Conversas</h3>
            @foreach($conversations as $conversation)
                <a href="/chat?user={{ $conversation->user->id }}" class="block py-2 hover:bg-gray-700 rounded px-2">
                    {{ $conversation->user->name }}
                </a>
            @endforeach
        </aside>

        <section class="w-2/3 bg-gray-800 p-4 rounded">
            @if($activeConversation)
                <h4 class="text-xl font-bold mb-2">Conversando com {{ $activeConversation->user->name }}</h4>

                <div class="h-80 overflow-y-scroll bg-gray-900 p-2 rounded mb-4">
                    @foreach($activeConversation->messages as $message)
                        <div class="my-2">
                            <strong>{{ $message->user->name }}:</strong> {{ $message->content }}
                        </div>
                    @endforeach
                </div>

                <form action="/chat/send" method="POST" class="flex">
                    @csrf
                    <input type="hidden" name="user_id" value="{{ $activeConversation->user->id }}">
                    <input type="text" name="content" class="flex-grow p-2 rounded bg-gray-700 text-white" placeholder="Digite sua mensagem...">
                    <button type="submit" class="px-4 py-2 bg-cyan-500 rounded ml-2 hover:bg-cyan-600">Enviar</button>
                </form>
            @else
                <p>Selecione uma conversa para começar.</p>
            @endif
        </section>
    </div>
@endsection
