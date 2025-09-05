@extends('layouts.app')

@section('title', 'Postagem')

@section('content')
    <div class="bg-white bg-opacity-5 p-6 rounded-lg backdrop-blur-md shadow-md">
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

        <h4 class="mt-6 text-xl font-semibold">Comentários</h4>

        @foreach($post->comments as $comment)
            <div class="bg-gray-700 p-2 rounded my-2">
                <strong>{{ $comment->user->name }}</strong>: {{ $comment->content }}
                <p class="text-xs text-gray-400">{{ $comment->created_at->diffForHumans() }}</p>
            </div>
        @endforeach
    </div>
@endsection
