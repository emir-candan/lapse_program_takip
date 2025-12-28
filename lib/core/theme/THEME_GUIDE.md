# Lapse Program Takip - Tema ve Tasarım Kılavuzu

Bu belge, **Lapse** projesi için tasarım sistemi ve tema kurallarını içerir. Projede **Moon Design System** kullanılmaktadır ve tüm görsel geliştirmeler bu kurallara uymak zorundadır.

## 1. Genel Mimari

Uygulamamız **Flutter Moon Design** paketini temel alır ve `ThemeExtension` yapısını kullanır. 
Tema yönetimi `Riverpod` + `Hive` ile sağlanır ve `main.dart` içerisinde `MaterialApp` seviyesinde enjekte edilir.

- **Tema Dosyası**: `lib/core/theme/app_theme.dart` (Tek Gerçek Kaynak)
- **Tema Sağlayıcı**: `lib/core/theme/theme_provider.dart`

## 2. Renklerin Kullanımı

Uygulama içerisinde **kesinlikle** hard-coded (elle yazılmış) renk kodları (`Colors.red`, `Color(0xFF...)`) kullanılmamalıdır. 
Bunun yerine Moon Design tokenları kullanılmalıdır. Bu sayede Aydınlık (Light) ve Karanlık (Dark) mod geçişleri sorunsuz çalışır.

### Rengi Nasıl Alırım?

`AppTheme` içerisinde `MoonTheme` bir `ThemeExtension` olarak tanımlanmıştır.

```dart
// Önerilen Kullanım (Eğer BuildContext extension varsa):
final colors = context.moonTheme!.tokens.colors;

// Alternatif (Standart Flutter Yolu):
final moonTheme = Theme.of(context).extension<MoonTheme>()!;
final colors = moonTheme.tokens.colors;

// Örnek:
Container(
  color: colors.goku, // Arka plan rengi (Goku)
  child: Text("Merhaba", style: TextStyle(color: colors.piccolo)) // Ana marka rengi (Piccolo)
)
```

### Önemli Renk İsimleri (Moon Design Terminolojisi)
- **Piccolo**: Ana marka rengi (Primary). Genelde butonlar ve vurgular için.
- **Goku**: Ana arka plan rengi (Scaffold background).
- **Beerus**: İkincil arka plan, kartlar veya yüzeyler.
- **Bulma**: Ana metin rengi.
- **Trunks**: İkincil metin rengi (açıklamalar vs).
- **Chichi**: Hata rengi (Error).

## 3. Widget Kuralları

Görsel bütünlük için standart Flutter widgetları yerine **Moon Design** widgetları tercih edilmelidir.

| Standart Widget | Moon Design Karşılığı | Notlar |
|-----------------|-----------------------|--------|
| `ElevatedButton`| `MoonFilledButton`    | Dolu butonlar için |
| `OutlinedButton`| `MoonOutlinedButton`  | Çerçeveli butonlar için |
| `TextField`     | `MoonTextInput`       | Form alanları için |
| `Switch`        | `MoonSwitch`          | - |
| `CircularProgressIndicator` | `MoonCircularLoader` | - |

**Kural:** Eğer Moon Design kütüphanesinde karşılığı varsa, mutlaka onu kullanın.

## 4. Tipografi (Yazı Tipleri)

Yazı stilleri de tema üzerinden gelmelidir.

```dart
Text(
  "Başlık",
  style: context.moonTheme!.tokens.typography.heading.text24,
);
```

## 5. Tema Değiştirme Mantığı

Temayı değiştirmek için `themeProvider` kullanılır. Bu durum state yönetimini tetikler ve tüm uygulamayı yeniden çizer.

```dart
ref.read(themeProvider.notifier).toggleTheme();
// veya
ref.read(themeProvider.notifier).setTheme(ThemeMode.dark);
```

---
**Not:** Bu dosyada belirtilen kuralların dışına çıkmak "Görsel Tutarlılık" hatası olarak kabul edilir. Yeni bir renk veya stil eklemeniz gerekirse, önce `AppTheme` dosyasını güncelleyin, asla yerel widget içinde stil tanımlamayın.
