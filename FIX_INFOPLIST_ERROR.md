# FIX: Info.plist Duplicate Error

## The Problem
```
Multiple commands produce '.../FocusGarden.app/Info.plist'
```

Modern iOS projects (iOS 13+) **auto-generate** Info.plist from the project settings. Our manual Info.plist file is conflicting with this.

## ✅ Solution (Choose ONE method)

---

### Method 1: Remove Info.plist from Build Phases (EASIEST)

1. **In Xcode, select your project** (top of Navigator)
2. **Select the "FocusGarden" target**
3. **Go to "Build Phases" tab**
4. **Expand "Copy Bundle Resources"**
5. **Find "Info.plist" in the list**
6. **Select it and press Delete (-)** button
7. **Clean and Build:**
   - Press `Shift + Cmd + K` (Clean)
   - Press `Cmd + B` (Build)

✅ **This is the recommended fix!**

---

### Method 2: Delete Info.plist Entirely

Since iOS 13+, you don't need a separate Info.plist file. Everything can be configured in the target settings.

1. **In Xcode Project Navigator:**
   - Find `Info.plist`
   - Right-click → Delete
   - Choose "Move to Trash"

2. **In Project Settings:**
   - Select project → Target → Build Settings
   - Search for "Info.plist File"
   - Clear the path (delete the value)

3. **Clean and Build:**
   - `Shift + Cmd + K` → `Cmd + B`

---

### Method 3: Configure Build Settings

1. Select your project in Navigator
2. Select the "FocusGarden" target
3. Go to "Build Settings" tab
4. Search for: `INFOPLIST_FILE`
5. Delete the value or set it to empty
6. Clean and Build

---

## 🎯 Quick Fix Steps (Method 1 - Recommended)

```
1. Project Navigator → Click "FocusGarden" (project, not folder)
2. Select "FocusGarden" target (under TARGETS)
3. Click "Build Phases" tab
4. Expand "Copy Bundle Resources"
5. Find "Info.plist" → Select it → Click "-" button to remove
6. Shift + Cmd + K (Clean)
7. Cmd + B (Build)
```

---

## ⚙️ Alternative: Keep Info.plist but Configure Properly

If you want to keep the Info.plist file:

1. **Remove from Copy Bundle Resources** (as above)
2. **In Build Settings:**
   - Search "Generate Info.plist File"
   - Set to **NO**
   - Search "Info.plist File"
   - Set to: `FocusGarden/Info.plist`

3. **Clean and Build**

---

## 💡 Why This Happens

**Modern Xcode (iOS 13+):**
- Auto-generates Info.plist from target settings
- No separate file needed
- Our manual Info.plist conflicts with auto-generation

**The Info.plist we provided:**
- Was for reference/completeness
- Not actually needed for modern iOS apps
- Can be safely removed

---

## ✅ After the Fix

Your app will work perfectly without the Info.plist file. All settings (bundle ID, version, etc.) are in the project settings.

**The app configuration is now in:**
- Project Settings → General tab
- Project Settings → Info tab
- Project Settings → Signing & Capabilities

---

## 🚀 Expected Result

After applying the fix:
- Build should succeed
- App will run normally
- All features will work
- No Info.plist conflicts

---

## Still Having Issues?

If you still see errors:

1. **Clean Build Folder**: `Shift + Cmd + K`
2. **Delete Derived Data**:
   - Xcode → Settings → Locations
   - Click arrow next to DerivedData path
   - Delete the FocusGarden folder
3. **Restart Xcode**
4. **Build again**: `Cmd + B`

---

**Quick Test:**
After fixing, try building with `Cmd + B`. You should see "Build Succeeded" ✅
