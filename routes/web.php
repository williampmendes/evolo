use Illuminate\Support\Facades\Route;
use App\Http\Controllers\{
    FeedController, ProfileController, PostController, ChatController,
    FriendsController, GroupsController, NotificationsController,
    SettingsController, AdminController, TermsController, PrivacyController
};

// Página Inicial
Route::get('/', function () {
    return view('welcome');
});

// Feed
Route::get('/feed', [FeedController::class, 'index'])->middleware('auth');

// Perfil de Usuário
Route::get('/user/{username}', [ProfileController::class, 'show'])->middleware('auth');

// Postagem
Route::get('/post/{id}', [PostController::class, 'show'])->middleware('auth');
Route::get('/post/create', [PostController::class, 'create'])->middleware('auth');
Route::post('/post', [PostController::class, 'store'])->middleware('auth');

// Chat / Mensagens
Route::get('/chat', [ChatController::class, 'index'])->middleware('auth');
Route::post('/chat/send', [ChatController::class, 'send'])->middleware('auth');

// Amigos
Route::get('/friends', [FriendsController::class, 'index'])->middleware('auth');

// Grupos / Comunidades
Route::get('/groups', [GroupsController::class, 'index'])->middleware('auth');
Route::get('/groups/{id}', [GroupsController::class, 'show'])->middleware('auth');
Route::get('/groups/create', [GroupsController::class, 'create'])->middleware('auth');
Route::post('/groups', [GroupsController::class, 'store'])->middleware('auth');

// Notificações
Route::get('/notifications', [NotificationsController::class, 'index'])->middleware('auth');

// Configurações
Route::get('/settings', [SettingsController::class, 'index'])->middleware('auth');
Route::post('/settings/update', [SettingsController::class, 'update'])->middleware('auth');

// Admin (Área Administrativa)
Route::get('/admin', [AdminController::class, 'dashboard'])->middleware(['auth', 'can:admin']);

// Termos e Política
Route::get('/terms', [TermsController::class, 'show']);
Route::get('/privacy', [PrivacyController::class, 'show']);
