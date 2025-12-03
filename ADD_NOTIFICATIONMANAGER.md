# Инструкция: Добавление NotificationManager.swift в Xcode

## Быстрые шаги

1. **Откройте Xcode проект:**
   ```bash
   open FocusGarden/FocusGarden.xcodeproj
   ```

2. **Добавьте файл в проект:**
   - В Project Navigator найдите папку `Managers`
   - Правой кнопкой → "Add Files to FocusGarden..."
   - Выберите файл: `FocusGarden/Managers/NotificationManager.swift`
   - ✅ Убедитесь, что галочка "Copy items if needed" СНЯТА (файл уже там)
   - ✅ Убедитесь, что Target "FocusGarden" выбран
   - Нажмите "Add"

3. **Проверьте импорт:**
   - Файл должен появиться в папке Managers рядом с SoundManager.swift
   - Если файл серый - проверьте Target Membership в правой панели

4. **Соберите проект:**
   ```
   ⌘ + B (Command + B)
   ```

5. **Если есть ошибки компиляции:**
   - Убедитесь, что все измененные файлы сохранены
   - Clean Build Folder: ⌘ + Shift + K
   - Пересоберите: ⌘ + B

---

## Альтернативный способ (если файл не виден)

Если файл NotificationManager.swift не отображается в Finder:

1. Создайте файл напрямую в Xcode:
   - Правой кнопкой на папке Managers
   - New File... → Swift File
   - Название: `NotificationManager`
   - Скопируйте содержимое из существующего файла

---

## Проверка

После добавления файла, проверьте что:
- [ ] NotificationManager.swift виден в Project Navigator
- [ ] Файл в папке Managers
- [ ] Target Membership включает FocusGarden
- [ ] Проект компилируется без ошибок
- [ ] При первом запуске появляется запрос на разрешение уведомлений

---

## Готово!

Теперь можно тестировать таймер в фоновом режиме! 🎉
