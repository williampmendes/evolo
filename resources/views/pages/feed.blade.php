@extends('layouts.app')

@section('title', 'Feed')

@section('content')
    <h2 class="text-3xl font-semibold mb-6">📰 Seu Feed</h2>

    @foreach($posts as $post)
        <div class="bg-white bg-opacity-5 rounded-lg p-4 mb-4 backdrop-blur-md shadow-md">
            <div class="flex items-center mb-2">
                <img src="{{ $post->user->avatar_url }}" class="w-10 h-10 rounded-full mr-3">
                <div>
                    <strong>{{ $post->user->name }}</strong>
                    <p class="text-sm text-gray-400">{{ $post->created_at->diffForHumans() }}</p>
                </div>
            </div>
            <p class="text-gray-200">{{ $post->content }}</p>
            @if($post->image_url)
                <img src="{{ $post->image_url }}" class="rounded-lg mt-3 w-full max-h-96 object-cover">
            @endif
            <div class="mt-4 flex gap-4 text-gray-400">
                <button>👍 Curtir</button>
                <button>💬 Comentar</button>
                <button>↪️ Compartilhar</button>
            </div>
        </div>
    @endforeach
@endsection
