import { useState, useEffect, useRef } from 'react';
import { Play, Pause, RotateCcw } from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';
import type { TimerSettings } from '../App';

interface TimerProps {
  settings: TimerSettings;
  onComplete: () => void;
}

type TimerMode = 'focus' | 'break' | 'longBreak';

export function Timer({ settings, onComplete }: TimerProps) {
  const [mode, setMode] = useState<TimerMode>('focus');
  const [timeLeft, setTimeLeft] = useState(settings.focusTime * 60);
  const [isRunning, setIsRunning] = useState(false);
  const [completedCycles, setCompletedCycles] = useState(0);
  const intervalRef = useRef<NodeJS.Timeout | null>(null);

  const totalTime = mode === 'focus' 
    ? settings.focusTime * 60 
    : mode === 'break' 
    ? settings.breakTime * 60 
    : settings.longBreakTime * 60;

  const progress = ((totalTime - timeLeft) / totalTime) * 100;

  useEffect(() => {
    if (isRunning && timeLeft > 0) {
      intervalRef.current = setInterval(() => {
        setTimeLeft(prev => {
          if (prev <= 1) {
            handleTimerComplete();
            return 0;
          }
          return prev - 1;
        });
      }, 1000);
    } else {
      if (intervalRef.current) {
        clearInterval(intervalRef.current);
      }
    }

    return () => {
      if (intervalRef.current) {
        clearInterval(intervalRef.current);
      }
    };
  }, [isRunning, timeLeft]);

  const handleTimerComplete = () => {
    setIsRunning(false);
    
    if (mode === 'focus') {
      setCompletedCycles(prev => prev + 1);
      onComplete();
      
      // Switch to break mode
      if ((completedCycles + 1) % 4 === 0) {
        setMode('longBreak');
        setTimeLeft(settings.longBreakTime * 60);
      } else {
        setMode('break');
        setTimeLeft(settings.breakTime * 60);
      }
    } else {
      // Switch back to focus mode
      setMode('focus');
      setTimeLeft(settings.focusTime * 60);
    }
  };

  const toggleTimer = () => {
    setIsRunning(!isRunning);
  };

  const resetTimer = () => {
    setIsRunning(false);
    setTimeLeft(totalTime);
  };

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  };

  const modeConfig = {
    focus: {
      label: 'Focus Time',
      color: '#9ed9c5',
      bgColor: 'from-[#9ed9c5]/10 to-[#7bc5ae]/5',
    },
    break: {
      label: 'Short Break',
      color: '#a8c5e0',
      bgColor: 'from-[#a8c5e0]/10 to-[#8baed4]/5',
    },
    longBreak: {
      label: 'Long Break',
      color: '#d4a5c8',
      bgColor: 'from-[#d4a5c8]/10 to-[#c18fb5]/5',
    },
  };

  return (
    <div className="bg-white rounded-3xl shadow-[8px_8px_24px_rgba(0,0,0,0.06),-8px_-8px_24px_rgba(255,255,255,0.9)] p-8 md:p-12">
      {/* Mode Selector */}
      <div className="flex gap-2 mb-8">
        {(['focus', 'break', 'longBreak'] as TimerMode[]).map((m) => (
          <button
            key={m}
            onClick={() => {
              if (!isRunning) {
                setMode(m);
                setTimeLeft(m === 'focus' ? settings.focusTime * 60 : m === 'break' ? settings.breakTime * 60 : settings.longBreakTime * 60);
              }
            }}
            disabled={isRunning}
            className={`flex-1 py-2 px-4 rounded-xl transition-all duration-300 ${
              mode === m
                ? `bg-gradient-to-r ${modeConfig[m].bgColor} shadow-sm`
                : 'hover:bg-[#f8f8f8]'
            } ${isRunning ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer'}`}
          >
            <span className={`text-sm ${mode === m ? 'text-[#2d3748]' : 'text-[#6b7280]'}`}>
              {modeConfig[m].label}
            </span>
          </button>
        ))}
      </div>

      {/* Circular Progress Timer */}
      <div className="flex flex-col items-center gap-8">
        <div className="relative w-64 h-64 md:w-80 md:h-80">
          {/* Background Circle */}
          <svg className="absolute inset-0 w-full h-full -rotate-90">
            <circle
              cx="50%"
              cy="50%"
              r="40%"
              fill="none"
              stroke="#f0f0f0"
              strokeWidth="12"
            />
            {/* Progress Circle */}
            <motion.circle
              cx="50%"
              cy="50%"
              r="40%"
              fill="none"
              stroke={modeConfig[mode].color}
              strokeWidth="12"
              strokeLinecap="round"
              pathLength="1"
              strokeDasharray="1"
              initial={{ strokeDashoffset: 0 }}
              animate={{ 
                strokeDashoffset: progress / 100
              }}
              transition={{ duration: 0.5, ease: 'easeInOut' }}
            />
          </svg>

          {/* Timer Display */}
          <div className="absolute inset-0 flex flex-col items-center justify-center">
            <AnimatePresence mode="wait">
              <motion.div
                key={timeLeft}
                initial={{ scale: 0.95, opacity: 0 }}
                animate={{ scale: 1, opacity: 1 }}
                exit={{ scale: 1.05, opacity: 0 }}
                transition={{ duration: 0.2 }}
                className="text-6xl md:text-7xl text-[#2d3748] tabular-nums"
              >
                {formatTime(timeLeft)}
              </motion.div>
            </AnimatePresence>
            <div className="text-[#9ca3af] mt-2">
              Cycle {completedCycles + 1}
            </div>
          </div>
        </div>

        {/* Controls */}
        <div className="flex gap-4">
          <motion.button
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            onClick={toggleTimer}
            className={`w-16 h-16 rounded-full shadow-lg flex items-center justify-center transition-all duration-300 ${
              isRunning
                ? 'bg-gradient-to-br from-[#f59e9e] to-[#ef7878]'
                : 'bg-gradient-to-br from-[#9ed9c5] to-[#7bc5ae]'
            }`}
          >
            {isRunning ? (
              <Pause className="w-7 h-7 text-white" fill="white" />
            ) : (
              <Play className="w-7 h-7 text-white ml-1" fill="white" />
            )}
          </motion.button>

          <motion.button
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            onClick={resetTimer}
            className="w-16 h-16 rounded-full bg-white shadow-lg flex items-center justify-center hover:bg-[#f8f8f8] transition-all duration-300"
          >
            <RotateCcw className="w-6 h-6 text-[#6b7280]" />
          </motion.button>
        </div>
      </div>
    </div>
  );
}