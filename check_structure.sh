#!/bin/bash

# Script to check the Focus Garden project structure
# Run this to verify your files are in the correct location

echo "═══════════════════════════════════════════════════"
echo "  Focus Garden - Project Structure Checker"
echo "═══════════════════════════════════════════════════"
echo ""

PROJECT_DIR="FocusGarden/FocusGarden"

if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ Error: Could not find $PROJECT_DIR directory"
    echo "   Make sure you're running this from the FocusGarden root folder"
    exit 1
fi

echo "✅ Found project directory"
echo ""

echo "Checking file structure..."
echo ""

# Check for main app file
if [ -f "$PROJECT_DIR/FocusGardenApp.swift" ]; then
    echo "✅ FocusGardenApp.swift"
else
    echo "❌ Missing: FocusGardenApp.swift"
fi

# Check Models
echo ""
echo "📁 Models:"
for file in TimerSettings.swift Progress.swift DailyRecord.swift; do
    if [ -f "$PROJECT_DIR/Models/$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ Missing: $file"
    fi
done

# Check ViewModels
echo ""
echo "📁 ViewModels:"
for file in AppViewModel.swift TimerViewModel.swift; do
    if [ -f "$PROJECT_DIR/ViewModels/$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ Missing: $file"
    fi
done

# Check Views
echo ""
echo "📁 Views:"
for file in ContentView.swift TimerView.swift GardenView.swift SettingsView.swift StatisticsView.swift ProgressTrackerView.swift; do
    if [ -f "$PROJECT_DIR/Views/$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ Missing: $file"
    fi
done

# Check Managers
echo ""
echo "📁 Managers:"
for file in StorageManager.swift SoundManager.swift; do
    if [ -f "$PROJECT_DIR/Managers/$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ Missing: $file"
    fi
done

# Check Helpers
echo ""
echo "📁 Helpers:"
if [ -f "$PROJECT_DIR/Helpers/Extensions.swift" ]; then
    echo "  ✅ Extensions.swift"
else
    echo "  ❌ Missing: Extensions.swift"
fi

# Check for potential duplicates
echo ""
echo "════════════════════════════════════════════════════"
echo "Checking for potential DUPLICATE files (these cause build errors):"
echo "════════════════════════════════════════════════════"
echo ""

DUPLICATES_FOUND=0

# Check for ContentView at root level (common issue)
if [ -f "$PROJECT_DIR/ContentView.swift" ]; then
    echo "⚠️  WARNING: Found ContentView.swift at root level"
    echo "   This is likely a duplicate created by Xcode"
    echo "   DELETE THIS FILE (keep the one in Views/ folder)"
    DUPLICATES_FOUND=1
fi

# Check for multiple FocusGardenApp files
APP_FILES=$(find "$PROJECT_DIR" -name "FocusGardenApp.swift" | wc -l)
if [ "$APP_FILES" -gt 1 ]; then
    echo "⚠️  WARNING: Found multiple FocusGardenApp.swift files:"
    find "$PROJECT_DIR" -name "FocusGardenApp.swift"
    echo "   Keep only the one at the root level"
    DUPLICATES_FOUND=1
fi

# Check for multiple ContentView files
CONTENT_FILES=$(find "$PROJECT_DIR" -name "ContentView.swift" | wc -l)
if [ "$CONTENT_FILES" -gt 1 ]; then
    echo "⚠️  WARNING: Found multiple ContentView.swift files:"
    find "$PROJECT_DIR" -name "ContentView.swift"
    echo "   Keep only the one in Views/ folder"
    DUPLICATES_FOUND=1
fi

if [ $DUPLICATES_FOUND -eq 0 ]; then
    echo "✅ No duplicate files found!"
fi

echo ""
echo "════════════════════════════════════════════════════"
echo "Summary:"
echo "════════════════════════════════════════════════════"

TOTAL_FILES=$(find "$PROJECT_DIR" -name "*.swift" | wc -l)
echo "Total Swift files: $TOTAL_FILES"
echo ""

if [ $DUPLICATES_FOUND -eq 1 ]; then
    echo "⚠️  ACTION REQUIRED: Remove duplicate files listed above"
    echo "   Then clean and rebuild in Xcode"
else
    echo "✅ Structure looks good!"
    echo "   If you're still having build errors, check QUICK_FIX.md"
fi

echo ""
echo "═══════════════════════════════════════════════════"
