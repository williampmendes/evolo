@extends('layouts.app')

@section('title', 'Criar Nova Postagem')

@section('content')
    <h2 class="text-3xl font-semibold mb-4">📝 Nova Postagem</h2>

    <form action="/post" method="POST" enctype="multipart/form-data" class="bg-white bg-opacity-5 p-6 rounded shadow-md">
        @csrf
        <textarea name="content" rows="5" class="w-full p-2 rounded bg-gray-800 text-white mb-4" placeholder="Compartilhe seus pensamentos..."></textarea>

        <input type="file" name="image" class="block mb-4">

        <button type="submit" class="px-4 py-2 bg-cyan-500 rounded hover:bg-cyan-600">📤 Publicar</button>
    </form>
@endsection
