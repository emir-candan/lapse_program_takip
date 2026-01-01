# Lapse System Guide (Sistem Rehberi)

Bu rehber, Lapse projesinin mimari, tasarım, layout ve kodlama standartlarını belirleyen **TEK VE KESİN** kaynaktır. Projeye katkıda bulunan herkesin bu kurallara uyması zorunludur.

---

## 🏗 1. Mimari Katmanlar

Sistem 4 ana katmandan oluşur. Bu hiyerarşi bozulamaz.

| Katman | Konum | Görev |
| :--- | :--- | :--- |
| **1. KONTROL (Theme)** | `lib/core/theme/app_theme.dart` | **Tek Gerçek.** Renkler (`AppColors`) ve Tokenlar (`AppTokens`) burada tanımlanır. |
| **2. MOTOR (Engine)** | `lib/core/theme/app_design_system.dart` | `ThemeData` üretim merkezi. `AppTheme` verilerini Flutter'a işler. |
| **3. BİLEŞENLER (UI)** | `lib/core/components/` | Standart UI elemanları (`AppButton`, `AppCard` vb.). Asla ham Flutter widget'ı kullanma. |
| **4. LAYOUT (Page)** | `lib/features/layout/` | Sayfa iskeletleri ve navigasyon yapısı. |

---

## 🎨 2. Tasarım Sistemi (Design System)

Tasarım sistemi **Moon Design** üzerine kuruludur ancak **kendi kurallarımızla** yönetilir.

### 2.1 Renk Sistemi (AppColors)
`MoonColors` **KULLANILAMAZ**. Yerine `AppTheme.colors(context)` kullanılır.

| İsim | Erişim | Açıklama |
| :--- | :--- | :--- |
| **Brand** | `AppTheme.colors(context).brand` | Ana marka rengi (Yeşil). |
| **On Brand** | `AppTheme.colors(context).onBrand` | Marka rengi üzerindeki metin/ikon (Beyaz). |
| **Background** | `AppTheme.colors(context).background` | Sayfa arka planı. |
| **Surface** | `AppTheme.colors(context).surface` | Kart ve modal yüzeyleri. |
| **Text Primary** | `AppTheme.colors(context).textPrimary` | Ana başlıklar ve metinler. |
| **Text Secondary**| `AppTheme.colors(context).textSecondary`| Açıklama ve pasif metinler. |
| **Border** | `AppTheme.colors(context).border` | Çerçeveler ve ayırıcılar. |
| **Error** | `AppTheme.colors(context).error` | Hata durumları (Lapse uyumlu kırmızı). |
| **Success** | `AppTheme.colors(context).success` | Başarı durumları (Yeşil). |
| **Warning** | `AppTheme.colors(context).warning` | Uyarı durumları (Amber). |

### 2.2 Yapısal Tokenlar (AppTokens)
Boyutlandırma ve boşluklar için statik tokenlar kullanılır (`AppTheme.tokens`).

*   **Spacing:** `spacingXs` (4), `spacingSm` (8), `spacingMd` (16), `spacingLg` (24), `spacingXl` (32)
*   **Radius:** `radiusSm` (8), `radiusMd` (12), `radiusLg` (16)

> ❌ **YASAK:** `SizedBox(height: 16)`
> ✅ **DOĞRU:** `SizedBox(height: AppTheme.tokens.spacingMd)`

---

## 📐 3. Layout Sistemi

Tüm sayfalar tutarlı bir iskelet kullanmalıdır.

### 3.1 Ana İskelet (MainLayout)
Uygulamanın çatısıdır.
*   **Navigation:** Tüm platformlarda (Desktop/Mobile) sol üstten açılan `Drawer` kullanılır.
*   **Global AppBar:** (Renk: `app_theme.sidebar`, Hafif gölgeli). Başlık ortadadır.


### 3.2 Sayfa Yapısı (AppPageLayout)
Her sayfa içeriği `AppPageLayout` ile sarmalanmalıdır. 

**Not:** `title` parametresi sayfa gövdesinde **GÖSTERİLMEZ**. Bu başlık, `MainLayout` tarafından yakalanır ve en üstteki global AppBar'da ortalanmış olarak gösterilir.

