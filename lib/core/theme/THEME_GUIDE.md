# Lapse Design System Guide

Lapse uses a strict, centralized design system built on top of Moon Design.

## 🏛 Architecture

| Layer | Path | Role |
| :--- | :--- | :--- |
| **1. Config** | `lib/core/theme/app_theme.dart` | **EDIT HERE.** Define colors, radius, fonts. |
| **2. Engine** | `lib/core/theme/app_design_system.dart` | **DO NOT TOUCH.** Enforces rules on Flutter & Moon. |
| **3. Wrappers** | `lib/core/components/` | **ALWAYS USE.** Standardized widgets. |

---

## 🧩 Components (The "App" Family)

Instead of using raw Flutter or Moon widgets, use these standardized wrappers. They guarantee adherence to strict theme rules (like that 5px border you love!).

### Form
*   `AppTextInput`: Standard input.
*   `AppSwitch`: Toggle switch.
*   `AppCheckbox`: Checkbox with optional label.
*   `AppRadio`: Radio button.

### Feedback
*   `AppLoader`: Circular spinner.
*   `AppAlert`: Validations / Info boxes.
*   `AppChip`: Rounded chips/tags.

### Display
*   `AppAvatar`: User profile images.
*   `AppTag`: Status labels.

### Actions
*   `AppButton`: Primary/Secondary buttons with loading state.

### Overlays
*   `AppModal.show(...)`: Standard bottom sheets.
*   `AppModal.showToast(...)`: Toast messages.

---

## 🎨 How it Works

When you change `_defaultRadius` to **60.0** in `app_theme.dart`:
1.  `AppDesignSystem` updates the `InputDecorationTheme`.
2.  `AppTextInput` uses that theme -> Takes **60px** radius.
3.  `AppDesignSystem` updates `MoonTheme.tokens.borders`.
4.  `AppButton` uses that token -> Takes **60px** radius.

Everything stays in sync.

### Adding New Components
1. Create a file in `lib/core/components/`.
2. Wrap the Moon widget.
3. Export it in `lib/core/components/components.dart`.
