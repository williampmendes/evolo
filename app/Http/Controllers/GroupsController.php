<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class GroupsController extends Controller
{
    public function index()
    {
        $groups = []; // Lista de grupos simulada
        return view('pages.groups', compact('groups'));
    }

    public function show($id)
    {
        $group = (object)[
            'id' => $id,
            'name' => 'Grupo Exemplo',
            'description' => 'Descrição do grupo exemplo.'
        ];
        return view('pages.groups-show', compact('group')); // Crie essa view se quiser ver um grupo individual
    }

    public function create()
    {
        return view('pages.groups-create'); // Crie essa view se quiser um formulário de criação
    }

    public function store(Request $request)
    {
        // Salvar o grupo no futuro
        return redirect('/groups')->with('status', 'Grupo criado com sucesso!');
    }
}
