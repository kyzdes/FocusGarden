# Focus Garden - Актуальное состояние приложения (v0.9.1)

> Последнее обновление: Декабрь 2024
> Этот файл содержит полное описание текущего функционала и архитектуры приложения

## 📱 Обзор приложения

Focus Garden - iOS приложение для управления временем с двумя режимами работы:
1. **Pomodoro Mode** - классический помодоро таймер с визуализацией сада
2. **Workout Mode** - интервальный таймер для тренировок с визуализацией спортзала

### Ключевые особенности
- 🍅 Два режима работы (Pomodoro / Workout)
- 🌱 Визуальный прогресс (Сад для Pomodoro, Спортзал для Workout)
- 📊 Детальная статистика для каждого режима
- 🔔 Live Activity и Dynamic Island support
- 🌍 Локализация (English, Русский)
- 🎨 Темная/светлая тема
- ☁️ iCloud синхронизация прогресса

---

## 🍅 Режим Pomodoro

### Функционал
- **Таймеры**: Focus (5-60 мин), Short Break (1-15 мин), Long Break (5-30 мин)
- **Автопереключение**: Focus → Short Break → Focus... Каждый 4-й цикл → Long Break
- **Счетчик циклов**: Отслеживание завершенных Pomodoro
- **Звуковые уведомления**: С haptic feedback
- **Background работа**: Таймер продолжает работать в фоне

### Визуализация - Виртуальный Сад
**Награды за прогресс:**
- 🌳 **Деревья**: 1 дерево за каждый Pomodoro
- ☁️ **Облака**: Каждые 2 Pomodoro
- **Животные** (milestone rewards):
  - 🦋 Бабочка - 3 Pomodoro
  - 🐦 Птица - 7 Pomodoro
  - 🐰 Кролик - 15 Pomodoro
  - 🦌 Олень - 25 Pomodoro
  - 🦊 Лиса - 40 Pomodoro

**Лимиты отображения:**
- Максимум 10 деревьев на экране
- Максимум 7 облаков
- Все разблокированные животные отображаются

### Файлы
- **ViewModel**: `TimerViewModel.swift`
- **UI**: `TimerView.swift`, `GardenView.swift`
- **Прогресс**: `ProgressTrackerView.swift`
- **Статистика**: `StatisticsView.swift` (секция Pomodoro)

---

## 🏋️ Режим Workout (Interval Training)

### Функционал
- **Интервальные тренировки**: Exercise + Rest циклы
- **Кастомизация**:
  - Exercise: 5-90 секунд (шаг 5 сек)
  - Rest: 5-90 секунд (шаг 5 сек)
- **Выбор циклов**: 5, 10, 15, 20, 25, 30 циклов на тренировку
- **Автопереключение**: Exercise → Rest → Exercise...
- **Счетчик циклов**: "Цикл X из Y"
- **Звуковые уведомления**: Отдельные звуки для Exercise/Rest

### Визуализация - Виртуальный Спортзал
**Награды за прогресс:**
- 🏋️ **Гантели**: 1 гантель за каждый цикл
- 🎯 **Гири**: Каждые 2 цикла
- **Инвентарь** (milestone rewards):
  - 🪢 Скакалка - 5 циклов
  - 🧘 Коврик - 10 циклов
  - 🏋️ Штанга - 20 циклов
  - 🚴 Велосипед - 35 циклов
  - 🥊 Бокс - 50 циклов

**Лимиты отображения:**
- Максимум 12 гантелей на экране
- Все разблокированные гири и инвентарь

### Файлы
- **ViewModel**: `WorkoutTimerViewModel.swift`
- **UI**: `WorkoutTimerView.swift`, `GymView.swift`, `CycleSelectorView.swift`
- **Прогресс**: `WorkoutProgressTrackerView.swift`
- **Статистика**: `WorkoutStatisticsView.swift`

---

## 🔔 Live Activity & Dynamic Island

### Статус: ✅ Реализовано (с исправлением фонового режима)

### Функционал
- **Lock Screen**: Таймер с прогресс-баром на экране блокировки
- **Dynamic Island** (iPhone 14 Pro+):
  - Compact: Иконка + оставшееся время
  - Expanded: Название режима, время, прогресс-бар
- **Real-time updates**: Обновление каждую секунду
- **Поддержка обоих режимов**: Pomodoro и Workout

### Недавние исправления (v0.9.1)
**Проблема**: Live Activity "замораживалась" в фоне после 3-5 минут

