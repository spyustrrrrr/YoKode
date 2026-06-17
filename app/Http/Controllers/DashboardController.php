<?php

namespace App\Http\Controllers;

use App\Models\Lesson;
use App\Models\UserProgress;
use App\Models\UserQuest;        // TAMBAHKAN INI
use App\Models\UserHeart;        // TAMBAHKAN INI (opsional)
use App\Models\UserStreak;       // TAMBAHKAN INI (opsional)
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class DashboardController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        
        // Trigger streak check
        $streak = $user->streak;
        
        // Create daily quests if not exists
        $user->createDailyQuests();
        
        // Ambil daily quests hari ini - PASTIKAN MENGGUNAKAN MODEL YANG BENAR
        $dailyQuests = UserQuest::where('user_id', $user->id)
            ->where('date', now()->toDateString())
            ->with('dailyQuest')
            ->get();
        
        $completedQuests = $dailyQuests->where('completed', true)->count();
        $totalQuests = $dailyQuests->count();
        
        // Ambil achievements terbaru
        $recentAchievements = $user->achievements()
            ->orderBy('user_achievements.earned_at', 'desc')
            ->limit(3)
            ->get();
        
        $lessons = Lesson::orderBy('order_number')->get();
        
        $completedLessons = UserProgress::where('user_id', $user->id)
            ->where('completed', true)
            ->pluck('lesson_id')
            ->toArray();
        
        $totalLessons = $lessons->count();
        $completedCount = count($completedLessons);
        $progressPercentage = $totalLessons > 0 ? round(($completedCount / $totalLessons) * 100) : 0;
        
        $currentLevel = $user->level;
        $currentExp = $user->total_exp;
        $expToNextLevel = $user->exp_to_next_level;
        $levelProgress = $user->level_progress;
        
        return view('dashboard', compact(
            'lessons',
            'completedLessons',
            'totalLessons',
            'completedCount',
            'progressPercentage',
            'currentLevel',
            'currentExp',
            'expToNextLevel',
            'levelProgress',
            'streak',
            'dailyQuests',
            'completedQuests',
            'totalQuests',
            'recentAchievements'
        ));
    }
}