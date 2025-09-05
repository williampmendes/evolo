<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class NotificationsController extends Controller
{
    public function index()
    {
        $notifications = []; // Notificações simuladas
        return view('pages.notifications', compact('notifications'));
    }
}
