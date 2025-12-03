import { X, Clock, Volume2, VolumeX } from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';
import type { TimerSettings } from '../App';

interface SettingsProps {
  settings: TimerSettings;
  onSettingsChange: (settings: TimerSettings) => void;
  onClose: () => void;
}

export function Settings({ settings, onSettingsChange, onClose }: SettingsProps) {
  const updateSetting = (key: keyof TimerSettings, value: number | boolean) => {
    onSettingsChange({ ...settings, [key]: value });
  };

  return (
    <AnimatePresence>
      <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
        {/* Backdrop */}
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          onClick={onClose}
          className="absolute inset-0 bg-black/20 backdrop-blur-sm"
        />

        {/* Modal */}
        <motion.div
          initial={{ opacity: 0, scale: 0.95, y: 20 }}
          animate={{ opacity: 1, scale: 1, y: 0 }}
          exit={{ opacity: 0, scale: 0.95, y: 20 }}
          transition={{ type: 'spring', bounce: 0.3 }}
          className="relative bg-white rounded-3xl shadow-2xl p-8 w-full max-w-md"
        >
          {/* Header */}
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-[#2d3748]">Settings</h2>
            <button
              onClick={onClose}
              className="w-10 h-10 rounded-full hover:bg-[#f8f8f8] transition-colors flex items-center justify-center"
            >
              <X className="w-5 h-5 text-[#6b7280]" />
            </button>
          </div>

          <div className="space-y-6">
            {/* Timer Settings */}
            <div>
              <div className="flex items-center gap-2 mb-4">
                <Clock className="w-4 h-4 text-[#9ed9c5]" />
                <h3 className="text-sm text-[#2d3748]">Timer Duration</h3>
              </div>

              <div className="space-y-4">
                {/* Focus Time */}
                <div>
                  <div className="flex justify-between items-center mb-2">
                    <label className="text-sm text-[#6b7280]">Focus Time</label>
                    <span className="text-sm text-[#2d3748]">{settings.focusTime} min</span>
                  </div>
                  <input
                    type="range"
                    min="5"
                    max="60"
                    step="5"
                    value={settings.focusTime}
                    onChange={(e) => updateSetting('focusTime', parseInt(e.target.value))}
                    className="w-full h-2 bg-[#f0f0f0] rounded-full appearance-none cursor-pointer slider"
                    style={{
                      background: `linear-gradient(to right, #9ed9c5 0%, #9ed9c5 ${((settings.focusTime - 5) / 55) * 100}%, #f0f0f0 ${((settings.focusTime - 5) / 55) * 100}%, #f0f0f0 100%)`
                    }}
                  />
                </div>

                {/* Short Break */}
                <div>
                  <div className="flex justify-between items-center mb-2">
                    <label className="text-sm text-[#6b7280]">Short Break</label>
                    <span className="text-sm text-[#2d3748]">{settings.breakTime} min</span>
                  </div>
                  <input
                    type="range"
                    min="1"
                    max="15"
                    step="1"
                    value={settings.breakTime}
                    onChange={(e) => updateSetting('breakTime', parseInt(e.target.value))}
                    className="w-full h-2 bg-[#f0f0f0] rounded-full appearance-none cursor-pointer slider"
                    style={{
                      background: `linear-gradient(to right, #a8c5e0 0%, #a8c5e0 ${((settings.breakTime - 1) / 14) * 100}%, #f0f0f0 ${((settings.breakTime - 1) / 14) * 100}%, #f0f0f0 100%)`
                    }}
                  />
                </div>

                {/* Long Break */}
                <div>
                  <div className="flex justify-between items-center mb-2">
                    <label className="text-sm text-[#6b7280]">Long Break</label>
                    <span className="text-sm text-[#2d3748]">{settings.longBreakTime} min</span>
                  </div>
                  <input
                    type="range"
                    min="5"
                    max="30"
                    step="5"
                    value={settings.longBreakTime}
                    onChange={(e) => updateSetting('longBreakTime', parseInt(e.target.value))}
                    className="w-full h-2 bg-[#f0f0f0] rounded-full appearance-none cursor-pointer slider"
                    style={{
                      background: `linear-gradient(to right, #d4a5c8 0%, #d4a5c8 ${((settings.longBreakTime - 5) / 25) * 100}%, #f0f0f0 ${((settings.longBreakTime - 5) / 25) * 100}%, #f0f0f0 100%)`
                    }}
                  />
                </div>
              </div>
            </div>

            {/* Sound Settings */}
            <div>
              <div className="flex items-center gap-2 mb-4">
                {settings.soundEnabled ? (
                  <Volume2 className="w-4 h-4 text-[#9ed9c5]" />
                ) : (
                  <VolumeX className="w-4 h-4 text-[#9ca3af]" />
                )}
                <h3 className="text-sm text-[#2d3748]">Sound</h3>
              </div>

              <button
                onClick={() => updateSetting('soundEnabled', !settings.soundEnabled)}
                className={`w-full p-4 rounded-xl transition-all duration-300 ${
                  settings.soundEnabled
                    ? 'bg-gradient-to-r from-[#9ed9c5]/20 to-[#7bc5ae]/10 border-2 border-[#9ed9c5]'
                    : 'bg-[#f8f8f8] border-2 border-transparent'
                }`}
              >
                <div className="flex items-center justify-between">
                  <span className="text-sm text-[#2d3748]">Completion Sound</span>
                  <div
                    className={`w-12 h-6 rounded-full transition-colors duration-300 relative ${
                      settings.soundEnabled ? 'bg-[#9ed9c5]' : 'bg-[#e5e5e5]'
                    }`}
                  >
                    <motion.div
                      animate={{ x: settings.soundEnabled ? 24 : 0 }}
                      transition={{ type: 'spring', stiffness: 500, damping: 30 }}
                      className="absolute top-1 left-1 w-4 h-4 bg-white rounded-full shadow-sm"
                    />
                  </div>
                </div>
              </button>
            </div>

            {/* Info */}
            <div className="bg-gradient-to-r from-[#f0f7e8] to-[#e3f2f7] rounded-xl p-4">
              <p className="text-xs text-[#6b7280] leading-relaxed">
                💡 The Pomodoro Technique: Work for focused intervals (usually 25 minutes), 
                then take a short break. After 4 cycles, take a longer break. 
                This helps maintain high focus and prevents burnout.
              </p>
            </div>
          </div>

          {/* Save Button */}
          <motion.button
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            onClick={onClose}
            className="w-full mt-6 py-3 bg-gradient-to-r from-[#9ed9c5] to-[#7bc5ae] text-white rounded-xl shadow-lg hover:shadow-xl transition-all duration-300"
          >
            Save Changes
          </motion.button>
        </motion.div>
      </div>
    </AnimatePresence>
  );
}
