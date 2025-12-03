import { X, Calendar, TrendingUp, Clock, Award } from 'lucide-react';
import { motion } from 'motion/react';
import { BarChart, Bar, LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Area, AreaChart } from 'recharts';
import type { Progress, DailyRecord } from '../App';
import { useState } from 'react';

interface StatisticsProps {
  progress: Progress;
  onClose: () => void;
}

type TimeRange = 'week' | 'month' | 'all';

export function Statistics({ progress, onClose }: StatisticsProps) {
  const [timeRange, setTimeRange] = useState<TimeRange>('week');

  // Generate calendar data for the last 90 days
  const getCalendarData = () => {
    const data: { date: string; count: number }[] = [];
    const today = new Date();
    
    for (let i = 89; i >= 0; i--) {
      const date = new Date(today);
      date.setDate(date.getDate() - i);
      const dateStr = date.toISOString().split('T')[0];
      
      const record = progress.history.find(r => r.date === dateStr);
      data.push({
        date: dateStr,
        count: record?.pomodoros || 0,
      });
    }
    
    return data;
  };

  // Get filtered data based on time range
  const getFilteredData = () => {
    const today = new Date();
    let daysBack = 7;
    
    if (timeRange === 'month') daysBack = 30;
    if (timeRange === 'all') daysBack = 365;
    
    const data: DailyRecord[] = [];
    
    for (let i = daysBack - 1; i >= 0; i--) {
      const date = new Date(today);
      date.setDate(date.getDate() - i);
      const dateStr = date.toISOString().split('T')[0];
      
      const record = progress.history.find(r => r.date === dateStr);
      data.push({
        date: dateStr,
        pomodoros: record?.pomodoros || 0,
        focusMinutes: record?.focusMinutes || 0,
      });
    }
    
    return data;
  };

  const filteredData = getFilteredData();
  const calendarData = getCalendarData();

  // Calculate statistics
  const totalFocusMinutes = progress.history.reduce((sum, r) => sum + r.focusMinutes, 0);
  const totalFocusHours = Math.floor(totalFocusMinutes / 60);
  const avgPerDay = progress.history.length > 0 
    ? Math.round(progress.totalPomodoros / progress.history.length) 
    : 0;
  
  const thisWeekData = filteredData.slice(-7);
  const thisWeekTotal = thisWeekData.reduce((sum, r) => sum + r.pomodoros, 0);
  
  const lastWeekData = getFilteredData().slice(-14, -7);
  const lastWeekTotal = lastWeekData.reduce((sum, r) => sum + r.pomodoros, 0);
  
  const weekChange = lastWeekTotal > 0 
    ? Math.round(((thisWeekTotal - lastWeekTotal) / lastWeekTotal) * 100)
    : 0;

  // Get best day
  const bestDay = progress.history.reduce((best, current) => 
    current.pomodoros > best.pomodoros ? current : best
  , { date: '', pomodoros: 0, focusMinutes: 0 });

  // Format date for display
  const formatDate = (dateStr: string) => {
    const date = new Date(dateStr);
    return date.toLocaleDateString('ru-RU', { day: 'numeric', month: 'short' });
  };

  const formatDateShort = (dateStr: string) => {
    const date = new Date(dateStr);
    return date.toLocaleDateString('ru-RU', { day: 'numeric', month: 'numeric' });
  };

  // Get intensity color for calendar
  const getIntensityColor = (count: number) => {
    if (count === 0) return '#f0f0f0';
    if (count <= 2) return '#c8e6d5';
    if (count <= 4) return '#9ed9c5';
    if (count <= 6) return '#7bc5ae';
    return '#5ba892';
  };

  return (
    <div className="flex-1 container mx-auto px-4 py-8 max-w-7xl">
      {/* Header */}
      <div className="flex items-center justify-between mb-8">
        <div>
          <h2 className="text-[#2d3748] mb-2">Статистика</h2>
          <p className="text-[#6b7280]">Подробный анализ вашей продуктивности</p>
        </div>
        <button
          onClick={onClose}
          className="w-12 h-12 rounded-full bg-white hover:bg-[#f8f8f8] transition-colors flex items-center justify-center shadow-sm"
        >
          <X className="w-6 h-6 text-[#6b7280]" />
        </button>
      </div>

      {/* Key Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="bg-white rounded-2xl p-6 shadow-[8px_8px_24px_rgba(0,0,0,0.06)]"
        >
          <div className="flex items-center gap-3 mb-2">
            <div className="w-10 h-10 rounded-full bg-gradient-to-br from-[#9ed9c5] to-[#7bc5ae] flex items-center justify-center">
              <Award className="w-5 h-5 text-white" />
            </div>
            <div className="text-sm text-[#9ca3af]">Всего</div>
          </div>
          <div className="text-3xl text-[#2d3748]">{progress.totalPomodoros}</div>
          <div className="text-xs text-[#9ca3af] mt-1">помодоро</div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          className="bg-white rounded-2xl p-6 shadow-[8px_8px_24px_rgba(0,0,0,0.06)]"
        >
          <div className="flex items-center gap-3 mb-2">
            <div className="w-10 h-10 rounded-full bg-gradient-to-br from-[#a8c5e0] to-[#8baed4] flex items-center justify-center">
              <Clock className="w-5 h-5 text-white" />
            </div>
            <div className="text-sm text-[#9ca3af]">Время фокуса</div>
          </div>
          <div className="text-3xl text-[#2d3748]">{totalFocusHours}ч</div>
          <div className="text-xs text-[#9ca3af] mt-1">{totalFocusMinutes % 60}м</div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
          className="bg-white rounded-2xl p-6 shadow-[8px_8px_24px_rgba(0,0,0,0.06)]"
        >
          <div className="flex items-center gap-3 mb-2">
            <div className="w-10 h-10 rounded-full bg-gradient-to-br from-[#f6ad55] to-[#ed8936] flex items-center justify-center">
              <TrendingUp className="w-5 h-5 text-white" />
            </div>
            <div className="text-sm text-[#9ca3af]">За неделю</div>
          </div>
          <div className="text-3xl text-[#2d3748]">{thisWeekTotal}</div>
          <div className={`text-xs mt-1 ${weekChange >= 0 ? 'text-[#22c55e]' : 'text-[#ef4444]'}`}>
            {weekChange > 0 ? '+' : ''}{weekChange}% к прошлой неделе
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
          className="bg-white rounded-2xl p-6 shadow-[8px_8px_24px_rgba(0,0,0,0.06)]"
        >
          <div className="flex items-center gap-3 mb-2">
            <div className="w-10 h-10 rounded-full bg-gradient-to-br from-[#d4a5c8] to-[#c18fb5] flex items-center justify-center">
              <Calendar className="w-5 h-5 text-white" />
            </div>
            <div className="text-sm text-[#9ca3af]">Средний день</div>
          </div>
          <div className="text-3xl text-[#2d3748]">{avgPerDay}</div>
          <div className="text-xs text-[#9ca3af] mt-1">помодоро/день</div>
        </motion.div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Main Chart */}
        <div className="lg:col-span-2 bg-white rounded-2xl p-6 shadow-[8px_8px_24px_rgba(0,0,0,0.06)]">
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-[#2d3748]">Активность</h3>
            <div className="flex gap-2">
              {(['week', 'month', 'all'] as TimeRange[]).map((range) => (
                <button
                  key={range}
                  onClick={() => setTimeRange(range)}
                  className={`px-3 py-1 rounded-lg text-sm transition-all duration-300 ${
                    timeRange === range
                      ? 'bg-gradient-to-r from-[#9ed9c5] to-[#7bc5ae] text-white'
                      : 'bg-[#f8f8f8] text-[#6b7280] hover:bg-[#e8e8e8]'
                  }`}
                >
                  {range === 'week' ? 'Неделя' : range === 'month' ? 'Месяц' : 'Всё время'}
                </button>
              ))}
            </div>
          </div>

          <ResponsiveContainer width="100%" height={300}>
            <AreaChart data={filteredData}>
              <defs>
                <linearGradient id="colorPomodoros" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#9ed9c5" stopOpacity={0.3}/>
                  <stop offset="95%" stopColor="#9ed9c5" stopOpacity={0}/>
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
              <XAxis 
                dataKey="date" 
                tickFormatter={formatDateShort}
                stroke="#9ca3af"
                fontSize={12}
              />
              <YAxis stroke="#9ca3af" fontSize={12} />
              <Tooltip 
                contentStyle={{
                  backgroundColor: 'white',
                  border: 'none',
                  borderRadius: '12px',
                  boxShadow: '0 4px 12px rgba(0,0,0,0.1)',
                }}
                formatter={(value: number) => [`${value} помодоро`, 'Завершено']}
                labelFormatter={formatDate}
              />
              <Area 
                type="monotone" 
                dataKey="pomodoros" 
                stroke="#9ed9c5" 
                strokeWidth={3}
                fill="url(#colorPomodoros)"
              />
            </AreaChart>
          </ResponsiveContainer>
        </div>

        {/* Best Records */}
        <div className="bg-white rounded-2xl p-6 shadow-[8px_8px_24px_rgba(0,0,0,0.06)]">
          <h3 className="text-[#2d3748] mb-6">Достижения</h3>
          
          <div className="space-y-4">
            <div className="p-4 bg-gradient-to-br from-[#fff7ed] to-[#fed7aa] rounded-xl">
              <div className="text-sm text-[#78716c] mb-2">🏆 Лучший день</div>
              <div className="text-2xl text-[#2d3748]">
                {bestDay.pomodoros > 0 ? bestDay.pomodoros : '-'}
              </div>
              <div className="text-xs text-[#78716c] mt-1">
                {bestDay.date ? formatDate(bestDay.date) : 'Нет данных'}
              </div>
            </div>

            <div className="p-4 bg-gradient-to-br from-[#f0fdf4] to-[#bbf7d0] rounded-xl">
              <div className="text-sm text-[#78716c] mb-2">🔥 Текущая серия</div>
              <div className="text-2xl text-[#2d3748]">{progress.currentStreak}</div>
              <div className="text-xs text-[#78716c] mt-1">дней подряд</div>
            </div>

            <div className="p-4 bg-gradient-to-br from-[#faf5ff] to-[#e9d5ff] rounded-xl">
              <div className="text-sm text-[#78716c] mb-2">🎯 Всего дней</div>
              <div className="text-2xl text-[#2d3748]">{progress.history.length}</div>
              <div className="text-xs text-[#78716c] mt-1">с активностью</div>
            </div>
          </div>
        </div>

        {/* Activity Calendar */}
        <div className="lg:col-span-3 bg-white rounded-2xl p-6 shadow-[8px_8px_24px_rgba(0,0,0,0.06)]">
          <h3 className="text-[#2d3748] mb-6">Календарь активности (последние 90 дней)</h3>
          
          <div className="overflow-x-auto">
            <div className="inline-grid gap-1" style={{ gridTemplateColumns: 'repeat(13, minmax(0, 1fr))' }}>
              {calendarData.map((day, index) => (
                <motion.div
                  key={day.date}
                  initial={{ opacity: 0, scale: 0 }}
                  animate={{ opacity: 1, scale: 1 }}
                  transition={{ delay: index * 0.002 }}
                  className="group relative"
                >
                  <div
                    className="w-7 h-7 rounded-md transition-all duration-200 hover:ring-2 hover:ring-[#9ed9c5] cursor-pointer"
                    style={{ backgroundColor: getIntensityColor(day.count) }}
                    title={`${formatDate(day.date)}: ${day.count} помодоро`}
                  />
                  {/* Tooltip */}
                  <div className="absolute bottom-full left-1/2 transform -translate-x-1/2 mb-2 px-3 py-2 bg-[#2d3748] text-white text-xs rounded-lg opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none whitespace-nowrap z-10">
                    {formatDate(day.date)}: {day.count} помодоро
                  </div>
                </motion.div>
              ))}
            </div>
          </div>

          {/* Legend */}
          <div className="flex items-center gap-2 mt-6 text-xs text-[#9ca3af]">
            <span>Меньше</span>
            <div className="flex gap-1">
              {[0, 2, 4, 6, 8].map((val) => (
                <div
                  key={val}
                  className="w-4 h-4 rounded-sm"
                  style={{ backgroundColor: getIntensityColor(val) }}
                />
              ))}
            </div>
            <span>Больше</span>
          </div>
        </div>
      </div>
    </div>
  );
}
