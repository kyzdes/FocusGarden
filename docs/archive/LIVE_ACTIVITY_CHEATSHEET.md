# Live Activity - Cheat Sheet

## 🏗️ Архитектура

```
┌─────────────────────────────────────────────────────────────┐
│                     FocusGarden App                         │
│  ┌───────────────────────────────────────────────────────┐  │
│  │           TimerViewModel.swift                        │  │
│  │                                                       │  │
│  │  startTimer() {                                       │  │
│  │    LiveActivityManager.shared.start(...)  ───────┐   │  │
│  │  }                                               │   │  │
│  │                                                  │   │  │
│  │  Update every second:                           │   │  │
│  │    LiveActivityManager.shared.update(...)  ─────┤   │  │
│  └──────────────────────────────────────────────────┼───┘  │
└─────────────────────────────────────────────────────┼──────┘
                                                       │
                    Uses TimerActivityAttributes      │
                    (from Shared folder)              │
                                                       │
┌──────────────────────────────────────────────────────┼──────┐
│                  ActivityKit Framework               ▼      │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  Activity<TimerActivityAttributes>.request(...)        │ │
│  │  Activity.update(...)                                  │ │
│  │  Activity.end(...)                                     │ │
│  └────────────────────────────┬───────────────────────────┘ │
└────────────────────────────────┼─────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────┐
│              FocusGardenWidget Extension                    │
│  ┌───────────────────────────────────────────────────────┐  │
│  │    FocusGardenWidget.swift                            │  │
│  │                                                       │  │
│  │    ActivityConfiguration {                            │  │
│  │      // Lock Screen View                              │  │
│  │      LockScreenLiveActivityView(...)                  │  │
│  │                                                       │  │
│  │      dynamicIsland: {                                 │  │
│  │        // Compact leading: Icon                       │  │
│  │        // Compact trailing: Time                      │  │
│  │        // Minimal: Progress circle                    │  │
│  │        // Expanded: Full details                      │  │
│  │      }                                                │  │
│  │    }                                                  │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────┐
│                       iOS System                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │   Dynamic    │  │  Lock Screen │  │   Notification   │  │
│  │   Island     │  │    Banner    │  │     Center       │  │
│  └──────────────┘  └──────────────┘  └──────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## 📊 Поток данных

```
Timer starts
    ↓
TimerViewModel calculates endTime
    ↓
LiveActivityManager.start(title, mode, totalSeconds, remainingSeconds)
    ↓
Activity<TimerActivityAttributes>.request(attributes, content)
    ↓
iOS shows Live Activity in:
    • Dynamic Island (iPhone 14 Pro+)
    • Lock Screen (all devices)
    • Notification Center (when dismissed)
    ↓
Every second: TimerViewModel updates
    ↓
LiveActivityManager.update(mode, totalSeconds, remainingSeconds)
    ↓
Activity.update(content)
    ↓
UI updates automatically
    ↓
Timer completes
    ↓
LiveActivityManager.end()
    ↓
Activity dismissed
```

## 🎨 Visual Layout

### Dynamic Island - Compact
```
┌────────────────────────────────────┐
│  [🧠]  · · · · · · · · ·  [25:00] │  iPhone notch area
└────────────────────────────────────┘
   ↑                            ↑
   Icon                      Time
   (mode color)              (mode color)
```

### Dynamic Island - Minimal
```
┌─────┐
│ ⭕️  │  Circular progress with icon
│ 🧠  │
└─────┘
```

### Dynamic Island - Expanded (Long Press)
```
┌─────────────────────────────────────────┐
│  🧠 Focus Time          Remaining       │ ← Leading + Trailing
│     Focus Garden           25:00        │
│                                         │
│ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─     │
│                                         │
│  Focus Time                       45%   │ ← Bottom region
│  ▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░      │   (progress bar)
│                                         │
│  ⏱️ 25:00              🕐 55:00        │   (remaining / total)
└─────────────────────────────────────────┘
```

### Lock Screen
```
┌─────────────────────────────────────┐
│                                     │
│  🧠  Focus Garden                   │
│      Focus Time                     │
│                                     │
│                          25:00      │
│                       remaining     │
│                                     │
│  ▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░       │
│                                     │
└─────────────────────────────────────┘
```

## 🎯 Mode Colors & Icons

| Mode | Color | Hex | Icon | SF Symbol |
|------|-------|-----|------|-----------|
| **Focus** | 🔵 Blue | `#4D7FE6` | 🧠 | `brain.head.profile` |
| **Short Break** | 🟢 Green | `#4DCC99` | ☕️ | `cup.and.saucer` |
| **Long Break** | 🟠 Orange | `#E67F4D` | 🛋️ | `cup.and.saucer.fill` |

