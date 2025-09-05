<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class AdminController extends Controller
{
    public function dashboard()
    {
        $usersCount = 0;
        $postsCount = 0;
        $reportsCount = 0;

        return view('pages.admin.dashboard', compact('usersCount', 'postsCount', 'reportsCount'));
    }
}
