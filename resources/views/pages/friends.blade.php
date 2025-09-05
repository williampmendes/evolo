@extends('layouts.app')

@section('title', 'Amigos')

@section('content')
    <h2 class="text-3xl font-semibold mb-4">👥 Meus Amigos</h2>

    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
        @foreach($friends as $friend)
            <div class="bg-white bg-opacity-5 p-4 rounded backdrop-blur-md shadow-md text-center">
                <img src="{{ $friend->avatar_url }}" class="w-16 h-16 rounded-full mx-auto mb-2">
                <p class="font-bold">{{ $friend->name }}</p>
                <a href="/user/{{ $friend->username }}" class="text-cyan-400 hover:underline">Ver Perfil</a>
            </div>
        @endforeach
    </div>
@endsection
