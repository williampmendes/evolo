@extends('layouts.app')

@section('title', 'Grupos')

@section('content')
    <h2 class="text-3xl font-semibold mb-4">🌐 Comunidades & Grupos</h2>

    <a href="/groups/create" class="mb-4 inline-block px-4 py-2 bg-cyan-500 rounded hover:bg-cyan-600">➕ Criar Novo Grupo</a>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        @foreach($groups as $group)
            <div class="bg-white bg-opacity-5 p-4 rounded backdrop-blur-md shadow-md">
                <h3 class="text-xl font-bold">{{ $group->name }}</h3>
                <p class="text-gray-300">{{ Str::limit($group->description, 100) }}</p>
                <a href="/groups/{{ $group->id }}" class="text-cyan-400 hover:underline mt-2 inline-block">Ver Grupo</a>
            </div>
        @endforeach
    </div>
@endsection
