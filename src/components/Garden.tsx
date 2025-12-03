import { motion, AnimatePresence } from 'motion/react';
import type { Progress } from '../App';
import { Tree, Cloud, Butterfly, Bird, Rabbit, Deer, Fox } from './GardenElements';

interface GardenProps {
  progress: Progress;
}

export function Garden({ progress }: GardenProps) {
  const animalComponents: Record<string, React.ComponentType<{ className?: string }>> = {
    butterfly: Butterfly,
    bird: Bird,
    rabbit: Rabbit,
    deer: Deer,
    fox: Fox,
  };

  return (
    <div className="bg-white rounded-3xl shadow-[8px_8px_24px_rgba(0,0,0,0.06),-8px_-8px_24px_rgba(255,255,255,0.9)] p-8 h-[600px] overflow-hidden flex flex-col">
      <div className="mb-6">
        <h2 className="text-[#2d3748] mb-2">Your Focus Garden</h2>
        <p className="text-sm text-[#6b7280]">
          Complete Pomodoros to grow your peaceful sanctuary
        </p>
      </div>

      {/* Garden Canvas */}
      <div className="flex-1 relative bg-gradient-to-b from-[#e3f2f7] to-[#f0f7e8] rounded-2xl overflow-hidden">
        {/* Sky with Clouds */}
        <div className="absolute inset-0 pointer-events-none">
          <AnimatePresence>
            {Array.from({ length: Math.min(progress.clouds, 8) }, (_, i) => (
              <motion.div
                key={`cloud-${i}`}
                initial={{ opacity: 0, y: -20, x: Math.random() * 80 }}
                animate={{ 
                  opacity: 0.7, 
                  y: 20 + Math.random() * 60,
                  x: 10 + (i * 80) % 90,
                }}
                transition={{ 
                  duration: 1, 
                  delay: i * 0.2,
                  y: {
                    duration: 3 + Math.random() * 2,
                    repeat: Infinity,
                    repeatType: 'reverse',
                    ease: 'easeInOut',
                  }
                }}
                className="absolute"
                style={{ left: `${(i * 25) % 80}%` }}
              >
                <Cloud className="w-16 h-16 md:w-20 md:h-20" />
              </motion.div>
            ))}
          </AnimatePresence>
        </div>

        {/* Ground with Trees */}
        <div className="absolute bottom-0 left-0 right-0 h-1/2 bg-gradient-to-t from-[#c8e6c9] via-[#d4edda] to-transparent">
          <AnimatePresence>
            {Array.from({ length: Math.min(progress.trees, 12) }, (_, i) => {
              const row = Math.floor(i / 4);
              const col = i % 4;
              const scale = 1 - row * 0.15;
              
              return (
                <motion.div
                  key={`tree-${i}`}
                  initial={{ opacity: 0, scale: 0, y: 20 }}
                  animate={{ opacity: 1, scale: scale, y: 0 }}
                  transition={{ 
                    duration: 0.8, 
                    delay: i * 0.15,
                    type: 'spring',
                    bounce: 0.4,
                  }}
                  className="absolute"
                  style={{
                    bottom: `${10 + row * 25}%`,
                    left: `${15 + col * 20}%`,
                    zIndex: 10 - row,
                  }}
                >
                  <motion.div
                    animate={{ rotate: [-2, 2, -2] }}
                    transition={{
                      duration: 3 + Math.random() * 2,
                      repeat: Infinity,
                      ease: 'easeInOut',
                    }}
                  >
                    <Tree className="w-12 h-16 md:w-16 md:h-20" />
                  </motion.div>
                </motion.div>
              );
            })}
          </AnimatePresence>

          {/* Animals */}
          <AnimatePresence>
            {progress.animals.map((animal, i) => {
              const AnimalComponent = animalComponents[animal];
              if (!AnimalComponent) return null;

              const positions = [
                { bottom: '15%', left: '70%' },
                { bottom: '25%', left: '25%' },
                { bottom: '35%', left: '80%' },
                { bottom: '20%', left: '45%' },
                { bottom: '30%', left: '60%' },
              ];

              return (
                <motion.div
                  key={`animal-${animal}-${i}`}
                  initial={{ opacity: 0, scale: 0, y: 30 }}
                  animate={{ opacity: 1, scale: 1, y: 0 }}
                  transition={{ 
                    duration: 1, 
                    delay: 0.5,
                    type: 'spring',
                  }}
                  className="absolute"
                  style={positions[i] || positions[0]}
                >
                  <motion.div
                    animate={
                      animal === 'butterfly' || animal === 'bird'
                        ? { y: [-5, 5, -5], x: [-3, 3, -3] }
                        : { y: [0, -3, 0] }
                    }
                    transition={{
                      duration: animal === 'butterfly' ? 2 : 3,
                      repeat: Infinity,
                      ease: 'easeInOut',
                    }}
                  >
                    <AnimalComponent className="w-8 h-8 md:w-10 md:h-10" />
                  </motion.div>
                </motion.div>
              );
            })}
          </AnimatePresence>

          {/* Empty State */}
          {progress.trees === 0 && progress.clouds === 0 && (
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              className="absolute inset-0 flex items-center justify-center"
            >
              <div className="text-center text-[#9ca3af]">
                <p className="text-lg">Your garden awaits</p>
                <p className="text-sm mt-2">Complete your first Pomodoro to plant a tree</p>
              </div>
            </motion.div>
          )}
        </div>
      </div>

      {/* Garden Stats */}
      <div className="grid grid-cols-3 gap-4 mt-6">
        <div className="text-center">
          <div className="text-2xl text-[#2d3748]">{progress.trees}</div>
          <div className="text-xs text-[#9ca3af]">Trees</div>
        </div>
        <div className="text-center">
          <div className="text-2xl text-[#2d3748]">{progress.clouds}</div>
          <div className="text-xs text-[#9ca3af]">Clouds</div>
        </div>
        <div className="text-center">
          <div className="text-2xl text-[#2d3748]">{progress.animals.length}</div>
          <div className="text-xs text-[#9ca3af]">Animals</div>
        </div>
      </div>
    </div>
  );
}