```dart
return AppPageLayout(
  title: "Sayfa Başlığı",
  subtitle: "Opsiyonel açıklama", // Otomatik textSecondary rengini alır
  trailing: IconButton(...), // Sağ üst köşe butonu
  child: Content(),
);
```

---

## 🧩 4. Bileşen Kullanımı (Components)

### 4.1 Temel Kurallar
1.  **Flutter Widget'larını Sar:** `ElevatedButton` yerine `AppButton`, `TextField` yerine `AppTextInput` kullan.
2.  **Renkleri Elle Verme:** `Color(0xFF...)` yasak. `AppTheme.colors(context).xyz` kullan.
3.  **Responsive Düşün:** `AppPageLayout` zaten responsive padding sağlar. Ekstra `Padding` eklerken dikkatli ol.

### 4.2 Sık Kullanılanlar

| Bileşen | Kullanım Amacı | Örnek |
| :--- | :--- | :--- |
| `AppButton` | Ana aksiyonlar | `AppButton(label: "Kaydet", onTap: ...)` |
| `AppCard` | İçerik gruplama | `AppCard(child: ...)` (Gölge ve border otomatiktir) |
| `AppTextInput`| Form girişleri | `AppTextInput(hintText: "Adınız")` |
| `AppDivider` | Ayırıcı çizgi | `AppDivider()` (Rengi otomatiktir) |
| `AppEmptyState`| Veri yoksa | `AppEmptyState(message: "Kayıt bulunamadı")` |

---

## 🚦 5. Navigasyon & Router

*   **GoRouter** kullanılır.
*   Geçiş animasyonları `NoTransitionPage` ile kapatılmıştır (Web hissi için).
*   Ana rotalar `ShellRoute` içindedir (`/dashboard`, `/programs`, `/settings`).


---

## 🚀 6. Yeni Sayfa Oluşturma Rehberi

Yeni bir ekran tasarlarken aşağıdaki adımları takip etmek **zorunludur**. Her şey belirlenen temel üzerine inşa edilmelidir.

### 6.1 Kontrol Listesi
1.  **State Yönetimi:** Sayfa `ConsumerWidget` veya `ConsumerStatefulWidget` olmalı.
2.  **Renk Erişimi:** Rengi asla elle verme. `Widgets build` metodunun en başında renkleri al:
    ```dart
    final colors = AppTheme.colors(context);
    ```
3.  **İskelet:** `Scaffold` kullanma. İçeriği `AppPageLayout` ile sarmala.
4.  **Responsive:** Sabit genişlik (`width: 300`) verme. Mobilde taşar. `Expanded`, `Flexible` veya `LayoutBuilder` kullan.

### 6.2 Örnek Sayfa Şablonu

```dart
class NewPageScreen extends ConsumerWidget {
  const NewPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Temel renkleri al
    final colors = AppTheme.colors(context);

    // 2. Layout ile sarmala
    return AppPageLayout(
      title: "Yeni Sayfa",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 3. Bileşenleri kullan
          AppCard(
            child: Text(
              "İçerik buraya gelecek.",
              // 4. Renkleri sistemden al
              style: TextStyle(color: colors.textPrimary),
            ),
          ),
          const SizedBox(height: AppTheme.tokens.spacingMd), // 5. Token kullan
          AppButton(
            label: "Kaydet",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
```

---

## 🚫 SIFIR TOLERANS KURALLARI

1.  `context.moonColors` veya başka bir şekilde renk kullanmak **YASAKTIR**. -> `AppTheme.colors(context)` kullan.
2.  `colors.dart` içine yeni renk eklemek **YASAKTIR**. -> `app_theme.dart` içindeki `AppColors` sınıfını genişlet.
3.  Sayfalarda `Scaffold` kullanmak (MainLayout hariç) **YASAKTIR**. -> `AppPageLayout` kullan.
4.  Butonlara `style: ButtonStyle(...)` ile manuel stil vermek **YASAKTIR**. -> `AppButton` parametrelerini kullan.
