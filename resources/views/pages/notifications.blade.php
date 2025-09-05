@extends('layouts.app')

@section('title', 'Notificações')

@section('content')
    <h2 class="text-3xl font-semibold mb-4">🔔 Suas Notificações</h2>

    <ul class="space-y-2">
        @forelse($notifications as $notification)
            <li class="bg-gray-800 p-3 rounded shadow">
                {{ $notification->content }}
                <p class="text-xs text-gray-400">{{ $notification->created_at->diffForHumans() }}</p>
            </li>
        @empty
            <li class="text-gray-400">Você não tem notificações no momento.</li>
        @endforelse
    </ul>
@endsection