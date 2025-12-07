# Настройка Live Activity и Dynamic Island

## 🎯 Что сделано

Реализована полная поддержка Live Activities с отображением в Dynamic Island для iPhone 14 Pro и новее.

## 📱 Возможности

- **Dynamic Island**: компактный, минимальный и расширенный виды
- **Lock Screen**: баннер с прогресс-баром
- **Автообновление**: каждую секунду
- **Цветовое кодирование**: разные цвета для Focus/Break/Long Break

## ⚡️ Быстрый старт (5 минут)

### 1. Откройте проект в Xcode
```bash
open focusgarden.xcodeproj
```

### 2. Создайте Widget Extension
1. `File → New → Target...`
2. Выберите **Widget Extension**
3. Настройки:
   - Product Name: `FocusGardenWidget`
   - Bundle ID: `com.yourcompany.focusgarden.FocusGardenWidget`
   - **✅ Include Live Activity** (обязательно!)
4. Нажмите **Finish** → **Cancel** (не активируйте схему)

### 3. Удалите автоматически созданные файлы
В папке `FocusGardenWidget` удалите:
- ❌ `FocusGardenWidgetLiveActivity.swift`
- ❌ `FocusGardenWidgetBundle.swift`
- ❌ `FocusGardenWidget.swift` (если есть)

**Сохраните**:
- ✅ `Assets.xcassets`
- ✅ `Info.plist`

### 4. Добавьте файлы в target

#### Файл FocusGardenWidget.swift:
1. Выберите `FocusGardenWidget/FocusGardenWidget.swift`
2. File Inspector (справа) → Target Membership
3. ✅ Поставьте галочку на `FocusGardenWidget`

**Примечание**: `TimerActivityAttributes` уже встроен в оба файла (TimerViewModel.swift и FocusGardenWidget.swift).

### 5. Настройте iOS Deployment Target
1. Выберите target `FocusGardenWidget`
2. Build Settings → iOS Deployment Target
3. Установите: **iOS 16.1** или выше

### 6. Запустите!
1. Выберите схему `focusgarden`
2. Выберите iPhone 14 Pro или новее
3. **Run** (⌘R)
4. Запустите таймер → свайпните домой
5. Live Activity в Dynamic Island! 🎉

## 🎨 Как выглядит

### Компактный Dynamic Island
```
[🧠] ..................... [25:00]
```

### Расширенный Dynamic Island (долгое нажатие)
- Название режима + иконка
- Прогресс-бар с процентами
- Оставшееся время / общее время
- Цветовая индикация

### Lock Screen
- Полная информация о таймере
- Визуальный прогресс-бар
- Большие цифры времени

## 🎨 Цвета режимов

| Режим | Цвет | Иконка |
|-------|------|--------|
| 🧠 Focus Time | Синий | brain.head.profile |
| ☕️ Short Break | Зеленый | cup.and.saucer |
| 🛋️ Long Break | Оранжевый | cup.and.saucer.fill |

## 🐛 Проблемы?

### "Module 'ActivityKit' not found"
→ Установите iOS Deployment Target >= 16.1

### Live Activity не запускается
→ Проверьте Settings → Face ID → Live Activities (включено)

### Dynamic Island не видно
→ Dynamic Island работает только на iPhone 14 Pro и новее
→ На других устройствах смотрите Lock Screen

### Ошибки компиляции
1. Product → Clean Build Folder (⌘⇧K)
2. Закройте Xcode
3. Удалите: `rm -rf ~/Library/Developer/Xcode/DerivedData`
4. Откройте проект снова

## 📂 Структура файлов

```
focusgarden/
├── FocusGarden/
│   ├── Info.plist ✅ (обновлен)
│   └── ViewModels/
│       └── TimerViewModel.swift ✅ (обновлен - содержит TimerActivityAttributes)
└── FocusGardenWidget/ 🆕
    ├── FocusGardenWidget.swift 🆕 (содержит TimerActivityAttributes)
    ├── Assets.xcassets/
    └── Info.plist
```

## ✅ Чеклист

- [ ] Widget Extension target создан
- [ ] Автосозданные файлы удалены
- [ ] FocusGardenWidget.swift добавлен в Widget target
- [ ] iOS Deployment Target >= 16.1
- [ ] Проект собирается без ошибок
- [ ] Запущено на iPhone 14 Pro или новее

## 📖 Полная документация

См. файл [LIVE_ACTIVITY_SETUP.md](LIVE_ACTIVITY_SETUP.md) для подробной информации.

---

**Время настройки**: 5 минут
**Результат**: Работающий Live Activity в Dynamic Island! 🚀
