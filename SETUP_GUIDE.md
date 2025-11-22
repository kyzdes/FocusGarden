# Focus Garden iOS App - Setup Guide

## Quick Start

### Prerequisites
- macOS 12.0 (Monterey) or later
- Xcode 14.0 or later
- iOS device or simulator running iOS 15.0+

### Option 1: Manual Xcode Project Setup (Recommended)

Since the project files are provided as source code, follow these steps to create a working Xcode project:

#### Step 1: Create New Xcode Project
1. Open Xcode
2. Select "Create a new Xcode project"
3. Choose "iOS" → "App"
4. Configure your project:
   - Product Name: `FocusGarden`
   - Team: Select your development team
   - Organization Identifier: `com.yourname` (or your preferred identifier)
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **None** (we'll use UserDefaults)
   - Include Tests: Optional
5. Choose a location to save the project

#### Step 2: Add Source Files
1. In Xcode, delete the default `ContentView.swift` and `FocusGardenApp.swift` files
2. In Finder, navigate to `FocusGarden/FocusGarden/FocusGarden/` directory
3. Drag and drop all the folders into your Xcode project:
   - Models/
   - ViewModels/
   - Views/
   - Managers/
   - Helpers/
   - FocusGardenApp.swift
4. When prompted, select:
   - ✅ Copy items if needed
   - ✅ Create groups
   - ✅ Add to targets: FocusGarden

#### Step 3: Configure Project Settings
1. Select the project in the navigator
2. Under "General" tab:
   - Display Name: `Focus Garden`
   - Bundle Identifier: Update if needed
   - Deployment Target: Set to iOS 15.0 or later
3. Under "Signing & Capabilities":
   - Select your development team
   - Enable "Automatically manage signing"

#### Step 4: Build and Run
1. Select a simulator or connected device
2. Press `Cmd + R` or click the Play button
3. The app should build and launch successfully!

### Option 2: Using Provided Project Structure

If you prefer to use the provided Xcode project structure:

1. Open Terminal
2. Navigate to the project directory:
   ```bash
   cd FocusGarden/FocusGarden
   ```
3. Open the Xcode project:
   ```bash
   open FocusGarden.xcodeproj
   ```
4. Update the Bundle Identifier and Signing settings
5. Build and run

## Project Structure

```
FocusGarden/
├── FocusGarden/
│   ├── FocusGarden.xcodeproj/          # Xcode project file
│   └── FocusGarden/                    # Source code
│       ├── FocusGardenApp.swift        # App entry point
│       ├── Models/                     # Data models
│       │   ├── TimerSettings.swift
│       │   ├── Progress.swift
│       │   └── DailyRecord.swift
│       ├── ViewModels/                 # Business logic
│       │   ├── AppViewModel.swift
│       │   └── TimerViewModel.swift
│       ├── Views/                      # UI components
│       │   ├── ContentView.swift
│       │   ├── TimerView.swift
│       │   ├── GardenView.swift
│       │   ├── SettingsView.swift
│       │   ├── StatisticsView.swift
│       │   └── ProgressTrackerView.swift
│       ├── Managers/                   # Services
│       │   ├── StorageManager.swift
│       │   └── SoundManager.swift
│       ├── Helpers/                    # Utilities
│       │   └── Extensions.swift
│       └── Info.plist                  # App configuration
└── iOS_README.md                       # Documentation
```

## Features Included

✅ **Pomodoro Timer**
- Focus, short break, and long break modes
- Circular progress indicator
- Customizable durations
- Auto-switching between modes

✅ **Virtual Garden**
- Trees grow with each Pomodoro
- Clouds unlock every 2 Pomodoros
- Animals unlock at milestones
- Beautiful animations

✅ **Statistics**
- Activity charts (iOS 16+ uses native Charts framework)
- 90-day activity calendar
- Key metrics and achievements
- Time range filtering

✅ **Settings**
- Adjustable timer durations
- Sound toggle
- Clean, modern UI

✅ **Local Storage**
- All data persisted with UserDefaults
- No backend required
- Automatic daily tracking

## Troubleshooting

### Build Errors

**Problem**: "Module 'Charts' not found"
- **Solution**: Charts framework requires iOS 16.0+. The app includes a fallback for iOS 15, but for full features, use iOS 16+.

**Problem**: Signing errors
- **Solution**:
  1. Select your project in Xcode
  2. Go to Signing & Capabilities
  3. Select your development team
  4. Update Bundle Identifier if needed

**Problem**: "Cannot find type 'XXX' in scope"
- **Solution**: Make sure all files are added to the target:
  1. Select the file in navigator
  2. Check "Target Membership" in inspector
  3. Ensure FocusGarden is checked

### Runtime Issues

**Problem**: App crashes on launch
- **Solution**:
  1. Clean build folder: `Cmd + Shift + K`
  2. Delete derived data: `Cmd + Shift + K` then quit Xcode
  3. Restart Xcode and rebuild

**Problem**: No sound on timer completion
- **Solution**:
  1. Check device is not on silent mode
  2. Enable sound in Settings
  3. Check device volume

## iOS Versions

- **iOS 15.0+**: Full functionality with fallback chart implementation
- **iOS 16.0+**: Native Charts framework for enhanced statistics

## Device Support

- iPhone (all models)
- iPad (optimized layout)
- All orientations supported

## Next Steps

1. **Customize Colors**: Edit `Extensions.swift` to change the color scheme
2. **Add Widgets**: Implement iOS widgets for quick stats
3. **Add Notifications**: Request permission and send local notifications
4. **iCloud Sync**: Add CloudKit for multi-device sync
5. **App Icon**: Design and add custom app icon

## Additional Resources

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [Combine Framework](https://developer.apple.com/documentation/combine)
- [UserDefaults Guide](https://developer.apple.com/documentation/foundation/userdefaults)
- [Charts Framework](https://developer.apple.com/documentation/charts)

## Need Help?

If you encounter issues:
1. Check the console for error messages
2. Verify all files are properly added to the target
3. Ensure deployment target is set correctly
4. Try cleaning and rebuilding the project

---

**Happy coding! 🚀**
