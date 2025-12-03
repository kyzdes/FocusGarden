# Focus Garden - iOS App

A beautiful, modern Pomodoro timer app for iOS that helps you stay focused and grow a virtual garden as you complete work sessions.

## Features

### 🍅 Pomodoro Timer
- **Focus Sessions**: Customizable focus time (5-60 minutes, default 25 minutes)
- **Break Times**: Short breaks (1-15 minutes) and long breaks (5-30 minutes)
- **Auto-Switching**: Automatically switches between focus and break modes
- **Circular Progress**: Beautiful circular progress indicator
- **Sound Notifications**: Optional completion sounds with haptic feedback

### 🌱 Virtual Garden
- **Growing Garden**: Watch your garden grow as you complete Pomodoros
- **Trees**: Earn a tree for every completed Pomodoro
- **Clouds**: Unlock clouds every 2 Pomodoros
- **Animals**: Unlock special animals at milestones:
  - 🦋 Butterfly at 3 Pomodoros
  - 🐦 Bird at 7 Pomodoros
  - 🐰 Rabbit at 15 Pomodoros
  - 🦌 Deer at 25 Pomodoros
  - 🦊 Fox at 40 Pomodoros
- **Smooth Animations**: Beautiful animations bring your garden to life

### 📊 Statistics & Analytics
- **Activity Charts**: Visualize your productivity over time
- **Time Ranges**: View stats for the week, month, or all time
- **Key Metrics**:
  - Total Pomodoros completed
  - Total focus time
  - Current streak
  - Average sessions per day
- **Achievements**: Track your best day and streaks
- **Activity Calendar**: 90-day heatmap view of your activity
- **Progress Tracking**: Daily, weekly, and total statistics

### ⚙️ Customization
- Adjustable timer durations for all modes
- Toggle sound notifications
- Clean, intuitive settings interface
- Automatic data persistence

### 💾 Local Storage
- All data stored locally using UserDefaults
- No backend required
- Privacy-focused - your data never leaves your device
- Automatic daily tracking and streak calculation

## Technical Details

### Requirements
- iOS 15.0 or later
- Xcode 14.0 or later
- Swift 5.7 or later

### Architecture
- **SwiftUI** for modern, declarative UI
- **Combine** for reactive state management
- **MVVM** architecture pattern
- **UserDefaults** for persistent storage
- **Charts** framework for statistics visualization (iOS 16+)
- **AVFoundation** for sound notifications

### Project Structure
```
FocusGarden/
├── FocusGardenApp.swift          # App entry point
├── Models/
│   ├── TimerSettings.swift       # Timer configuration model
│   ├── Progress.swift            # User progress model
│   └── DailyRecord.swift         # Daily statistics model
├── ViewModels/
│   ├── AppViewModel.swift        # Main app state management
│   └── TimerViewModel.swift      # Timer logic and state
├── Views/
│   ├── ContentView.swift         # Main app layout
│   ├── TimerView.swift           # Pomodoro timer UI
│   ├── GardenView.swift          # Virtual garden display
│   ├── SettingsView.swift        # Settings screen
│   ├── StatisticsView.swift      # Statistics and charts
│   └── ProgressTrackerView.swift # Quick stats widget
├── Managers/
│   ├── StorageManager.swift      # UserDefaults persistence
│   └── SoundManager.swift        # Audio and haptics
└── Helpers/
    └── Extensions.swift           # Utility extensions
```

## Building the App

### Step 1: Open in Xcode
1. Open `FocusGarden.xcodeproj` in Xcode
2. Select your development team in the Signing & Capabilities tab
3. Choose your target device or simulator

### Step 2: Configure Bundle Identifier
1. Select the project in the navigator
2. Under "Signing & Capabilities", update the Bundle Identifier to something unique (e.g., `com.yourname.FocusGarden`)

### Step 3: Build and Run
1. Press `Cmd + R` or click the Run button
2. The app will build and launch on your selected device/simulator

## Features in Detail

### Timer Modes
- **Focus Mode**: Work period with green color theme
- **Short Break**: Brief rest period with blue color theme
- **Long Break**: Extended rest after 4 focus sessions with purple color theme

### Data Persistence
All user data is automatically saved:
- Timer settings
- Progress statistics
- Daily records
- Garden state
- Streak information

### Responsive Design
- Optimized for iPhone (all sizes)
- iPad support with adaptive layout
- Portrait and landscape orientations
- Dark mode compatible (system theme)

## Color Scheme
- **Focus Green**: `#9ed9c5`
- **Break Blue**: `#a8c5e0`
- **Long Break Purple**: `#d4a5c8`
- **Sky Blue**: `#e3f2f7`
- **Grass Green**: `#f0f7e8`

## Design Philosophy
- **Neumorphic Design**: Soft shadows and subtle depth
- **Calm Colors**: Soothing pastel palette
- **Smooth Animations**: Delightful micro-interactions
- **Clear Typography**: Readable, rounded system fonts
- **Minimal Interface**: Focus on what matters

## Privacy
- No data collection
- No analytics
- No network requests
- All data stored locally on device
- No sign-in required

## License
This project is provided as-is for personal and educational use.

## Credits
Based on the Focus Garden web app design
Built with SwiftUI and modern iOS technologies

---

**Enjoy growing your focus garden! 🌱**
