# Apple Watch Companion App Setup Guide

This guide will help you configure the Xcode project to add Apple Watch support to FocusGarden.

## Overview

The Watch app companion has been prepared with all necessary code files. You now need to:
1. Create a Watch App target in Xcode
2. Add the shared models to both iOS and Watch targets
3. Configure App Groups for offline data sync
4. Integrate WatchConnectivity in the iOS app

## Step 1: Create Watch App Target

1. Open `focusgarden.xcodeproj` in Xcode
2. Select the project in the Navigator
3. Click the "+" button at the bottom of the targets list
4. Select **watchOS** → **Watch App**
5. Configure the target:
   - Product Name: `FocusGarden Watch App`
   - Team: Your development team
   - Organization Identifier: Same as iOS app
   - Bundle Identifier: `com.yourcompany.focusgarden.watchkitapp`
   - Language: Swift
   - Interface: SwiftUI
   - Include Notification Scene: No (can add later)
6. Click **Finish**

Xcode will create a new Watch App target and scheme.

## Step 2: Add Shared Models to Targets

### 2.1 Add Shared Models to iOS Target

1. In Xcode Navigator, select the `Shared/Models` folder
2. For each file in `Shared/Models/`:
   - Right-click → **Show File Inspector** (⌥⌘1)
   - Under **Target Membership**, check **focusgarden** (iOS)
   - Also check **FocusGarden Watch App**

Files to add:
- `AppMode.swift`
- `TimerMode.swift`
- `WorkoutMode.swift`
- `TimerSettings.swift`
- `WorkoutSettings.swift`

### 2.2 Add WatchConnectivity Files

1. Select all files in `Shared/WatchConnectivity/`:
   - `WatchMessageType.swift`
   - `TimerState.swift`
   - `WatchMessage.swift`
2. In File Inspector, check both **focusgarden** and **FocusGarden Watch App** targets

### 2.3 Add Watch App Files to Watch Target

1. Select `FocusGarden Watch App` folder
2. For each file, ensure **FocusGarden Watch App** target is checked:
   - `FocusGardenApp.swift`
   - `ViewModels/WatchViewModel.swift`
   - `Managers/WatchConnectivityManager.swift` (Watch version)
   - `Views/ContentView.swift`
   - `Views/PomodoroTimerView.swift`
   - `Views/WorkoutTimerView.swift`

### 2.4 Add iOS WatchConnectivityManager to iOS Target

1. Select `FocusGarden/Managers/WatchConnectivityManager.swift`
2. In File Inspector, check **focusgarden** target only (NOT Watch target)

## Step 3: Configure App Groups

App Groups allow data sharing between iOS and Watch apps when they're not actively communicating.

### 3.1 Enable App Groups for iOS App

1. Select the **focusgarden** target
2. Go to **Signing & Capabilities** tab
3. Click **+ Capability**
4. Add **App Groups**
5. Click **+** and create: `group.com.focusgarden.app`
   (Replace `com.focusgarden` with your actual bundle ID prefix)

### 3.2 Enable App Groups for Watch App

1. Select the **FocusGarden Watch App** target
2. Go to **Signing & Capabilities** tab
3. Click **+ Capability**
4. Add **App Groups**
5. Select the **same group**: `group.com.focusgarden.app`

### 3.3 Update Code with Correct App Group ID

If your App Group ID is different, update these files:

**iOS:** `FocusGarden/Managers/WatchConnectivityManager.swift`
**Watch:** `FocusGarden Watch App/Managers/WatchConnectivityManager.swift`

Find lines with:
```swift
UserDefaults(suiteName: "group.com.focusgarden.app")
```

Replace with your actual App Group ID.

## Step 4: Integrate WatchConnectivity with iOS ViewModels

### 4.1 Update AppViewModel.swift

Add WatchConnectivityManager initialization and sync methods.

At the top of the file, add:
```swift
private let watchManager = WatchConnectivityManager.shared
```

In `init()`, after existing setup, add:
```swift
setupWatchConnectivity()
```

