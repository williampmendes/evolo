<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>@yield('title', 'Rede Social Futurista')</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    @vite(['resources/css/app.css', 'resources/js/app.js'])
</head>
<body class="bg-gray-900 text-white">
    <header class="bg-gray-800 shadow-lg p-4 flex justify-between items-center">
        <h1 class="text-2xl font-bold text-cyan-400">🌐 FuturoNet</h1>
        <nav>
            <a href="/feed" class="px-3 hover:text-cyan-300">Feed</a>
            <a href="/chat" class="px-3 hover:text-cyan-300">Chat</a>
            <a href="/groups" class="px-3 hover:text-cyan-300">Grupos</a>
            <a href="/settings" class="px-3 hover:text-cyan-300">Configurações</a>
        </nav>
    </header>

    <main class="p-6 max-w-7xl mx-auto">
        @yield('content')
    </main>

    <footer class="text-center text-sm text-gray-400 py-4 mt-6">
        © 2025 FuturoNet. Todos os direitos reservados.
    </footer>
</body>
</html>