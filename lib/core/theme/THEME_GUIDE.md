# Lapse Design System (Tasarım Sistemi) Rehberi

Lapse, **Moon Design** altyapısı üzerine kurulmuş, **Montserrat** tipografisi ve **Lapse Yeşili** marka kimliğiyle özelleştirilmiş, merkezi bir tasarım sistemidir. Bu rehber; projenin görsel dünyasının nasıl yönetildiğini, kuralları ve teknik altyapıyı anlatır.

---

## 🏗 Mimari Yapı

Sistem **4 ana katmandan** oluşur. Hiyerarşiye uymak zorunludur.

| Katman | Dosya Yolu | Görevi |
| :--- | :--- | :--- |
| **1. KONTROL MERKEZİ (Config)** | `lib/core/theme/app_theme.dart` | **BURAYI DÜZENLE.** Tüm renkler (Lapse Green), fontlar (Montserrat), boyutlar ve tokenler burada tanımlıdır. |
| **2. MOTOR (Engine)** | `lib/core/theme/app_design_system.dart` | **DOKUNMA.** Burası `AppTheme` kurallarını alır ve Flutter/Moon bileşenlerine zorla uygular. |
| **3. BİLEŞENLER (Wrappers)** | `lib/core/components/` | **KULLAN.** Standartlaştırılmış (`AppButton`, `AppTextInput` vb.) bileşenlerdir. |
| **4. BEYİN (State)** | `lib/core/theme/theme_provider.dart` | **YÖNET.** Kullanıcının tema tercihini (Açık/Koyu/Sistem) yönetir ve Hive'a kaydeder. |

---

## 🎨 Tasarım Dili & Kimlik

### 1. Renk Paleti (Lapse Green & Zinc)

Markamızın ana rengi **Yeşil**dir. Ancak göz konforu ve profesyonellik için iki varyasyon kullanılır:

| Mod | Ana Renk | Arka Plan |
| :--- | :--- | :--- |
| **Light Mode** | Canlı, enerjik yeşil (`#079F00`) | Slate (Mavimsi) |
| **Dark Mode** | Tok, doygun yeşil (`#057A00`) | Zinc (Nötr/Mat Siyah) |

> [!NOTE]
> Koyu modda "Renk Titreşimi"ni (Color Vibration) önlemek için mavi tonlar arka plandan kaldırılmıştır.

### 2. Tipografi (Montserrat)

Uygulamanın tamamında **Google Fonts: Montserrat** kullanılır.

*   `AppTheme` üzerinden tüm metin stillerine (Headings, Body, Button vb.) otomatik enjekte edilir.
*   **Web Splash:** `index.html` dosyasında da manuel olarak import edilmiştir, böylece açılışta font değişimi yaşanmaz.

### 3. Miras Alma (Inheritance) Mantığı

Stiller birbirine bağlıdır. Ana bir değeri değiştirdiğinizde, ona bağlı her şey değişir.

*   `radiusMd` (12.0) değişirse → `AppCard`, `AppImage`, `AppSkeleton`, `AppTextInput` hepsi güncellenir.
*   `spacingSm` (8.0) değişirse → Input boşlukları, buton paddingleri, etiket aralıkları güncellenir.

---

## 🛠 Nasıl Kullanılır?

### 1. Tema Tercihini Değiştirmek

Kullanıcı temasını değiştirmek için `ref.read(themeProvider.notifier)` kullanılır. **Riverpod 2.0+ Notifier** yapısı geçerlidir.

| Yöntem | Açıklama |
| :--- | :--- |
| `toggleTheme()` | Tek tuşla geçiş (Koyu ↔ Açık) |
| `setTheme(ThemeMode.system)` | Belirli mod (`.light`, `.dark`, `.system`) |

### 2. Mevcut Bir Stili Değiştirmek

Örneğin: "Kartların gölgesini değiştirmek istiyorum."

1.  `lib/core/theme/app_theme.dart` dosyasını açın.
2.  `_AppTokens` sınıfına gidin.
3.  `cardShadowLight` veya `cardShadowDark` değerini değiştirin.
4.  Kaydedin. Tüm uygulama anında güncellenir.

### 3. Yeni Bir Bileşen Eklemek

Örneğin: `AppBadge` adında yeni bir bileşen yapacaksınız.

1.  **Dosyayı Oluştur:** `lib/core/components/display/app_badge.dart`
2.  **Wrappe'ı Yaz:** Moon veya Flutter bileşenini sarmalayın.
3.  **Token Bağla:** Asla `borderRadius: BorderRadius.circular(4)` yazma.
    *   Eğer `AppTheme.tokens` içinde uygun bir token varsa (örneğin `radiusXs`) onu kullan.
4.  **Export Et:** `lib/core/components/components.dart` dosyasına ekle.

---

## 🌐 Web Entegrasyonu (Splash Screen)

Flutter yüklenmeden önce görünen `web/index.html` dosyası, `AppTheme` ile **manuel senkronize** edilmiştir. Bu dosya Flutter dışındadır, bu yüzden buradaki değişiklikler oraya otomatik yansımaz.

| Alan | Açıklama |
| :--- | :--- |
| **Renkler** | CSS değişkenleri (`:root`) AppTheme renk kodlarıyla eşlenmelidir. |
| **Font** | Montserrat fontu `<head>` içinde önceden yüklenir. |
| **Logic** | Logo takılmasını önlemek için script, yükleme bitince kendini DOM'dan siler (`remove()`). |

---

## 🚫 SIFIR TOLERANS (Zero Tolerance) Kuralları

Bu proje "canlıya çıkacak" bir üründür. Aşağıdaki hataların yapılması **kesinlikle yasaktır:**

| ❌ YASAK | ✅ DOĞRU |
| :--- | :--- |
| `SizedBox(height: 16)` | `AppTheme.tokens.spacingMd` |
| `TextFormField` | `AppTextInput` |
| `Colors.red` | `context.moonColors.chiChi` veya AppTheme anlamsal renkleri |

### Renk vs Yapı (Context vs Static)

| Kategori | Kaynak | Açıklama |
| :--- | :--- | :--- |
| **RENKLER (Dynamic)** | `context.moonColors` veya `Theme.of(context)` | Dark mode böyle çalışır. |
| **YAPI (Static)** | `AppTheme.tokens` | Boyutlar, paddingler, radiuslar. Tema değişince değişmez, sistemin iskeletidir. |

---

## 🔋 Bileşen Yetenekleri

Bileşenlerimiz sadece görsel değil, fonksiyonel olarak da güçlendirilmiştir.

### `AppTextInput`

Standart bir inputtan fazlasıdır.

| Parametre | Açıklama |
| :--- | :--- |
| `keyboardType` | Klavye tipini belirleyin |
| `inputFormatters` | Girişi formatlayın |
| `textAlign` | Metni hizalayın |
| `onFieldSubmitted` | "Tamam" tuşu aksiyonunu yakalayın |

### `AppModal`

**Toast Mesajları:** Standart SnackBar yerine modern `MoonToast` kullanır.

```dart
AppModal.showToast(context: context, message: "İşlem Başarılı");
```

---

## � Özet

| İhtiyaç | Çözüm |
| :--- | :--- |
| Tasarım ayarı mı? | → `AppTheme.dart` |
| Kod mu yazıyorsun? | → `AppTheme.tokens` kullan |
| Tema mı değişecek? | → `themeProvider` kullan |
| Web Splash mi? | → `web/index.html` (Manuel düzenle) |

Bu kurallara uyduğunuz sürece projeniz her zaman **tutarlı**, **şık** ve **bakımı kolay** kalacaktır.