Add a new method:
```swift
private func setupWatchConnectivity() {
    // Setup Watch command callbacks
    watchManager.onStartTimer = { [weak self] in
        self?.timerViewModel.toggleTimer()
    }

    watchManager.onPauseTimer = { [weak self] in
        if self?.timerViewModel.isRunning == true {
            self?.timerViewModel.toggleTimer()
        }
    }

    watchManager.onResumeTimer = { [weak self] in
        if self?.timerViewModel.isRunning == false {
            self?.timerViewModel.toggleTimer()
        }
    }

    watchManager.onResetTimer = { [weak self] in
        self?.timerViewModel.resetTimer()
    }

    watchManager.onSwitchMode = { [weak self] mode in
        self?.timerViewModel.switchMode(mode)
    }

    watchManager.onSwitchAppMode = { [weak self] mode in
        self?.appMode = mode
    }

    watchManager.onStartWorkout = { [weak self] cycles in
        self?.workoutTimerViewModel.startWorkout(cycles: cycles)
    }

    watchManager.onStopWorkout = { [weak self] in
        self?.workoutTimerViewModel.stopWorkout()
    }

    // Listen for sync requests
    NotificationCenter.default.addObserver(
        forName: .watchRequestedSync,
        object: nil,
        queue: .main
    ) { [weak self] _ in
        self?.sendFullSyncToWatch()
    }

    NotificationCenter.default.addObserver(
        forName: .watchSessionActivated,
        object: nil,
        queue: .main
    ) { [weak self] _ in
        self?.sendFullSyncToWatch()
    }
}

private func sendFullSyncToWatch() {
    // Send current settings
    watchManager.sendSettingsUpdate(timer: settings, workout: workoutSettings)

    // Send progress
    watchManager.sendProgressUpdate(
        todayCount: progress.todayPomodoros,
        streak: progress.currentStreak
    )

    // Send timer state (will be added in next step)
    sendTimerStateToWatch()
}

private func sendTimerStateToWatch() {
    if appMode == .pomodoro {
        let state = TimerState.pomodoroState(
            isRunning: timerViewModel.isRunning,
            timeLeft: timerViewModel.timeLeft,
            progress: timerViewModel.progress,
            mode: timerViewModel.mode,
            completedCycles: timerViewModel.completedCycles
        )
        watchManager.sendTimerState(state)
    } else {
        let state = TimerState.workoutState(
            isRunning: workoutTimerViewModel.isRunning,
            timeLeft: workoutTimerViewModel.timeLeft,
            progress: workoutTimerViewModel.progress,
            mode: workoutTimerViewModel.mode,
            currentCycle: workoutTimerViewModel.currentCycle,
            totalCycles: workoutTimerViewModel.totalCycles,
            isActive: workoutTimerViewModel.isWorkoutActive
        )
        watchManager.sendTimerState(state)
    }
}
```

### 4.2 Update TimerViewModel.swift

Add Watch sync calls when timer state changes.

At the top, add:
```swift
private let watchManager = WatchConnectivityManager.shared
```

In the `tick()` method, after updating `timeLeft`, add:
```swift
// Sync to Watch every 5 seconds to conserve battery
if timeLeft % 5 == 0 {
    sendStateToWatch()
}
```

In `toggleTimer()`, after state changes, add:
```swift
sendStateToWatch()
```

In `resetTimer()`, after resetting, add:
```swift
sendStateToWatch()
```

In `switchMode()`, after mode change, add:
```swift
sendStateToWatch()
```

Add a new method:
```swift
private func sendStateToWatch() {
    let state = TimerState.pomodoroState(
        isRunning: isRunning,
        timeLeft: timeLeft,
        progress: progress,
        mode: mode,
        completedCycles: completedCycles
    )
    watchManager.sendTimerState(state)
}
```

### 4.3 Update WorkoutTimerViewModel.swift

Similar to TimerViewModel, add Watch sync calls.

At the top:
```swift
private let watchManager = WatchConnectivityManager.shared
```

In `tick()`, sync every 3 seconds:
```swift
if timeLeft % 3 == 0 {
    sendStateToWatch()
}
```