**Решение - Variant A**:
1. **DispatchSourceTimer** вместо Timer - более надежен в фоне
2. **staleDate** - индикатор устаревших данных через 5 секунд
3. **ProcessInfo.performExpiringActivity** - продление времени в фоне до ~30 сек

**Результат**:
- ✅ Foreground: обновления каждую секунду
- ✅ Background (0-30s): продолжает обновляться
- ✅ Background (30s+): показывает "stale" индикатор
- ✅ Notifications: 100% надежность
- ✅ Без Background Modes (App Store safe)

### Файлы
- **Extension**: `FocusGardenWidget/FocusGardenWidget.swift`
- **Integration**: `TimerViewModel.swift` (LiveActivityManager), `WorkoutTimerViewModel.swift`
- **Models**: `TimerActivityAttributes` (ContentState с workout support)

---

## 📊 Статистика и Аналитика

### Pomodoro Статистика
**Метрики:**
- Сегодняшние Pomodoros
- Всего Pomodoros
- Фокус-время (всего)
- Текущая серия
- За последнюю неделю/месяц
- Средние сессии в день

**Визуализация:**
- График активности (Charts framework, iOS 16+)
- Календарь активности (90 дней)
- Достижения (лучший день, серия)

### Workout Статистика
**Метрики:**
- Сегодняшние циклы
- Всего циклов
- Время тренировок
- Текущая серия
- За последнюю неделю/месяц
- Среднее время тренировки

**Визуализация:**
- График циклов
- Календарь активности
- Достижения

### Файлы
- `StatisticsView.swift` - основной экран с переключателем режимов
- `WorkoutStatisticsView.swift` - workout-специфичная статистика

---

## ⚙️ Настройки

### Pomodoro Settings
- Focus Time: 5-60 минут (шаг 5 мин)
- Break Time: 1-15 минут (шаг 1 мин)
- Long Break Time: 5-30 минут (шаг 5 мин)

### Workout Settings
- Exercise Time: 5-90 секунд (шаг 5 сек, минимум 5 сек)
- Rest Time: 5-90 секунд (шаг 5 сек, минимум 5 сек)

### Общие настройки
- Sound Enabled (для обоих режимов)
- Language: English / Русский
- Theme: Automatic / Light / Dark
- iCloud Sync: ON/OFF

### Файлы
- `SettingsView.swift` - основной экран настроек

---

## 🏗️ Техническая архитектура

### Технологии
- **SwiftUI** - UI framework
- **Combine** - реактивное управление состоянием
- **MVVM** - архитектурный паттерн
- **UserDefaults** - локальное хранилище
- **iCloud (NSUbiquitousKeyValueStore)** - синхронизация
- **Charts** - графики (iOS 16+)
- **AVFoundation** - звуковые уведомления
- **ActivityKit** - Live Activity (iOS 16.1+)
- **UserNotifications** - push уведомления

### Минимальные требования
- **iOS 15.0+** (основное приложение)
- **iOS 16.1+** (для Live Activity)
- **Xcode 14.0+**
- **Swift 5.7+**

---

## 📁 Структура проекта

```
focusgarden/
├── FocusGarden/                      # Main app target
│   ├── FocusGardenApp.swift          # App entry point
│   ├── Models/
│   │   ├── AppMode.swift             # Pomodoro/Workout enum
│   │   ├── TimerSettings.swift       # Pomodoro настройки
│   │   ├── WorkoutSettings.swift     # Workout настройки
│   │   ├── WorkoutMode.swift         # Exercise/Rest enum
│   │   ├── Progress.swift            # Pomodoro прогресс
│   │   ├── WorkoutProgress.swift     # Workout прогресс
│   │   ├── DailyRecord.swift         # Pomodoro дневник
│   │   ├── WorkoutRecord.swift       # Workout дневник
│   │   ├── AppLanguage.swift         # Язык приложения
│   │   └── AppTheme.swift            # Тема приложения
│   ├── ViewModels/
│   │   ├── AppViewModel.swift        # Главный VM (оба режима)
│   │   ├── TimerViewModel.swift      # Pomodoro логика
│   │   └── WorkoutTimerViewModel.swift # Workout логика
│   ├── Views/
│   │   ├── ContentView.swift         # Основной layout
│   │   ├── TimerView.swift           # Pomodoro таймер UI
│   │   ├── GardenView.swift          # Виртуальный сад
│   │   ├── ProgressTrackerView.swift # Pomodoro карточки
│   │   ├── WorkoutTimerView.swift    # Workout таймер UI
│   │   ├── GymView.swift             # Виртуальный спортзал
│   │   ├── WorkoutProgressTrackerView.swift # Workout карточки
│   │   ├── CycleSelectorView.swift   # Выбор циклов
│   │   ├── StatisticsView.swift      # Статистика (оба режима)
│   │   ├── WorkoutStatisticsView.swift # Workout статистика
│   │   └── SettingsView.swift        # Настройки
│   ├── Managers/
│   │   ├── StorageManager.swift      # UserDefaults + iCloud
│   │   ├── SoundManager.swift        # Звуки и haptics
│   │   └── NotificationManager.swift # Push уведомления
│   └── Helpers/
│       └── Extensions.swift          # Utility расширения
│
├── FocusGardenWidget/                # Widget Extension (Live Activity)
│   └── FocusGardenWidget.swift       # Live Activity implementation
│
└── docs/
    ├── CURRENT_APP_STATE.md         # Этот файл
    └── archive/                      # Старая документация
```

