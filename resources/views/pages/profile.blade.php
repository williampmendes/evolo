@extends('layouts.app')

@section('title', 'Perfil de {{ $user->name }}')

@section('content')
    <div class="bg-white bg-opacity-5 p-6 rounded-lg backdrop-blur-md shadow-md">
        <div class="flex items-center">
            <img src="{{ $user->avatar_url }}" class="w-24 h-24 rounded-full mr-4">
            <div>
                <h2 class="text-2xl font-bold">{{ $user->name }}</h2>
                <p class="text-gray-400">{{ $user->bio }}</p>
            </div>
        </div>

        <div class="mt-4 flex gap-4">
            <a href="/friends" class="px-4 py-2 bg-cyan-500 rounded hover:bg-cyan-600">👥 Amigos</a>
            <a href="/chat?user={{ $user->id }}" class="px-4 py-2 bg-cyan-500 rounded hover:bg-cyan-600">💬 Enviar Mensagem</a>
        </div>

        <h3 class="mt-6 text-xl font-semibold">Postagens Recentes</h3>

        @foreach($user->posts as $post)
            <div class="bg-white bg-opacity-5 p-4 mt-2 rounded shadow">
                <p>{{ $post->content }}</p>
                <small class="text-gray-400">{{ $post->created_at->diffForHumans() }}</small>
            </div>
        @endforeach
    </div>
@endsection