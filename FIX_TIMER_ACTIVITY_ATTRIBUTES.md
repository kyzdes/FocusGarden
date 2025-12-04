# Исправление ошибки "Cannot find type 'TimerActivityAttributes' in scope"

## ❌ Проблема

```
/Users/.../focusgarden/ViewModels/TimerViewModel.swift:361:36
Cannot find type 'TimerActivityAttributes' in scope
```

## ✅ Решение

Структура `TimerActivityAttributes` теперь определена **в обоих файлах**:

### 1. В основном приложении
**Файл**: `FocusGarden/ViewModels/TimerViewModel.swift` (строки 356-376)

```swift
#if canImport(ActivityKit)
@available(iOS 16.1, *)
struct TimerActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var remainingSeconds: Int
        public var totalSeconds: Int
        public var modeTitle: String
        // ...
    }
    public var title: String
    // ...
}
#endif
```

### 2. В Widget Extension
**Файл**: `FocusGardenWidget/FocusGardenWidget.swift` (строки 12-32)

```swift
@available(iOS 16.1, *)
struct TimerActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var remainingSeconds: Int
        public var totalSeconds: Int
        public var modeTitle: String
        // ...
    }
    public var title: String
    // ...
}
```

## 🔧 Почему так?

В iOS, Widget Extensions - это **отдельные targets** с собственным исполняемым кодом. Они не могут напрямую импортировать код из основного приложения.

**Два способа решения**:
1. ✅ **Дублировать структуру** в обоих файлах (использовано)
2. ❌ Создать shared framework (сложнее, требует настройки)

Для Live Activities дублирование структуры данных - **стандартная практика**.

## 📋 Что было сделано

1. ✅ Вернул определение `TimerActivityAttributes` в `TimerViewModel.swift`
2. ✅ Добавил то же определение в `FocusGardenWidget.swift`
3. ✅ Удалил папку `Shared/` (больше не нужна)
4. ✅ Обновил документацию

## ⚠️ Важно

Обе структуры **должны быть идентичны**:
- Одинаковые поля
- Одинаковые типы
- Одинаковый порядок

Иначе ActivityKit не сможет передать данные между приложением и виджетом.

## ✅ Проверка

Теперь проект должен компилироваться без ошибок:
```bash
# В Xcode:
Product → Clean Build Folder (⌘⇧K)
Product → Build (⌘B)
```

## 📚 Дополнительно

См. также:
- [LIVE_ACTIVITY_SETUP.md](LIVE_ACTIVITY_SETUP.md) - полная инструкция
- [ИНСТРУКЦИЯ_LIVE_ACTIVITY.md](ИНСТРУКЦИЯ_LIVE_ACTIVITY.md) - быстрый старт
- [LIVE_ACTIVITY_CHEATSHEET.md](LIVE_ACTIVITY_CHEATSHEET.md) - cheat sheet
