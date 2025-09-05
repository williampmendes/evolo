<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>@yield('title', 'Bem-vindo à FuturoNet')</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    @vite(['resources/css/app.css', 'resources/js/app.js'])
</head>
<body class="bg-gray-900 text-white min-h-screen flex flex-col justify-center items-center">
    
    <main class="w-full max-w-2xl bg-white bg-opacity-5 p-8 rounded-lg backdrop-blur-md shadow-lg">
        @yield('content')
    </main>

    <footer class="text-center text-xs text-gray-400 py-4 mt-4">
        © 2025 FuturoNet. Todos os direitos reservados.
    </footer>

</body>
</html>
