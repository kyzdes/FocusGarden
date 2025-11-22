import { Flame, Target, Trophy, Sparkles } from 'lucide-react';
import { motion } from 'motion/react';
import type { Progress } from '../App';

interface ProgressTrackerProps {
  progress: Progress;
}

export function ProgressTracker({ progress }: ProgressTrackerProps) {
  const achievements = [
    { name: 'Butterfly', unlocked: progress.animals.includes('butterfly'), milestone: 3 },
    { name: 'Bird', unlocked: progress.animals.includes('bird'), milestone: 7 },
    { name: 'Rabbit', unlocked: progress.animals.includes('rabbit'), milestone: 15 },
    { name: 'Deer', unlocked: progress.animals.includes('deer'), milestone: 25 },
    { name: 'Fox', unlocked: progress.animals.includes('fox'), milestone: 40 },
  ];

  return (
    <div className="bg-white rounded-3xl shadow-[8px_8px_24px_rgba(0,0,0,0.06),-8px_-8px_24px_rgba(255,255,255,0.9)] p-6">
      <h3 className="text-[#2d3748] mb-6">Your Progress</h3>

      {/* Stats Grid */}
      <div className="grid grid-cols-3 gap-4 mb-6">
        <motion.div
          whileHover={{ scale: 1.05 }}
          className="bg-gradient-to-br from-[#fff7ed] to-[#fed7aa] rounded-2xl p-4 text-center"
        >
          <div className="w-10 h-10 rounded-full bg-white mx-auto mb-2 flex items-center justify-center">
            <Flame className="w-5 h-5 text-[#f97316]" />
          </div>
          <div className="text-2xl text-[#2d3748]">{progress.currentStreak}</div>
          <div className="text-xs text-[#78716c] mt-1">Day Streak</div>
        </motion.div>

        <motion.div
          whileHover={{ scale: 1.05 }}
          className="bg-gradient-to-br from-[#f0fdf4] to-[#bbf7d0] rounded-2xl p-4 text-center"
        >
          <div className="w-10 h-10 rounded-full bg-white mx-auto mb-2 flex items-center justify-center">
            <Target className="w-5 h-5 text-[#22c55e]" />
          </div>
          <div className="text-2xl text-[#2d3748]">{progress.todayPomodoros}</div>
          <div className="text-xs text-[#78716c] mt-1">Today</div>
        </motion.div>

        <motion.div
          whileHover={{ scale: 1.05 }}
          className="bg-gradient-to-br from-[#faf5ff] to-[#e9d5ff] rounded-2xl p-4 text-center"
        >
          <div className="w-10 h-10 rounded-full bg-white mx-auto mb-2 flex items-center justify-center">
            <Trophy className="w-5 h-5 text-[#a855f7]" />
          </div>
          <div className="text-2xl text-[#2d3748]">{progress.totalPomodoros}</div>
          <div className="text-xs text-[#78716c] mt-1">All Time</div>
        </motion.div>
      </div>

      {/* Achievements */}
      <div>
        <div className="flex items-center gap-2 mb-4">
          <Sparkles className="w-4 h-4 text-[#f59e0b]" />
          <h4 className="text-sm text-[#2d3748]">Achievements</h4>
        </div>

        <div className="space-y-3">
          {achievements.map((achievement, index) => (
            <motion.div
              key={achievement.name}
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: index * 0.1 }}
              className={`flex items-center justify-between p-3 rounded-xl ${
                achievement.unlocked
                  ? 'bg-gradient-to-r from-[#9ed9c5]/20 to-[#7bc5ae]/10'
                  : 'bg-[#f8f8f8]'
              }`}
            >
              <div className="flex items-center gap-3">
                <div
                  className={`w-8 h-8 rounded-full flex items-center justify-center transition-all duration-300 ${
                    achievement.unlocked
                      ? 'bg-gradient-to-br from-[#9ed9c5] to-[#7bc5ae]'
                      : 'bg-[#e5e5e5]'
                  }`}
                >
                  {achievement.unlocked ? (
                    <span className="text-white text-sm">✓</span>
                  ) : (
                    <span className="text-[#9ca3af] text-sm">🔒</span>
                  )}
                </div>
                <div>
                  <div className={`text-sm ${achievement.unlocked ? 'text-[#2d3748]' : 'text-[#9ca3af]'}`}>
                    {achievement.name}
                  </div>
                  <div className="text-xs text-[#9ca3af]">
                    {achievement.milestone} Pomodoros
                  </div>
                </div>
              </div>

              {achievement.unlocked && (
                <motion.div
                  initial={{ scale: 0 }}
                  animate={{ scale: 1 }}
                  transition={{ type: 'spring', bounce: 0.5 }}
                >
                  <Sparkles className="w-4 h-4 text-[#f59e0b]" />
                </motion.div>
              )}
            </motion.div>
          ))}
        </div>
      </div>
    </div>
  );
}