## 📱 Device Support

| Device | Dynamic Island | Lock Screen | Notes |
|--------|----------------|-------------|-------|
| iPhone 14 Pro | ✅ | ✅ | Full support |
| iPhone 14 Pro Max | ✅ | ✅ | Full support |
| iPhone 15 Pro | ✅ | ✅ | Full support |
| iPhone 15 Pro Max | ✅ | ✅ | Full support |
| iPhone 16 Pro | ✅ | ✅ | Full support |
| Other iPhones | ❌ | ✅ | Lock Screen only |

## ⚙️ Key Settings

### Info.plist (Main App)
```xml
<key>NSSupportsLiveActivities</key>
<true/>
<key>NSSupportsLiveActivitiesFrequentUpdates</key>
<true/>
```

### iOS Deployment Target
```
iOS 16.1 или выше (обязательно!)
```

### TimerActivityAttributes
```
Определен в двух местах с идентичной структурой:
├─ FocusGarden/ViewModels/TimerViewModel.swift (для основного приложения)
└─ FocusGardenWidget/FocusGardenWidget.swift (для widget extension)
```

## 🔄 Update Frequency

```swift
// TimerViewModel.swift - Line 227
Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true)
    ↓
updateLiveActivity(remaining: remaining)
    ↓
Activity updates every second
```

**iOS Limits:**
- Max update frequency: ~1 Hz (every second) ✅
- Max active duration: 8 hours
- Max dismissal policy: `.immediate`, `.after(TimeInterval)`

## 🚀 Quick Commands

### Build & Run
```bash
# Clean build
⌘ + Shift + K

# Run
⌘ + R

# Run on device
Select device → ⌘ + R
```

### Testing
```bash
# Test Dynamic Island
1. Run app on iPhone 14 Pro+
2. Start timer
3. Swipe home (not up to close!)
4. See Dynamic Island

# Test Lock Screen
1. Start timer
2. Lock device (Power button)
3. Wake device
4. See Live Activity banner

# Test Expanded view
1. Long press on Dynamic Island
2. See full details
```

## 🐛 Debug Checklist

```
❌ Live Activity not showing
   → Check Info.plist has NSSupportsLiveActivities
   → Check device Settings → Live Activities enabled
   → Check iOS version >= 16.1

❌ Dynamic Island not showing
   → Device must be iPhone 14 Pro or newer
   → Check you swiped home (not closed app)

❌ Build errors
   → Clean build folder (⌘⇧K)
   → Check Target Membership for shared files
   → Check iOS Deployment Target >= 16.1

❌ Updates not working
   → Check timer is running (isRunning = true)
   → Check Activity.update() is called
   → Check ContentState values are changing
```

## 📚 API Reference

### Start Live Activity
```swift
LiveActivityManager.shared.start(
    title: "Focus Garden",
    mode: .focus,
    totalSeconds: 1500,
    remainingSeconds: 1500
)
```

### Update Live Activity
```swift
LiveActivityManager.shared.update(
    mode: .focus,
    totalSeconds: 1500,
    remainingSeconds: 900
)
```

### End Live Activity
```swift
LiveActivityManager.shared.end()
```

## 🎓 Best Practices

1. **Start early**: Call `.start()` immediately when timer begins
2. **Update frequently**: Every second for smooth progress
3. **End properly**: Always call `.end()` when timer stops
4. **Handle background**: Save state in UserDefaults
5. **Color code**: Use consistent colors for modes
6. **Test on device**: Simulator has limited Live Activity support

---

**Quick Start**: See [ИНСТРУКЦИЯ_LIVE_ACTIVITY.md](ИНСТРУКЦИЯ_LIVE_ACTIVITY.md)
**Full Guide**: See [LIVE_ACTIVITY_SETUP.md](LIVE_ACTIVITY_SETUP.md)