---

## 🔧 Ключевые компоненты

### AppViewModel
**Ответственность**: Главное состояние приложения
- Управление AppMode (Pomodoro/Workout)
- Инициализация ViewModels для обоих режимов
- Координация между режимами
- Обработка завершения циклов
- Разблокировка наград

**Ключевые свойства**:
```swift
@Published var appMode: AppMode
@Published var timerSettings: TimerSettings
@Published var workoutSettings: WorkoutSettings
@Published var progress: Progress
@Published var workoutProgress: WorkoutProgress
var timerViewModel: TimerViewModel
var workoutTimerViewModel: WorkoutTimerViewModel
```

### TimerViewModel
**Ответственность**: Логика Pomodoro таймера
- Управление состоянием таймера (focus/break)
- DispatchSourceTimer для надежности в фоне
- Live Activity интеграция
- Background persistence (UserDefaults)
- Уведомления

**Ключевые методы**:
- `toggleTimer()` - старт/пауза
- `resetTimer()` - сброс
- `switchMode()` - переключение режимов
- `startLiveActivity()` / `updateLiveActivity()` / `endLiveActivity()`

### WorkoutTimerViewModel
**Ответственность**: Логика Workout таймера
- Управление интервальными тренировками
- Автопереключение Exercise ⇄ Rest
- Подсчет циклов
- DispatchSourceTimer для фона
- Live Activity с workout state
- Background persistence

**Ключевые методы**:
- `startWorkout(cycles:)` - старт с N циклами
- `pauseWorkout()` / `resumeWorkout()` - пауза/возобновление
- `stopWorkout()` - полная остановка
- `handleTimerComplete()` - автопереключение режимов

### StorageManager
**Ответственность**: Персистентность данных
- UserDefaults для локального хранения
- iCloud (NSUbiquitousKeyValueStore) для синхронизации
- Методы load/save для всех моделей

**Ключевые методы**:
```swift
// Pomodoro
func loadTimerSettings() / saveTimerSettings()
func loadProgress() / saveProgress()
func loadDailyRecords() / saveDailyRecords()

// Workout
func loadWorkoutSettings() / saveWorkoutSettings()
func loadWorkoutProgress() / saveWorkoutProgress()

// App State
func loadAppMode() / saveAppMode()
func loadLanguage() / saveLanguage()
func loadTheme() / saveTheme()
```

### NotificationManager
**Ответственность**: Push уведомления
- Запрос разрешений
- Планирование уведомлений по endTime
- Отдельные уведомления для Pomodoro/Workout
- Отмена при остановке таймера

### SoundManager
**Ответственность**: Звуки и haptics
- AVAudioPlayer для звуковых эффектов
- UIImpactFeedbackGenerator для haptics
- Singleton pattern

---

## 🎨 Дизайн и UI

### Цветовая схема

**Pomodoro**:
- Focus: Зеленый (`FocusColor`)
- Short Break: Желтый (`BreakColor`)
- Long Break: Синий (`LongBreakColor`)

**Workout**:
- Exercise: Оранжевый (`ExerciseOrange`)
- Rest: Синий (`RestBlue`)

**Темы**:
- Light mode: белый фон, темный текст
- Dark mode: темный фон, светлый текст
- Automatic: следует системной теме

### Локализация
**Поддерживаемые языки**: English, Русский

**Файлы**:
- `en.lproj/Localizable.strings`
- `ru.lproj/Localizable.strings`

