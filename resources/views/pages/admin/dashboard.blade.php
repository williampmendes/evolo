@extends('layouts.app')

@section('title', 'Painel Administrativo')

@section('content')
    <h2 class="text-3xl font-semibold mb-4">🛡️ Painel Administrativo</h2>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div class="bg-white bg-opacity-5 p-4 rounded shadow text-center">
            <h3 class="text-lg font-bold">Usuários</h3>
            <p>{{ $usersCount }} registrados</p>
            <a href="/admin/users" class="text-cyan-400 hover:underline">Gerenciar</a>
        </div>

        <div class="bg-white bg-opacity-5 p-4 rounded shadow text-center">
            <h3 class="text-lg font-bold">Postagens</h3>
            <p>{{ $postsCount }} postagens</p>
            <a href="/admin/posts" class="text-cyan-400 hover:underline">Moderador</a>
        </div>

        <div class="bg-white bg-opacity-5 p-4 rounded shadow text-center">
            <h3 class="text-lg font-bold">Denúncias</h3>
            <p>{{ $reportsCount }} pendentes</p>
            <a href="/admin/reports" class="text-cyan-400 hover:underline">Analisar</a>
        </div>
    </div>
@endsection
