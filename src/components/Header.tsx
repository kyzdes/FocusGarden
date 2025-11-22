import { Leaf, Settings, BarChart3 } from 'lucide-react';

interface HeaderProps {
  onSettingsClick: () => void;
  onStatisticsClick: () => void;
}

export function Header({ onSettingsClick, onStatisticsClick }: HeaderProps) {
  return (
    <header className="bg-white/60 backdrop-blur-md border-b border-[#e0e0e0]/30">
      <div className="container mx-auto px-4 py-4 flex items-center justify-between max-w-7xl">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-full bg-gradient-to-br from-[#9ed9c5] to-[#7bc5ae] flex items-center justify-center shadow-lg">
            <Leaf className="w-5 h-5 text-white" strokeWidth={2.5} />
          </div>
          <h1 className="text-[#2d3748]">Focus Garden</h1>
        </div>

        <div className="flex gap-2">
          <button
            onClick={onStatisticsClick}
            className="w-10 h-10 rounded-full bg-white hover:bg-[#f8f8f8] transition-all duration-300 flex items-center justify-center shadow-sm hover:shadow-md group"
            aria-label="Statistics"
          >
            <BarChart3 className="w-5 h-5 text-[#6b7280] group-hover:scale-110 transition-transform duration-300" />
          </button>
          
          <button
            onClick={onSettingsClick}
            className="w-10 h-10 rounded-full bg-white hover:bg-[#f8f8f8] transition-all duration-300 flex items-center justify-center shadow-sm hover:shadow-md group"
            aria-label="Settings"
          >
            <Settings className="w-5 h-5 text-[#6b7280] group-hover:rotate-90 transition-transform duration-300" />
          </button>
        </div>
      </div>
    </header>
  );
}