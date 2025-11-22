# Fixing Build Errors - Quick Guide

## Problem
Xcode created default files when you set up the project, which are now conflicting with our files.

## Solution - Follow These Steps:

### Step 1: Clean the Project
1. In Xcode, go to **Product** → **Clean Build Folder** (or press `Shift + Cmd + K`)

### Step 2: Remove Duplicate Files
You likely have TWO ContentView files in your project. Here's how to fix it:

1. In Xcode's Project Navigator (left sidebar), look for:
   - `ContentView.swift` (the default one Xcode created)
   - Our `Views/ContentView.swift` (the one we want to keep)

2. **DELETE the default ContentView.swift** (NOT the one in the Views folder):
   - Right-click on the duplicate `ContentView.swift`
   - Choose "Delete"
   - Select "Move to Trash" (not just "Remove Reference")

### Step 3: Check for Default FocusGardenApp.swift
1. Look for a default `FocusGardenApp.swift` in the root of your project
2. If there's a duplicate, delete the OLD one and keep ours

### Step 4: Verify File Structure
Your project should look like this in Xcode:

```
FocusGarden/
├── FocusGardenApp.swift          ← Keep this one
├── Models/
│   ├── TimerSettings.swift
│   ├── Progress.swift
│   └── DailyRecord.swift
├── ViewModels/
│   ├── AppViewModel.swift
│   └── TimerViewModel.swift
├── Views/
│   ├── ContentView.swift         ← Keep this one
│   ├── TimerView.swift
│   ├── GardenView.swift
│   ├── SettingsView.swift
│   ├── StatisticsView.swift
│   └── ProgressTrackerView.swift
├── Managers/
│   ├── StorageManager.swift
│   └── SoundManager.swift
├── Helpers/
│   └── Extensions.swift
└── Info.plist
```

### Step 5: Clean Again and Build
1. **Product** → **Clean Build Folder** (`Shift + Cmd + K`)
2. **Product** → **Build** (`Cmd + B`)

---

## Alternative: Fresh Start (If above doesn't work)

If you're still having issues, here's the cleanest approach:

### 1. Create a Fresh Xcode Project:
```bash
# In Xcode:
File → New → Project
Choose: iOS → App
Product Name: FocusGarden
Interface: SwiftUI
Language: Swift
```

### 2. Delete Default Files:
- Delete `ContentView.swift` (the one Xcode just created)
- Delete `FocusGardenApp.swift` (the one Xcode just created)

### 3. Add Our Files:
- Drag the entire `FocusGarden` folder contents from Finder into your Xcode project
- Make sure to check:
  - ✅ Copy items if needed
  - ✅ Create groups
  - ✅ Add to target: FocusGarden

### 4. Build:
- Press `Cmd + B` to build
- Should work now! ✅

---

## Still Having Issues?

If you see other errors, share them and I'll help fix them!
