@extends('layouts.app')

@section('title', 'Configurações')

@section('content')
    <h2 class="text-3xl font-semibold mb-4">⚙️ Configurações da Conta</h2>

    <form action="/settings/update" method="POST" class="space-y-4 bg-white bg-opacity-5 p-6 rounded shadow-md">
        @csrf
        <div>
            <label>Nome</label>
            <input type="text" name="name" value="{{ auth()->user()->name }}" class="w-full p-2 rounded bg-gray-800 text-white">
        </div>

        <div>
            <label>Biografia</label>
            <textarea name="bio" rows="3" class="w-full p-2 rounded bg-gray-800 text-white">{{ auth()->user()->bio }}</textarea>
        </div>

        <div>
            <label>Modo Escuro</label>
            <select name="theme" class="w-full p-2 rounded bg-gray-800 text-white">
                <option value="dark" selected>Escuro</option>
                <option value="light">Claro</option>
            </select>
        </div>

        <button type="submit" class="px-4 py-2 bg-cyan-500 rounded hover:bg-cyan-600">💾 Salvar Alterações</button>
    </form>
@endsection
