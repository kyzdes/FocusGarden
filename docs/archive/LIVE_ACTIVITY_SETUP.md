# Настройка Live Activity и Dynamic Island

## Проблема

Live Activity не отображается, потому что в проекте отсутствует Widget Extension target. Файлы для Widget Extension уже созданы (`FocusGardenWidget/FocusGardenWidget.swift`), но не добавлены в проект.

## Решение: Создание Widget Extension target вручную

### Шаг 1: Создайте Widget Extension target в Xcode

1. Откройте `focusgarden.xcodeproj` в Xcode
2. В Project Navigator выберите проект (синяя иконка сверху)
3. В левом столбце нажмите кнопку **"+"** внизу списка targets
4. Выберите **"Widget Extension"**
5. Настройки:
   - **Product Name**: `FocusGardenWidget`
   - **Include Configuration Intent**: ❌ Снимите галочку
   - **Include Live Activity**: ✅ Установите галочку
6. Нажмите **Finish**
7. Когда появится диалог "Activate scheme?", нажмите **Activate**

### Шаг 2: Удалите auto-generated файлы

Xcode создаст несколько файлов автоматически. Удалите их:

1. В Project Navigator найдите папку `FocusGardenWidget`
2. Удалите эти файлы:
   - `FocusGardenWidgetLiveActivity.swift` (создан Xcode)
   - `FocusGardenWidgetBundle.swift` (создан Xcode)
   - `AppIntent.swift` (если есть)

### Шаг 3: Добавьте существующий файл в target

1. Найдите существующий файл `FocusGardenWidget/FocusGardenWidget.swift`
2. Выберите файл в Project Navigator
3. В File Inspector (справа) найдите секцию **Target Membership**
4. Установите галочку напротив **FocusGardenWidget** target

### Шаг 4: Настройте Info.plist Widget Extension

1. Выберите **FocusGardenWidget** target в Project Settings
2. Вкладка **Info**
3. Добавьте следующие ключи:
   ```xml
   <key>NSSupportsLiveActivities</key>
   <true/>
   <key>NSSupportsLiveActivitiesFrequentUpdates</key>
   <true/>
   ```

### Шаг 5: Проверьте Bundle Identifier

1. Выберите **FocusGardenWidget** target
2. Вкладка **General** → **Identity**
3. Bundle Identifier должен быть: `com.kyzdes.testfocusgardenapp.FocusGardenWidget`

### Шаг 6: Настройте Capabilities

**Для основного target (focusgarden):**
1. Выберите **focusgarden** target
2. Вкладка **Signing & Capabilities**
3. Нажмите **"+ Capability"**
4. Добавьте **"Push Notifications"**

**Для Widget Extension (FocusGardenWidget):**
1. Выберите **FocusGardenWidget** target
2. Вкладка **Signing & Capabilities**
3. Используйте тот же Team для подписи

### Шаг 7: Пересоберите проект

```bash
xcodebuild -project focusgarden.xcodeproj \
  -scheme focusgarden \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  clean build
```

## Альтернативное решение (временное)

Если вы не хотите создавать Widget Extension сейчас, можно временно отключить Live Activity:

1. Откройте `FocusGarden/ViewModels/TimerViewModel.swift`
2. Закомментируйте все вызовы Live Activity:

```swift
// Закомментируйте эти строки:
// #if canImport(ActivityKit)
// startLiveActivity(totalSeconds: totalTime, remaining: timeLeft)
// #endif

// #if canImport(ActivityKit)
// self.updateLiveActivity(remaining: remaining)
// #endif

// #if canImport(ActivityKit)
// endLiveActivity()
// #endif
```

## Проверка работы

После настройки Widget Extension:

1. Запустите приложение на симуляторе iPhone 17 Pro (или реальном устройстве)
2. Запустите таймер
3. Свайпните вниз от правого верхнего угла → увидите Dynamic Island с таймером
4. Заблокируйте экран → увидите Live Activity на экране блокировки

## Примечания

- Live Activity работает только на iOS 16.1+
- Dynamic Island работает только на iPhone 14 Pro и новее
- На симуляторе Dynamic Island может отображаться не так как на реальном устройстве
- Live Activity автоматически закрывается когда таймер заканчивается

## Текущий статус

- ✅ Код Live Activity написан (`FocusGardenWidget.swift`)
- ✅ `Info.plist` основного приложения настроен (`NSSupportsLiveActivities`)
- ✅ `TimerViewModel` вызывает `LiveActivityManager`
- ❌ Widget Extension target не создан в проекте
- ❌ Widget Extension файлы не добавлены в build

После выполнения этих шагов Live Activity должно заработать!