In `startWorkout()`, `toggleTimer()`, `stopWorkout()`, add:
```swift
sendStateToWatch()
```

Add method:
```swift
private func sendStateToWatch() {
    let state = TimerState.workoutState(
        isRunning: isRunning,
        timeLeft: timeLeft,
        progress: progress,
        mode: mode,
        currentCycle: currentCycle,
        totalCycles: totalCycles,
        isActive: isWorkoutActive
    )
    watchManager.sendTimerState(state)
}
```

## Step 5: Update iOS Models to Use Shared Models

### 5.1 Remove Old Enum Definitions

In `FocusGarden/ViewModels/TimerViewModel.swift`, **remove** the `TimerMode` enum definition (lines 15-47).
Instead, import it from Shared at the top:
```swift
// TimerMode is now in Shared/Models/TimerMode.swift
```

In `FocusGarden/Models/`, **delete** or update references:
- `AppMode.swift` → Now in `Shared/Models/`
- `WorkoutMode.swift` → Now in `Shared/Models/`

Keep other models that aren't shared (Progress.swift, DailyRecord.swift, etc.)

### 5.2 Update Import Statements

If you created a framework, add import statements:
```swift
import FocusGardenShared
```

If files are just added to both targets (simpler approach), no imports needed.

## Step 6: Build and Test

### 6.1 Build iOS App

1. Select **focusgarden** scheme
2. Select iPhone simulator or device
3. Build (⌘B)
4. Fix any compilation errors related to:
   - Missing `public` keywords
   - Missing initializers
   - Target membership issues

### 6.2 Build Watch App

1. Select **FocusGarden Watch App** scheme
2. Select Apple Watch simulator or paired device
3. Build (⌘B)
4. Fix any compilation errors

### 6.3 Test Communication

1. Run iOS app on iPhone simulator
2. Run Watch app on paired Watch simulator
3. Verify:
   - Start/pause timer on Watch → should control iPhone timer
   - Timer running on iPhone → should update on Watch
   - Switch modes → should sync between devices
   - Check offline mode → disconnect Watch, verify last state shows

## Step 7: Add Watch App Icons

1. In `FocusGarden Watch App/Assets.xcassets/AppIcon.appiconset`
2. Add required icon sizes:
   - 1024×1024 (App Store)
   - 196×196, 216×216, 234×234 (Watch faces)
   - 48×48, 55×55, 58×58, 80×80, 87×87, 88×88 (various sizes)

You can use the same design as iOS app icon, simplified for smaller sizes.

## Troubleshooting

### "No such module 'FocusGardenShared'"

- If using framework approach: Ensure framework is built and linked
- If using file sharing: Remove import statements, files should be directly accessible

### Watch app won't install

- Ensure deployment target matches (watchOS 9.0+)
- Check bundle identifiers are correct
- Verify signing is configured for both targets

### Communication not working

- Check App Group IDs match exactly
- Verify WCSession is activated (check console logs)
- Ensure Watch is paired and reachable
- Test on real devices (simulators sometimes have connectivity issues)

### Compilation errors in ViewModels

- Add `public` to enum cases and properties in Shared models
- Ensure all Shared types have public initializers

## Optional Enhancements

### Complications (Future)

To add Watch complications:
1. File → New → Target → Complications Extension
2. Create complication providers showing timer state
3. Update complications when timer changes

### Independent Watch Operation (Future)

To allow Watch to run timers independently:
1. Add local timer logic to WatchViewModel
2. Add conflict resolution (timestamp-based)
3. Sync changes back to iPhone when reconnected

## Summary

After completing this setup:
- ✅ Watch app shows current timer state from iPhone
- ✅ Watch controls start/pause/reset timers on iPhone
- ✅ Mode switching synced between devices
- ✅ Offline mode shows last known state
- ✅ Haptic feedback on Watch for interactions
- ✅ Progress tracking visible on Watch

The Watch app is a companion that mirrors and controls the iPhone app, providing convenient wrist-based access to FocusGarden timers.
