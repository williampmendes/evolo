<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>@yield('title', 'Rede Social Futurista')</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    @vite(['resources/css/app.css', 'resources/js/app.js'])
</head>
<body>
    <header class="main-header">
        <h1 class="logo">🌐 FuturoNet</h1>
        <nav>
            <a href="/feed" class="nav-link">Feed</a>
            <a href="/chat" class="nav-link">Chat</a>
            <a href="/groups" class="nav-link">Grupos</a>
            <a href="/settings" class="nav-link">Configurações</a>
        </nav>
    </header>

    <main class="container">
        @yield('content')
    </main>

    <footer class="main-footer">
        © 2025 FuturoNet. Todos os direitos reservados.
    </footer>
</body>
</html>