**Ключевые строки**:
- Все UI labels
- Названия режимов
- Статистика
- Настройки
- Уведомления

---

## 🔄 Lifecycle и State Management

### App Lifecycle
1. **Launch**: AppViewModel инициализирует оба ViewModels
2. **Load**: StorageManager загружает сохраненные данные
3. **Restore**: TimerViewModel/WorkoutTimerViewModel восстанавливают таймеры из UserDefaults
4. **Background**: NotificationCenter observers для didEnterBackground/willEnterForeground
5. **Terminate**: Автосохранение через UserDefaults

### Timer State Flow

**Pomodoro**:
```
Init → Focus Time → (Play) → Running → (Complete) → Short/Long Break → Focus Time...
                  ↓ (Pause)
                  Paused → (Resume) → Running
```

**Workout**:
```
Init → Idle → (Start + Select Cycles) → Exercise → Rest → Exercise... → Complete
                                      ↓ (Pause)
                                      Paused → (Resume) → Continue
```

### Live Activity State
```
No Timer → (Start Timer) → Activity.request() → Active → Updates every second
                                                      ↓ (Complete/Stop)
                                                      Activity.end() → Dismissed
```

---

## 🐛 Известные особенности и ограничения

### Live Activity Background
- **0-30 секунд**: ProcessInfo.performExpiringActivity работает
- **30+ секунд**: iOS может приостановить обновления
- **5+ секунд без обновлений**: показывается "stale" индикатор
- **Notifications**: всегда работают 100% надежно

### Performance
- **GardenView**: лимит 10 деревьев для производительности
- **GymView**: лимит 12 гантелей
- **Charts**: требует iOS 16+ (fallback для iOS 15)

### iCloud
- Синхронизация прогресса между устройствами
- Требует включенный iCloud в настройках
- Конфликты разрешаются по принципу "последний выигрывает"

---

## 🚀 Недавние изменения (v0.9.1)

### Исправления
1. **Live Activity Background Freeze** ✅
   - Заменен Timer на DispatchSourceTimer
   - Добавлен staleDate для индикации устаревших данных
   - ProcessInfo.performExpiringActivity для продления фона
   - Файлы: TimerViewModel.swift, WorkoutTimerViewModel.swift

2. **Workout Minimum Times** ✅
   - Минимум Exercise/Rest изменен с 0 на 5 секунд
   - Файл: SettingsView.swift

### Коммиты
- `690e433` - WIP: Fix Live Activity freezing (Variant A)
- `1c7c00d` - Complete Variant A: Fix Live Activity freezing
- `8417559` - Set minimum workout times to 5 seconds

---

## 📝 Заметки для разработки

### При добавлении новых функций

1. **Новые модели**: Добавить в Models/ + StorageManager
2. **Новые настройки**: AppViewModel + SettingsView + локализация
3. **Новые экраны**: Views/ + навигация в ContentView
4. **Live Activity**: Обновить TimerActivityAttributes.ContentState
5. **Статистика**: Обновить соответствующий StatisticsView

### Тестирование

**Обязательные проверки**:
- [ ] Foreground timer работает
- [ ] Background timer продолжает работать
- [ ] Live Activity обновляется
- [ ] Notifications приходят вовремя
- [ ] Persistence работает (kill app → restore)
- [ ] iCloud sync (между устройствами)
- [ ] Оба режима (Pomodoro + Workout)
- [ ] Обе темы (Light + Dark)
- [ ] Обе локализации (EN + RU)

### Build конфигурация

**Targets**:
- FocusGarden (main app)
- FocusGardenWidget (widget extension)

**Версии должны совпадать**:
- Version: 0.9.1
- Build: 4

**Capabilities**:
- Push Notifications
- Background Modes: Remote notifications (для Live Activity)

---

## 🔮 Планы на будущее (из плана)

### Версия 0.10
- Исправление мелких багов
- Оптимизация производительности
- Тестирование на разных устройствах

### Версия 1.0
- Beta тестирование
- App Store submission
- Marketing материалы

### Будущие версии
- Apple Watch приложение
- Health Kit integration
- Кастомные программы тренировок
- Challenges и achievements
- Social sharing

---

## 📚 Полезные ссылки

- **GitHub**: https://github.com/kyzdes/FocusGarden
- **Branch**: ver-0.9.1
- **План реализации**: `.claude/plans/unified-rolling-cupcake.md`
- **Архив документации**: `docs/archive/`

---

*Документ создан для быстрого понимания текущего состояния приложения при восстановлении контекста*
