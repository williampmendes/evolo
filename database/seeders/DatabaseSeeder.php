<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Post;
use App\Models\Group;
use App\Models\Friendship;

class DatabaseSeeder extends Seeder
{
    public function run()
    {
        User::factory(10)->create()->each(function ($user) {
            Post::factory(3)->create(['user_id' => $user->id]);
            Group::factory(1)->create(['owner_id' => $user->id]);
        });

        // Criação de amizades entre usuários
        $users = User::all();
        foreach ($users as $user) {
            $friends = $users->random(2);
            foreach ($friends as $friend) {
                if ($user->id !== $friend->id) {
                    Friendship::factory()->create([
                        'user_id' => $user->id,
                        'friend_id' => $friend->id,
                        'status' => 'accepted',
                    ]);
                }
            }
        }
    }
}
