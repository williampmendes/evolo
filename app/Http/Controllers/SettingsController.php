<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class SettingsController extends Controller
{
    public function index()
    {
        return view('pages.settings');
    }

    public function update(Request $request)
    {
        // Atualizar configurações no futuro
        return back()->with('status', 'Configurações atualizadas!');
    }
}
