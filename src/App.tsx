import { useState, useEffect } from 'react';
import { Header } from './components/Header';
import { Timer } from './components/Timer';
import { Garden } from './components/Garden';
import { ProgressTracker } from './components/ProgressTracker';
import { Settings } from './components/Settings';
import { Statistics } from './components/Statistics';

export interface TimerSettings {
  focusTime: number;
  breakTime: number;
  longBreakTime: number;
  soundEnabled: boolean;
}

export interface DailyRecord {
  date: string;
  pomodoros: number;
  focusMinutes: number;
}

export interface Progress {
  totalPomodoros: number;
  todayPomodoros: number;
  currentStreak: number;
  trees: number;
  clouds: number;
  animals: string[];
  history: DailyRecord[];
}

export default function App() {
  const [settings, setSettings] = useState<TimerSettings>({
    focusTime: 25,
    breakTime: 5,
    longBreakTime: 15,
    soundEnabled: true,
  });

  const [progress, setProgress] = useState<Progress>({
    totalPomodoros: 0,
    todayPomodoros: 0,
    currentStreak: 0,
    trees: 0,
    clouds: 0,
    animals: [],
    history: [],
  });

  const [showSettings, setShowSettings] = useState(false);
  const [showStatistics, setShowStatistics] = useState(false);
  const [lastCompletionDate, setLastCompletionDate] = useState<string | null>(null);

  // Load from localStorage on mount
  useEffect(() => {
    const savedSettings = localStorage.getItem('focusGardenSettings');
    const savedProgress = localStorage.getItem('focusGardenProgress');
    const savedDate = localStorage.getItem('focusGardenLastDate');

    if (savedSettings) {
      setSettings(JSON.parse(savedSettings));
    }
    if (savedProgress) {
      const loadedProgress = JSON.parse(savedProgress);
      // Ensure history exists
      if (!loadedProgress.history) {
        loadedProgress.history = [];
      }
      setProgress(loadedProgress);
    }
    if (savedDate) {
      setLastCompletionDate(savedDate);
    }

    // Reset today's count if it's a new day
    const today = new Date().toDateString();
    if (savedDate !== today) {
      setProgress(prev => ({ ...prev, todayPomodoros: 0 }));
    }
  }, []);

  // Save to localStorage whenever progress or settings change
  useEffect(() => {
    localStorage.setItem('focusGardenSettings', JSON.stringify(settings));
  }, [settings]);

  useEffect(() => {
    localStorage.setItem('focusGardenProgress', JSON.stringify(progress));
  }, [progress]);

  const handlePomodoroComplete = () => {
    const today = new Date().toDateString();
    const todayISO = new Date().toISOString().split('T')[0];
    const yesterday = new Date(Date.now() - 86400000).toDateString();

    setProgress(prev => {
      const newProgress = {
        ...prev,
        totalPomodoros: prev.totalPomodoros + 1,
        todayPomodoros: prev.todayPomodoros + 1,
        currentStreak: lastCompletionDate === yesterday || lastCompletionDate === today 
          ? prev.currentStreak + 1 
          : 1,
      };

      // Update history
      const history = [...prev.history];
      const todayRecord = history.find(r => r.date === todayISO);
      
      if (todayRecord) {
        todayRecord.pomodoros += 1;
        todayRecord.focusMinutes += settings.focusTime;
      } else {
        history.push({
          date: todayISO,
          pomodoros: 1,
          focusMinutes: settings.focusTime,
        });
      }
      
      newProgress.history = history;

      // Add trees every Pomodoro
      if (newProgress.totalPomodoros % 1 === 0) {
        newProgress.trees = prev.trees + 1;
      }

      // Add clouds every 2 Pomodoros
      if (newProgress.totalPomodoros % 2 === 0) {
        newProgress.clouds = prev.clouds + 1;
      }

      // Unlock animals at milestones
      const animalMilestones = [
        { count: 3, animal: 'butterfly' },
        { count: 7, animal: 'bird' },
        { count: 15, animal: 'rabbit' },
        { count: 25, animal: 'deer' },
        { count: 40, animal: 'fox' },
      ];

      const newAnimals = [...prev.animals];
      animalMilestones.forEach(milestone => {
        if (newProgress.totalPomodoros === milestone.count && !newAnimals.includes(milestone.animal)) {
          newAnimals.push(milestone.animal);
        }
      });
      newProgress.animals = newAnimals;

      return newProgress;
    });

    setLastCompletionDate(today);
    localStorage.setItem('focusGardenLastDate', today);

    // Play completion sound
    if (settings.soundEnabled) {
      const audio = new Audio('data:audio/wav;base64,UklGRnoGAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YQoGAACBhYqFbF1fdJivrJBhNjVgodDbq2EcBj+a2/LDciUFLIHO8tiJNwgZaLvt559NEAxQp+PwtmMcBjiR1/LMeSwFJHfH8N2QQAoUXrTp66hVFApGn+DyvmwhBTGH0fPTgjMGHm7A7+OZUA0PVqzn77BdGAg+ltryxnMnBSl+zPLaizsIGGS57OihUg0NUqjj8bllHgU2jdXzyn0vBSh9y/HajDkHFGO56+mjUg0OUavk8bllHgU1jNTzy34wBSh8y/HaizgHFWO56+mjUg0NUKrk8bllHgU1jNTzy38wBSh8y/HajDgHFWO56+mjUg0NUKrk8bllHgU1jNTzy38wBSh8y/HajDgHFWO56+mjUg0NUKrk8bllHgU1jNTzy34wBSh8y/HajDgHFWO56+mjUg0NUKrk8bllHgU1jNTzy38wBSh8y/HajDgHFWO56+mjUg0NUKrk8bllHgU1jNTzy38wBSh8y/HajDgHFWO56+mjUg0NUKrk8Q==');
      audio.play().catch(() => {});
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-[#f5f3f0] via-[#faf9f7] to-[#e8f5f1] flex flex-col">
      <Header 
        onSettingsClick={() => setShowSettings(true)}
        onStatisticsClick={() => setShowStatistics(true)}
      />
      
      {!showStatistics ? (
        <main className="flex-1 container mx-auto px-4 py-8 flex flex-col lg:flex-row gap-8 max-w-7xl">
          {/* Left section - Timer and Progress */}
          <div className="flex-1 flex flex-col gap-6">
            <Timer 
              settings={settings}
              onComplete={handlePomodoroComplete}
            />
            <ProgressTracker progress={progress} />
          </div>

          {/* Right section - Garden */}
          <div className="flex-1">
            <Garden progress={progress} />
          </div>
        </main>
      ) : (
        <Statistics 
          progress={progress}
          onClose={() => setShowStatistics(false)}
        />
      )}

      {showSettings && (
        <Settings
          settings={settings}
          onSettingsChange={setSettings}
          onClose={() => setShowSettings(false)}
        />
      )}
    </div>
  );
}
