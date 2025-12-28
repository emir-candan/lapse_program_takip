# Lapse Design System (Tasarım Sistemi) Rehberi

Lapse, **Moon Design** üzerine inşa edilmiş, katı ve tamamen merkezi bir tasarım sistemine sahiptir. Bu rehber, projenin görsel dünyasının nasıl yönetildiğini, yeni bileşenlerin nasıl eklendiğini ve kuralları anlatır.

## 🏗 Mimari Yapı

Sistem 3 ana katmandan oluşur. Hiyerarşiye uymak zorunludur.

| Katman | Dosya Yolu | Görevi |
| :--- | :--- | :--- |
| **1. KONTROL MERKEZİ (Config)** | `lib/core/theme/app_theme.dart` | **BURAYI DÜZENLE.** Tüm renkler, boyutlar, boşluklar burada tanımlıdır. |
| **2. MOTOR (Engine)** | `lib/core/theme/app_design_system.dart` | **DOKUNMA.** Burası `AppTheme` kurallarını alır ve Flutter/Moon bileşenlerine zorla uygular. |
| **3. BİLEŞENLER (Wrappers)** | `lib/core/components/` | **KULLAN.** Standartlaştırılmış (`AppButton`, `AppTextInput` vb.) bileşenlerdir. |

---

## 🎨 Tasarım Felsefesi: "Tek Noktadan Yönetim"

Bu projede "Hardcoded" (elle yazılmış) stile **İZİN VERİLMEZ**.
`Padding(padding: EdgeInsets.all(8))` yazamazsınız.❌
`Padding(padding: AppTheme.tokens.spacingSm)` yazmalısınız. ✅

### Miras Alma (Inheritance) Mantığı
Stiller birbirine bağlıdır. Ana bir değeri değiştirdiğinizde, ona bağlı her şey değişir.

*   `radiusMd` (12.0) değişirse -> `AppCard`, `AppImage`, `AppSkeleton` hepsi aynı anda güncellenir.
*   `spacingSm` (8.0) değişirse -> Input boşlukları, buton paddingleri, etiket aralıkları güncellenir.

Bu sayede, "Uygulamayı daha köşeli yapalım" dediğinizde 30 dosyayı değil, sadece `app_theme.dart` içindeki tek bir satırı değiştirirsiniz.

---

## 🛠 Nasıl Kullanılır?

### 1. Mevcut Bir Stili Değiştirmek
Örneğin: "Kartların gölgesini veya paddingini değiştirmek istiyorum."

1.  `lib/core/theme/app_theme.dart` dosyasını açın.
2.  `_AppTokens` sınıfına gidin.
3.  `cardPadding` veya `cardShadowLight` değerini bulun ve değiştirin.
4.  Kaydedin. Tüm uygulama anında güncellenir.

### 2. Yeni Bir Bileşen Eklemek
Örneğin: `AppBadge` adında yeni bir bileşen yapacaksınız.

1.  **Dosyayı Oluştur:** `lib/core/components/display/app_badge.dart`
2.  **Wrappe'ı Yaz:** Moon veya Flutter bileşenini sarmalayın.
3.  **Token Bağla:** Asla `borderRadius: BorderRadius.circular(4)` yazma.
    *   Eğer `AppTheme.tokens` içinde uygun bir token varsa (örneğin `radiusXs`) onu kullan.
    *   Yoksa `AppTheme.dart`'a git, `_AppTokens` altına `double get badgeRadius => radiusXs;` ekle.
4.  **Export Et:** `lib/core/components/components.dart` dosyasına ekle.

### 3. Yeni Bir Tema Eklemek
Örneğin: "Yılbaşı Teması" veya "OLED Dark Mode".

1.  `app_theme.dart` içinde yeni renk paletleri tanımlayın.
2.  `lightTheme` ve `darkTheme` getter'ları gibi yeni bir getter ekleyin (örn: `oledTheme`).
3.  `AppDesignSystem.getStrictTheme` metodunu çağırarak bu yeni renkleri geçirin.

---

## 🚫 SIFIR TOLERANS (Zero Tolerance) Kuralları

Bu proje "canlıya çıkacak" bir üründür. Aşağıdaki hataların yapılması kesinlikle yasaktır:

1.  **ASLA Hardcoded Değer Kullanma:** `SizedBox(height: 16)` yasak. `AppTheme.tokens.spacingMd` kullan.
2.  **ASLA Raw Widget Kullanma:** `TextFormField` yasak. `AppTextInput` kullan.
3.  **ASLA Renkleri Elle Verme:** `Colors.red` yasak. `context.moonColors.chiChi` veya benzeri anlamsal (semantic) renkleri kullan.

### Renk vs Yapı (Context vs Static)
*   **RENKLER (Dynamic):** Renkler her zaman `context.moonColors` veya `Theme.of(context)` üzerinden alınmalıdır. Dark mode böyle çalışır.
*   **YAPI (Static):** Boyutlar, paddingler, radiuslar `AppTheme.tokens` üzerinden alınmalıdır. Bu değerler tema değişince değişmez, sistemin iskeletidir.

---

## 🔋 Bileşen Yetenekleri

Bileşenlerimiz sadece görsel değil, fonksiyonel olarak da güçlendirilmiştir.

### `AppTextInput`
Standart bir inputtan fazlasıdır.
*   `keyboardType`: Klavye tipini belirleyin (örn: `TextInputType.phone`).
*   `inputFormatters`: Girişi formatlayın (örn: Teleon maskesi, sadece rakam).
*   `textAlign`: Metni hizalayın.
*   `onFieldSubmitted`: Klavye "Tamam" tuşu aksiyonunu yakalayın.

### `AppModal`
*   **Toast Mesajları:** Standart siyah SnackBar yerine modern `MoonToast` kullanır.
    ```dart
    AppModal.showToast(context: context, message: "İşlem Başarılı");
    ```

---

## 🚫 Yapılmaması Gerekenler

*   **ASLA** bileşen dosyalarının içinde (`app_card.dart` vb.) `Colors.red` veya `16.0` gibi sabit değerler kullanmayın.
*   **ASLA** `AppDesignSystem.dart` dosyasını, sistemin çekirdeğini bozacak şekilde değiştirmeyin.
*   **ASLA** flutter'ın standart `ElevatedButton` veya `TextField` bileşenlerini doğrudan sayfalarınızda kullanmayın. Her zaman `App...` ile başlayan wrapperları kullanın.

## 🚀 Özet

*   **Değişiklik mi lazım?** -> `AppTheme.dart`
*   **Kod mu yazıyorsun?** -> `AppTheme.tokens` kullan.
*   **Yeni ekran mı?** -> `lib/core/components/` altındaki bileşenleri kullan.

Bu kurallara uyduğunuz sürece projeniz her zaman tutarlı, şık ve bakımı kolay kalacaktır.
